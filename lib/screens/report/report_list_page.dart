import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/Export/export_bloc.dart';
import 'package:sutt/blocs/reports/create_report/create_report_bloc.dart';
import 'package:sutt/blocs/reports/delete_report/delete_report_bloc.dart';
import 'package:sutt/blocs/reports/get_report/get_report_bloc.dart';
import 'package:sutt/screens/report/report_create_ginset_page.dart';
import 'package:sutt/screens/report/report_detail_page.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage(
      {super.key,
      required this.category,
      required this.city,
      required this.kw});

  final String category;
  final String city;
  final String kw;

  static Page<void> page(String category, String city, String kw) =>
      MaterialPage<void>(
          child: ReportListPage(category: category, city: city, kw: kw));

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  late GetReportBloc _getReportBloc;

  @override
  void initState() {
    log("Category ${widget.category}, City ${widget.city}, KW ${widget.kw}");

    _getReportBloc = BlocProvider.of<GetReportBloc>(context);
    _getReportBloc.add(GetReports(widget.category, widget.city, widget.kw));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} List'),
        titleSpacing: 0,
        leading: InkWell(
          key: const Key('reportListPage_back_iconButton'),
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
            return state.reports.isEmpty
                ? const Center(
                    child: Text('Data is empty'),
                  )
                : ListView.builder(
                    itemCount: state.reports.length,
                    itemBuilder: (context, index) {
                      final report = state.reports[index];
                      return ListTile(
                        title: Text(report.city),
                        subtitle: Text(report.kw),
                        trailing: Text(
                            DateFormat('yyyy-MM-dd').format(report.reportDate)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  MultiBlocProvider(
                                providers: [
                                  BlocProvider<GetReportBloc>(
                                    create: (context) => GetReportBloc(
                                      reportRepository:
                                          FirebaseReportRepository(),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => DeleteReportBloc(
                                      reportRepository:
                                          FirebaseReportRepository(),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => ExportBloc(),
                                  ),
                                ],
                                child: ReportDetailPage(
                                  reportId: report.reportId,
                                ),
                              ),
                            ),
                          );
                        },
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      BlocProvider<CreateReportBloc>(
                        create: (context) => CreateReportBloc(
                            reportRepository: FirebaseReportRepository()),
                        child: ReportCreateGinsetPage(
                          category: widget.category,
                          city: widget.city,
                          kw: widget.kw,
                        ),
                      )));
        },
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.background,
        ),
        label: Text(
          'Tambah Report',
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
    );
  }
}
