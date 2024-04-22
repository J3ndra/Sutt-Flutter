import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/reports/update_report/update_report_bloc.dart';

class SuttEditPage extends StatefulWidget {
  const SuttEditPage({super.key});

  @override
  State<SuttEditPage> createState() => _SuttEditPageState();
}

class _SuttEditPageState extends State<SuttEditPage> {
  late Report report;

  @override
  void initState() {
    report = Report.empty;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateReportBloc, UpdateReportState>(
      listener: (context, state) {
        if (state is GetReportForUpdateSuccess) {
          report = state.report;
        } else if (state is GetReportForUpdateLoading) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetReportForUpdateFailure) {
          Center(
            child: Text(state.message),
          );
        } else if (state is UpdateReportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report updated successfully'),
            ),
          );

          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sutt Detail'),
          titleSpacing: 0,
          leading: InkWell(
            key: const Key('suttDetailPage_back_iconButton'),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocBuilder<UpdateReportBloc, UpdateReportState>(
          buildWhen: (previous, current) => current is GetReportForUpdateSuccess,
          builder: (context, state) {
            if (state is GetReportForUpdateSuccess) {
              return Center(
                child: Column(
                  children: [
                    Text(state.report.city),
                    Text(state.report.kw),
                    Text(state.report.reportDate.toString()),
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ),
    );
  }
}
