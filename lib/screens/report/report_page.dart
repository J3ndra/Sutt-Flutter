import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/export/export_bloc.dart';
import 'package:sutt/blocs/reports/get_report/get_report_bloc.dart';
import 'package:sutt/screens/report/report_list_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key, required this.category});

  final String category;

  static Page<void> page(String category) =>
      MaterialPage<void>(child: ReportPage(category: category));

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    log("Category ${widget.category}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report ${widget.category}'),
        titleSpacing: 0,
        leading: InkWell(
          key: const Key('reportPage_back_iconButton'),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Purwokerto",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Material(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        key:
                            const Key('reportPage_purwokerto_150kw_iconButton'),
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
                                      BlocProvider<ExportBloc>(
                                        create: (context) => ExportBloc(),
                                      ),
                                    ],
                                        child: ReportListPage(
                                            category: widget.category,
                                            city: 'Purwokerto',
                                            kw: '150 KW')),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Text('150 KW',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Material(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        key:
                            const Key('reportPage_purwokerto_500kw_iconButton'),
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
                                      BlocProvider<ExportBloc>(
                                        create: (context) => ExportBloc(),
                                      ),
                                    ],
                                        child: ReportListPage(
                                            category: widget.category,
                                            city: 'Purwokerto',
                                            kw: '500 KW')),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Text('500 KW',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                "Tegal",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Material(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        key: const Key('reportPage_tegal_150kw_iconButton'),
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
                                      BlocProvider<ExportBloc>(
                                        create: (context) => ExportBloc(),
                                      ),
                                    ],
                                        child: ReportListPage(
                                            category: widget.category,
                                            city: 'Tegal',
                                            kw: '150 KW')),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Text('150 KW',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Material(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        key: const Key('reportPage_tegal_500kw_iconButton'),
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
                                      BlocProvider<ExportBloc>(
                                        create: (context) => ExportBloc(),
                                      ),
                                    ],
                                        child: ReportListPage(
                                            category: widget.category,
                                            city: 'Tegal',
                                            kw: '500 KW')),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Text('500 KW',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                "Wonosobo",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Material(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        key: const Key('reportPage_wonosobo_150kw_iconButton'),
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
                                      BlocProvider<ExportBloc>(
                                        create: (context) => ExportBloc(),
                                      ),
                                    ],
                                        child: ReportListPage(
                                            category: widget.category,
                                            city: 'Wonosobo',
                                            kw: '150 KW')),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Text('150 KW',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Material(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        key: const Key('reportPage_wonosobo_500kw_iconButton'),
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
                                  BlocProvider<ExportBloc>(
                                    create: (context) => ExportBloc(),
                                  ),
                                ],
                                child: ReportListPage(
                                    category: widget.category,
                                    city: 'Wonosobo',
                                    kw: '500 KW'),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Text('500 KW',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
