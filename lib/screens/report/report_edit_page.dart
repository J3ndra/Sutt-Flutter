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

class ReportEditPage extends StatefulWidget {
  const ReportEditPage({super.key, required this.report});

  final Report report;

  static Page<void> page(Report report) => MaterialPage<void>(
        child: ReportEditPage(report: report),
      );

  @override
  State<ReportEditPage> createState() => _ReportEditPageState();
}

class _ReportEditPageState extends State<ReportEditPage> {
  List<File> selectedImages = [];
  List<TextEditingController> toolController = [];
  List<TextEditingController> toolQuantityController = [];
  List<TextEditingController> gistetController = [];
  List<TextEditingController> bayController = [];
  TextEditingController dateInput = TextEditingController();
  String selectedDate = '';

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.report.tools!.length; i++) {
      var newController = TextEditingController(text: widget.report.tools![i]);
      var newQuantityController = TextEditingController(
          text: widget.report.toolsQuantity![i].toString());
      toolController.add(newController);
      toolQuantityController.add(newQuantityController);
    }

    for (var i = 0; i < widget.report.gistets!.length; i++) {
      var newController =
          TextEditingController(text: widget.report.gistets![i]);
      gistetController.add(newController);
    }

    for (var i = 0; i < widget.report.bays!.length; i++) {
      var newController = TextEditingController(text: widget.report.bays![i]);
      bayController.add(newController);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addToolAndQuantity();
      _addGistet();
      _addBay();
    });
  }

  _addToolAndQuantity() {
    setState(() {
      var newController = TextEditingController();
      var newQuantityController = TextEditingController();
      toolController.add(newController);
      toolQuantityController.add(newQuantityController);
    });
  }

  _addGistet() {
    setState(() {
      var newController = TextEditingController();
      gistetController.add(newController);
    });
  }

  _addBay() {
    setState(() {
      var newController = TextEditingController();
      bayController.add(newController);
    });
  }

  _removeToolAndQuantity(int index) {
    setState(() {
      toolController[index].clear();
      toolQuantityController[index].clear();
      toolController[index].dispose();
      toolQuantityController[index].dispose();
      toolController.removeAt(index);
      toolQuantityController.removeAt(index);
    });
  }

  _removeGistet(int index) {
    setState(() {
      gistetController[index].clear();
      gistetController[index].dispose();
      gistetController.removeAt(index);
    });
  }

  _removeBay(int index) {
    setState(() {
      bayController[index].clear();
      bayController[index].dispose();
      bayController.removeAt(index);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateReportBloc, UpdateReportState>(
      listener: (context, state) {
        if (state is UpdateReportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report updated successfully'),
            ),
          );

          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (state is UpdateReportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is UpdateReportLoading) {
          const Center(child: CircularProgressIndicator());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Report'),
          titleSpacing: 0,
          leading: InkWell(
            key: const Key('reportEditPage_back_iconButton'),
            child: const Icon(
              Icons.arrow_back,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocBuilder<UpdateReportBloc, UpdateReportState>(
            builder: (context, state) {
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
                              color: Theme.of(context).colorScheme.background),
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
                                itemCount: widget.report.images!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // Return the widget based on the index
                                  return Center(
                                      child: Image.network(
                                          widget.report.images![index]));
                                },
                              )
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
                        children: [
                          for (int i = 0; i < toolController.length; i++)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        key: Key(
                                            'indukFinalPage_tool_textField_$i'),
                                        controller: toolController[i],
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          helperText: '',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 1,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        key: Key(
                                            'indukFinalPage_toolQuantity_textField_$i'),
                                        controller: toolQuantityController[i],
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          helperText: '',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 1,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 2,
                                            ),
                                          ),
                                          hintText: 'Jumlah',
                                        ),
                                      ),
                                    ),
                                    i != 0
                                        ? Expanded(
                                            child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                _removeToolAndQuantity(i);
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                size: 35,
                                              ),
                                            ),
                                          ))
                                        : const SizedBox.shrink(),
                                  ],
                                )
                              ],
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          log('Adding tool controler');
                          setState(() {
                            _addToolAndQuantity();
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
                        "Gistet",
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
                          gistetController.length,
                          (index) => Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  key: Key(
                                      'suttEditPage_gistet_textField_$index'),
                                  controller: gistetController[index],
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
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              _removeGistet(index);
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
                          // log('Add ginset');
                          setState(() {
                            _addGistet();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Tambah gistet",
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
                        "Bay",
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
                          bayController.length,
                          (index) => Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  key: Key('suttEditPage_bay_textField_$index'),
                                  controller: bayController[index],
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
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              _removeBay(index);
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
                          log('Add bay');
                          setState(() {
                            _addBay();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Tambah bay",
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
                      ElevatedButton(
                        key: const Key('suttEditPage_save_elevatedButton'),
                        onPressed: () async {
                          List<String> tools = [];
                          List<int> toolsQuantity = [];
                          List<String> gistets = [];
                          List<String> bays = [];

                          for (var i = 0; i < toolController.length; i++) {

                            if (i == 0) {
                              if (toolController[i].text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Alat kerja tidak boleh kosong'),
                                  ),
                                );
                                return;
                              }
                            }

                            if (toolController[i].text.isNotEmpty) {
                              tools.add(toolController[i].text);
                              if (toolQuantityController[i].text.isNotEmpty) {
                                toolsQuantity
                                    .add(int.parse(toolQuantityController[i].text));
                              } else {
                                toolsQuantity.add(0);
                              }
                            }
                          }

                          for (var i = 0; i < gistetController.length; i++) {
                            if (i == 0) {
                              if (gistetController[i].text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gistet tidak boleh kosong'),
                                  ),
                                );
                                return;
                              }
                            }

                            if (gistetController[i].text.isNotEmpty) {
                              gistets.add(gistetController[i].text);
                            }
                          }

                          for (var i = 0; i < bayController.length; i++) {
                            if (i == 0) {
                              if (bayController[i].text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Bay tidak boleh kosong'),
                                  ),
                                );
                                return;
                              }
                            }

                            if (bayController[i].text.isNotEmpty) {
                              bays.add(bayController[i].text);
                            }
                          }

                          final report = Report(
                            reportId: widget.report.reportId,
                            category: widget.report.category,
                            images: selectedImages.isNotEmpty
                                ? selectedImages.map((e) => e.path).toList()
                                : widget.report.images,
                            tools: tools,
                            toolsQuantity: toolsQuantity,
                            gistets: gistets,
                            bays: bays,
                            city: widget.report.city,
                            kw: widget.report.kw,
                            reportDate: widget.report.reportDate,
                          );

                          context
                              .read<UpdateReportBloc>()
                              .add(UpdateReport(report));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onBackground,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: state is UpdateReportLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                'Save',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
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
