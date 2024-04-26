import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/Export/export_bloc.dart';
import 'package:sutt/blocs/reports/delete_report/delete_report_bloc.dart';
import 'package:sutt/blocs/reports/get_report/get_report_bloc.dart';
import 'package:sutt/blocs/reports/update_report/update_report_bloc.dart';
import 'package:sutt/components/custom_image.dart';
import 'package:sutt/screens/report/report_edit_page.dart';

class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({super.key, required this.reportId});

  final String reportId;

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  late GetReportBloc _getReportBloc;
  late Report _report;

  List<String> listImages = [];

  @override
  void initState() {
    _getReportBloc = BlocProvider.of<GetReportBloc>(context);
    _getReportBloc.add(GetSingleReport(widget.reportId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteReportBloc, DeleteReportState>(
          listener: (context, state) {
            if (state is DeleteReportSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report deleted successfully'),
                ),
              );

              Navigator.popUntil(context, (route) => route.isFirst);
            } else if (state is DeleteReportFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to delete report: //${state.message}'),
                ),
              );
            }
          },
        ),
        BlocListener<ExportBloc, ExportState>(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Text(
                            'Report exported successfully',
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.background),
                          )),
                          SnackBarAction(
                            label: "Lihat PDF",
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
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Report Detail'),
          titleSpacing: 0,
          leading: InkWell(
            key: const Key('report_detail_back_button'),
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                _buildPopupMenuItem('Edit', Icons.edit, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            BlocProvider<UpdateReportBloc>(
                          create: (context) => UpdateReportBloc(
                            reportRepository: FirebaseReportRepository(),
                          ),
                          child: ReportEditPage(report: _report),
                        ),
                      ));
                }),
                _buildPopupMenuItem('Delete', Icons.delete, () {
                  BlocProvider.of<DeleteReportBloc>(context)
                      .add(DeleteReport(widget.reportId));
                }),
                _buildPopupMenuItem('Export PDF', Icons.picture_as_pdf, () {
                  _requestStoragePermission();
                })
              ];
            }),
          ],
        ),
        body: BlocBuilder<GetReportBloc, GetReportState>(
          builder: (context, state) {
            if (state is GetSingleReportSuccess) {
              _report = state.report;
              listImages = state.report.images!;
              for (var i in listImages) {
                log(i);
              }
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gambar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: listImages.isEmpty ? 0 : 300,
                        child: listImages.isEmpty
                            ? const SizedBox()
                            : GridView.builder(
                                itemCount: listImages.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (BuildContext context, int index) {
                                  return Center(
                                    child: CustomImage(
                                      imageUrl: listImages[index],
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kota',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  state.report.city,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'KW',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  state.report.kw,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tanggal',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(state.report.reportDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Gistet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.report.gistets?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '  ●  ${state.report.gistets![index]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Bay',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.report.bays?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '  ●   ${state.report.bays![index]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Alat Kerja',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.report.tools?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '  ●   ${state.report.tools?[index]} | ${state.report.toolsQuantity?[index]} pcs',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          );
                        },
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

    BlocProvider.of<ExportBloc>(context).add(ExportPdfReport(_report));
  }
}
