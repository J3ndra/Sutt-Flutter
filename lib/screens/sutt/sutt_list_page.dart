import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sutt/blocs/reports/get_report/get_report_bloc.dart';

class SuttListPage extends StatefulWidget {
  const SuttListPage({super.key, required this.city, required this.kw});

  final String city;
  final String kw;

  static Page<void> page() =>
      const MaterialPage<void>(child: SuttListPage(city: '', kw: ''));

  @override
  State<SuttListPage> createState() => _SuttListPageState();
}

class _SuttListPageState extends State<SuttListPage> {
  late GetReportBloc _getReportBloc;

  @override
  void initState() {
    log("City: ${widget.city}, KW: ${widget.kw}");
    _getReportBloc = BlocProvider.of<GetReportBloc>(context);
    _getReportBloc.add(GetReports(widget.city, widget.kw));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sutt List'),
        titleSpacing: 0,
        leading: InkWell(
          key: const Key('suttListPage_back_iconButton'),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<GetReportBloc, GetReportState>(
        builder: (context, state) {
          if (state is GetReportSuccess) {
            return ListView.builder(
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                final report = state.reports[index];
                return ListTile(
                  title: Text(report.city),
                  subtitle: Text(report.kw),
                  trailing: Text(report.reportDate.toString()),
                );
              },
            );
          } else if (state is GetReportFailure) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
