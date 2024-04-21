import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sutt/blocs/reports/get_report/get_report_bloc.dart';

class SuttDetailPage extends StatefulWidget {
  const SuttDetailPage({super.key, required this.reportId});

  final String reportId;

  @override
  State<SuttDetailPage> createState() => _SuttDetailPageState();
}

class _SuttDetailPageState extends State<SuttDetailPage> {
  late GetReportBloc _getReportBloc;

  @override
  void initState() {
    _getReportBloc = BlocProvider.of<GetReportBloc>(context);
    _getReportBloc.add(GetSingleReport(widget.reportId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              _buildPopupMenuItem('Edit', Icons.edit, () => print("Edit")),
              _buildPopupMenuItem('Delete', Icons.delete, () => print("Delete")),
            ];
          }),
        ],
      ),
      body: BlocBuilder<GetReportBloc, GetReportState>(
        builder: (context, state) {
          if (state is GetSingleReportSuccess) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City: ${state.report.city}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'KW: ${state.report.kw}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Report ID: ${state.report.reportId}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Report Date: ${DateFormat('yyyy-MM-dd').format(state.report.reportDate)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is GetReportFailure) {
            return _buildFailedToFetchReport();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData icon, Function() onTap) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
    );
  }

  SingleChildScrollView _buildFailedToFetchReport() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Failed to fetch report',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'An error occurred while fetching the report. Please try again later.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
