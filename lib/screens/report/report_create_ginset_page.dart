import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/reports/create_report/create_report_bloc.dart';
import 'package:sutt/screens/report/report_create_bay_page.dart';

class ReportCreateGinsetPage extends StatefulWidget {
  const ReportCreateGinsetPage(
      {super.key,
      required this.category,
      required this.city,
      required this.kw});

  final String category;
  final String city;
  final String kw;

  static Page<void> page() => const MaterialPage<void>(
      child: ReportCreateGinsetPage(category: '', city: '', kw: ''));

  @override
  State<ReportCreateGinsetPage> createState() => _ReportCreateGinsetPageState();
}

class _ReportCreateGinsetPageState extends State<ReportCreateGinsetPage> {
  final List<TextEditingController> listController = [];

  @override
  void initState() {
    log("Category ${widget.category}, City ${widget.city}, KW ${widget.kw}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambahkan Ginset'),
        titleSpacing: 0,
        leading: InkWell(
          key: const Key('reportCreateGinsetPage_back_iconButton'),
          child: const Icon(
            Icons.arrow_back,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nama Ginset",
                ),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    listController.length,
                    (index) => Row(
                      children: [
                        Expanded(
                          child: TextField(
                            key: const Key('ginsetPage_namaGinset_textField'),
                            controller: listController[index],
                            autofocus: false,
                            decoration: InputDecoration(
                              helperText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).disabledColor,
                                  width: 1,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                  width: 2,
                                ),
                              ),
                              hintText: 'Masukkan nama ginset',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        index != 0
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      listController[index].clear();
                                      listController[index].dispose();
                                      listController.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 35,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      listController.add(TextEditingController());
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Add More",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('ginsetPage_saveFloatingActionButton'),
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onPressed: () {
          if (listController.isNotEmpty) {
            log("Ginsets: ${listController.map((e) => e.text).toList()}");
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        BlocProvider<CreateReportBloc>(
                            create: (context) => CreateReportBloc(
                                reportRepository: FirebaseReportRepository()),
                            child: ReportCreateBayPage(
                                category: widget.category,
                                city: widget.city,
                                kw: widget.kw,
                                ginsets: listController
                                    .map((e) => e.text)
                                    .toList()))));
          } else {
            for (var i = 0; i < listController.length; i++) {
              if (listController[i].text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nama Ginset tidak boleh kosong'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
            }
          }
        },
        child: Icon(
          Icons.navigate_next,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
