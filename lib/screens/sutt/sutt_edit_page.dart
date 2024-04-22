import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/reports/update_report/update_report_bloc.dart';

class SuttEditPage extends StatefulWidget {
  const SuttEditPage({super.key});

  @override
  State<SuttEditPage> createState() => _SuttEditPageState();
}

class _SuttEditPageState extends State<SuttEditPage> {
  List<File> selectedImages = [];
  List<TextEditingController> toolController = [TextEditingController()];
  List<TextEditingController> ginsetController = [TextEditingController()];
  List<TextEditingController> ginsetBayController = [TextEditingController()];
  TextEditingController dateInput = TextEditingController();
  String selectedDate = '';

  final picker = ImagePicker();

  late Report report;

  @override
  void initState() {
    report = Report.empty;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateReportBloc, UpdateReportState>(
      listener: (context, state) {
        if (state is GetReportForUpdateSuccess) {
          report = state.report;
        } else if (state is GetReportForUpdateLoading) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetReportForUpdateFailure) {
          Center(
            child: Text(state.message),
          );
        } else if (state is UpdateReportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report updated successfully'),
            ),
          );

          Navigator.popUntil(context, (route) => route.isFirst);
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
          ),
          body: BlocBuilder<UpdateReportBloc, UpdateReportState>(
            buildWhen: (previous, current) =>
                current is GetReportForUpdateSuccess,
            builder: (context, state) {
              if (state is GetReportForUpdateSuccess) {
                toolController.clear();

                for (var tool in state.report.tools!) {
                  toolController.add(TextEditingController(text: tool));
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Foto",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                          key: const Key('workPage_add_image_elevatedButton'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onBackground,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            checkPermissionsAndLoadImages();
                          },
                          child: Text(
                            'Add Image',
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: selectedImages.isEmpty
                              ? 300.0
                              : 300.0, // Adjust height dynamically
                          child: selectedImages.isEmpty
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemCount: state.report.images!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // Return the widget based on the index
                                    return Center(
                                        child: Image.network(
                                            state.report.images![index]));
                                  },
                                )
                              : GridView.builder(
                                  itemCount: selectedImages.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Center(
                                        child: kIsWeb
                                            ? Image.network(
                                                selectedImages[index].path)
                                            : Image.file(
                                                selectedImages[index]));
                                  },
                                ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Alat Kerja",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            toolController.length,
                            (index) => Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    key: const Key('bayPage_nameBay_textField'),
                                    controller: toolController[index],
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      helperText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(context).disabledColor,
                                          width: 1,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          width: 2,
                                        ),
                                      ),
                                      hintText: 'Masukkan nama alat kerja',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                index != 0
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(
                                              () {
                                                toolController[index].clear();
                                                toolController[index].dispose();
                                                toolController.removeAt(index);
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            size: 35,
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              toolController.add(TextEditingController());
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Tambah alat kerja",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }

  Future<void> checkPermissionsAndLoadImages() async {
    var cameraPermissionStatus = await Permission.camera.status;

    log('Camera permission status: $cameraPermissionStatus');

    if (await Permission.camera.request().isGranted) {
      // Both camera and storage permissions are granted
      getImages();
    } else {
      // Permissions are not granted
      // You can handle this case by showing a dialog or requesting permissions again
      // For simplicity, I'm requesting permissions again here
      requestPermissions();
    }
  }

  Future<void> requestPermissions() async {
    // Request both camera and storage permissions
    final plugin = DeviceInfoPlugin();
    final androidInfo = await plugin.androidInfo;
    log('Android SDK version: ${androidInfo.version.sdkInt}');
    Map<Permission, PermissionStatus> statuses = androidInfo.version.sdkInt < 33
        ? await [
            Permission.camera,
            Permission.storage,
          ].request()
        : await [
            Permission.camera,
            Permission.photos,
            Permission.mediaLibrary,
          ].request();

    // Check if permissions are granted
    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.storage]!.isGranted) {
      // Permissions are granted
      getImages();
    } else {
      String requestPermission = '';

      if (statuses[Permission.camera]!.isDenied) {
        requestPermission = 'camera';
      } else if (statuses[Permission.storage]!.isDenied) {
        requestPermission = 'storage';
      }

      // Permissions are not granted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please grant $requestPermission permission'),
        ),
      );
    }
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 50, maxHeight: 500, maxWidth: 500);

    List<XFile> xFiles = pickedFile;

    setState(() {
      if (xFiles.isNotEmpty) {
        for (var i = 0; i < xFiles.length; i++) {
          selectedImages.add(File(xFiles[i].path));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
      }
    });
  }
}
