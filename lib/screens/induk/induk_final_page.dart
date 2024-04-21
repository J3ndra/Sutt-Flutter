import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:report_repository/report_repository.dart';
import 'package:sutt/blocs/reports/create_report/create_report_bloc.dart';

class IndukFinalPage extends StatefulWidget {
  const IndukFinalPage(
      {super.key,
      required this.city,
      required this.kw,
      required this.ginsets,
      required this.bay});

  final String city;
  final String kw;
  final List<String> ginsets;
  final List<String> bay;

  static Page<void> page() => const MaterialPage<void>(
      child: IndukFinalPage(city: '', kw: '', ginsets: [], bay: []));

  @override
  State<IndukFinalPage> createState() => _IndukFinalPageState();
}

class _IndukFinalPageState extends State<IndukFinalPage> {
  List<File> selectedImages = [];
  List<TextEditingController> toolController = [TextEditingController()];
  TextEditingController dateInput = TextEditingController();
  String selectedDate = '';

  final picker = ImagePicker();

  late Report report;

  @override
  void initState() {
    log("City: ${widget.city}, KW: ${widget.kw}");
    log("Ginsets: ${widget.ginsets}");
    log("Bay: ${widget.bay}");

    report = Report.empty;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work'),
        titleSpacing: 0,
        leading: InkWell(
          key: const Key('IndukFinalPage_back_iconButton'),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocListener<CreateReportBloc, CreateReportState>(
        listener: (context, state) {
          if (state is CreateReportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Report created successfully'),
              ),
            );

            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is CreateReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocBuilder<CreateReportBloc, CreateReportState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Foto",
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
                            color: Theme.of(context).colorScheme.background),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: selectedImages.isEmpty
                          ? 0.0
                          : 300.0, // Adjust height dynamically
                      child: selectedImages.isEmpty
                          ? const SizedBox()
                          : GridView.builder(
                              itemCount: selectedImages.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                return Center(
                                    child: kIsWeb
                                        ? Image.network(
                                            selectedImages[index].path)
                                        : Image.file(selectedImages[index]));
                              },
                            ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Alat Kerja",
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                                      color: Theme.of(context).disabledColor,
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error,
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
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          toolController[index].clear();
                                          toolController[index].dispose();
                                          toolController.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color:
                                            Theme.of(context).colorScheme.error,
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
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Tanggal",
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: dateInput,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2025));

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            dateInput.text = selectedDate;
                          });
                        } else {
                          log("Date is not selected");
                        }
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      key: const Key('workPage_save_work_elevatedButton'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (selectedImages.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please add at least one image'),
                            ),
                          );
                          return;
                        } else if (toolController
                            .any((element) => element.text.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all tool names'),
                            ),
                          );
                          return;
                        } else if (selectedDate.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a date'),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          report.city = widget.city;
                          report.kw = widget.kw;
                          report.tools = toolController
                              .map((controller) => controller.text)
                              .toList();
                          report.reportDate = DateTime.parse(selectedDate);
                          report.ginsets = widget.ginsets;
                          report.bays = widget.bay;
                        });

                        context.read<CreateReportBloc>().add(CreateReport(
                            report,
                            selectedImages.map((e) => e.path).toList()));
                      },
                      child: state is CreateReportLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Save Work',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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
