import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/Export/export_bloc.dart';
import 'package:sutt/blocs/reports/create_report/create_report_bloc.dart';
import 'package:sutt/blocs/reports/delete_report/delete_report_bloc.dart';
import 'package:sutt/blocs/reports/get_report/get_report_bloc.dart';
import 'package:sutt/screens/report/report_create_gistet_page.dart';
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

  List<Report> reports = [];

  @override
  void initState() {
    log("Category ${widget.category}, City ${widget.city}, KW ${widget.kw}");

    _getReportBloc = BlocProvider.of<GetReportBloc>(context);
    _getReportBloc.add(GetReports(widget.category, widget.city, widget.kw));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExportBloc, ExportState>(
      listener: (context, state) {
        if (state is ExportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 0,
              content: Card(
                color: Theme.of(context).colorScheme.onBackground,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: Text(
                        'Report exported successfully',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      )),
                      SnackBarAction(
                        label: "Lihat Excel",
                        textColor: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          OpenFile.open(state.filePath);
                        },
                      )
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              duration: const Duration(seconds: 5),
            ),
          );
        } else if (state is ExportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to export report: ${state.message}'),
            ),
          );
        }
      },
      child: Scaffold(
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
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                _buildPopupMenuItem('Export Excel', Icons.grid_on, () {
                  _requestStoragePermission();
                })
              ];
            }),
          ],
        ),
        body: BlocBuilder<GetReportBloc, GetReportState>(
          builder: (context, state) {
            if (state is GetReportSuccess) {
              reports = state.reports;
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
                          trailing: Text(DateFormat('yyyy-MM-dd')
                              .format(report.reportDate)),
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
                          child: ReportCreateGistetPage(
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

  Future<void> _requestStoragePermission() async {
    final plugin = DeviceInfoPlugin();
    final androidInfo = await plugin.androidInfo;
    log('Android SDK version: ${androidInfo.version.sdkInt}');

    Map<Permission, PermissionStatus> statuses =
        androidInfo.version.sdkInt >= 30
            ? await [
                Permission.manageExternalStorage,
              ].request()
            : await [
                Permission.storage,
              ].request();

    log('Permission status: $statuses');

    if (statuses[Permission.storage] == PermissionStatus.denied ||
        statuses[Permission.manageExternalStorage] == PermissionStatus.denied ||
        statuses[Permission.storage] == PermissionStatus.restricted ||
        statuses[Permission.manageExternalStorage] ==
            PermissionStatus.restricted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is required to export report'),
        ),
      );

      return;
    }

    log('Exporting report to excel');
    for (var report in reports) {
      log('Report ID: ${report.reportId}');
    }

    BlocProvider.of<ExportBloc>(context).add(ExportExcelReport(reports));
  }
}
