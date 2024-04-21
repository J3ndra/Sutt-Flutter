import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/reports/create_report/create_report_bloc.dart';
import 'package:sutt/blocs/sign_in/sign_in_bloc.dart';
import 'package:sutt/screens/induk/induk_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<SignInBloc>().add(const SignOutRequired());
            },
          ),
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MenuButton(
              icon: Icon(
                Icons.edit_note,
                color: Theme.of(context).colorScheme.background,
                size: MediaQuery.of(context).size.width / 4 - 16,
              ),
              label: 'Index',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          BlocProvider<CreateReportBloc>(
                              create: (context) => CreateReportBloc(
                                  reportRepository: FirebaseReportRepository()),
                              child: const IndukPage()),
                    ));
              },
            ),
            const SizedBox(height: 8),
            MenuButton(
              icon: Icon(
                Icons.manage_search,
                color: Theme.of(context).colorScheme.background,
                size: MediaQuery.of(context).size.width / 4 - 16,
              ),
              label: 'Sutt',
              onTap: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (BuildContext context) => const SuttPage()),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, this.icon, this.label, required this.onTap});

  final Icon? icon;
  final String? label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(
        MediaQuery.of(context).size.width / 2 - 16,
        MediaQuery.of(context).size.width / 2 - 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Theme.of(context).colorScheme.onBackground,
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon ??
                    Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.background,
                    ),
                const SizedBox(height: 4),
                Text(
                  label ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
