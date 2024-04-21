import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/reports/get_report/get_report_bloc.dart';
import 'package:sutt/screens/sutt/sutt_list_page.dart';

class SuttPage extends StatelessWidget {
  const SuttPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: SuttPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sutt'),
        titleSpacing: 0,
        leading: InkWell(
          key: const Key('suttPage_back_iconButton'),
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
            children: <Widget>[
              const Text('Purwokerto'),
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
                        key: const Key('suttPage_purwokerto_iconButton'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    BlocProvider<GetReportBloc>(
                                        create: (context) => GetReportBloc(
                                            reportRepository:
                                                FirebaseReportRepository()),
                                        child: const SuttListPage(
                                            city: 'Purwokerto', kw: '150 KW')),
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
                        key: const Key('suttPage_purwokerto_iconButton'),
                        onTap: () {
                          Navigator.push(context, 
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    BlocProvider<GetReportBloc>(
                                        create: (context) => GetReportBloc(
                                            reportRepository:
                                                FirebaseReportRepository()),
                                        child: const SuttListPage(
                                            city: 'Purwokerto', kw: '500 KW')),
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
              const SizedBox(height: 8),
              const Text('Tegal'),
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
                        key: const Key('suttPage_tegal_iconButton'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    BlocProvider<GetReportBloc>(
                                        create: (context) => GetReportBloc(
                                            reportRepository:
                                                FirebaseReportRepository()),
                                        child: const SuttListPage(
                                            city: 'Tegal', kw: '150 KW')),
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
                        key: const Key('suttPage_tegal_iconButton'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    BlocProvider<GetReportBloc>(
                                        create: (context) => GetReportBloc(
                                            reportRepository:
                                                FirebaseReportRepository()),
                                        child: const SuttListPage(
                                            city: 'Tegal', kw: '500 KW')),
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
              const SizedBox(height: 8),
              const Text('Wonosobo'),
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
                        key: const Key('suttPage_wonosobo_iconButton'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    BlocProvider<GetReportBloc>(
                                        create: (context) => GetReportBloc(
                                            reportRepository:
                                                FirebaseReportRepository()),
                                        child: const SuttListPage(
                                            city: 'Wonosobo', kw: '150 KW')),
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
                        key: const Key('suttPage_wonosobo_iconButton'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    BlocProvider<GetReportBloc>(
                                        create: (context) => GetReportBloc(
                                            reportRepository:
                                                FirebaseReportRepository()),
                                        child: const SuttListPage(
                                            city: 'Wonosobo', kw: '500 KW')),
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
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
