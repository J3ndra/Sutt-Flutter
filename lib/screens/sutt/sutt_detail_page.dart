import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/reports/delete_report/delete_report_bloc.dart';
import 'package:sutt/blocs/reports/get_report/get_report_bloc.dart';
import 'package:sutt/blocs/reports/update_report/update_report_bloc.dart';
import 'package:sutt/components/custom_image.dart';
import 'package:sutt/screens/sutt/sutt_edit_page.dart';

class SuttDetailPage extends StatefulWidget {
  const SuttDetailPage({super.key, required this.reportId});

  final String reportId;

  @override
  State<SuttDetailPage> createState() => _SuttDetailPageState();
}

class _SuttDetailPageState extends State<SuttDetailPage> {
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
    return BlocListener<DeleteReportBloc, DeleteReportState>(
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
              content: Text('Failed to delete report: ${state.message}'),
            ),
          );
        } else if (state is DeleteReportLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Deleting report...'),
            ),
          );
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
                          child: SuttEditPage(report: _report),
                        ),
                      ));
                }),
                _buildPopupMenuItem('Delete', Icons.delete, () {
                  BlocProvider.of<DeleteReportBloc>(context)
                      .add(DeleteReport(widget.reportId));
                }),
              ];
            }),
          ],
        ),
        body: BlocBuilder<GetReportBloc, GetReportState>(
          builder: (context, state) {
            if (state is GetSingleReportSuccess) {
              _report = state.report;
              listImages = state.report.images!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                        'Ginset',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.report.ginsets?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '  ●  ${state.report.ginsets![index]}',
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
}
