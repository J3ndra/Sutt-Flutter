import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:report_repository/report_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

part 'export_event.dart';
part 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  ExportBloc() : super(ExportInitial()) {
    on<ExportPdfReport>((event, emit) async {
      emit(ExportLoading());

      Directory? appDocDirectory = await getExternalStorageDirectory();

      List<Uint8List> images = [];

      try {
        if (event.report.images!.isEmpty) {
          emit(const ExportFailure('No images found'));
        }

        for (var image in event.report.images!) {
          final byteData =
              (await NetworkAssetBundle(Uri.parse(image)).load(image))
                  .buffer
                  .asUint8List();
          images.add(byteData);
        }
      } catch (e) {
        log(e.toString());
        emit(ExportFailure(e.toString()));
      }

      try {
        final doc = pw.Document();
        doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                children: [
                  pw.Text('Report Detail',
                      style: pw.TextStyle(
                          fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Row(children: [
                    for (var image in images)
                      pw.Image(
                        pw.MemoryImage(image),
                        width: 100,
                        height: 100,
                        fit: pw.BoxFit.fill,
                      ),
                  ], mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly),
                  pw.SizedBox(height: 20),
                  pw.Text('Category: ${event.report.category}'),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Text('City: ${event.report.city}'),
                      pw.SizedBox(width: 10),
                      pw.Text('KW: ${event.report.kw}'),
                      pw.SizedBox(width: 10),
                      pw.Text(
                          'Tanggal Pekerjaan: ${DateFormat('yyyy-MM-dd').format(event.report.reportDate)}'),
                    ],
                  ),
                ],
              ),
            );
          },
        ));

        final file = File(
            '${appDocDirectory?.path}/report_${event.report.reportId}_${DateTime.now()}.pdf');
        log("File Path: ${file.path}");
        await file.writeAsBytes(await doc.save());

        emit(ExportSuccess(file.path));
      } catch (e) {
        log(e.toString());
        emit(ExportFailure(e.toString()));
      }
    });

    on<ExportExcelReport>((event, emit) async {
      emit(ExportLoading());

      Directory? appDocDirectory = await getExternalStorageDirectory();

      for (var report in event.reports) {
        log("Report ID from Bloc: ${report.reportId}");
      }

      try {
        var excel = Excel.createExcel();

        var sheet = excel['Report'];

        sheet.cell(CellIndex.indexByString("A1")).value = const TextCellValue('Report ID');
        for (var i = 0; i < event.reports.length; i++) {
          log("Report ID: ${event.reports[i].reportId}");
          sheet.cell(CellIndex.indexByString("A${i + 2}")).value = TextCellValue(event.reports[i].reportId);
        }

        sheet.cell(CellIndex.indexByString("B1")).value = const TextCellValue('Kategori Report');
        for (var i = 0; i < event.reports.length; i++) {
          log("Category: ${event.reports[i].category}");
          sheet.cell(CellIndex.indexByString("B${i + 2}")).value = TextCellValue(event.reports[i].category);
        }

        sheet.cell(CellIndex.indexByString("C1")).value = const TextCellValue('Kota');
        for (var i = 0; i < event.reports.length; i++) {
          log("City: ${event.reports[i].city}");
          sheet.cell(CellIndex.indexByString("C${i + 2}")).value = TextCellValue(event.reports[i].city);
        }

        sheet.cell(CellIndex.indexByString("D1")).value = const TextCellValue('KW');
        for (var i = 0; i < event.reports.length; i++) {
          log("KW: ${event.reports[i].kw}");
          sheet.cell(CellIndex.indexByString("D${i + 2}")).value = TextCellValue(event.reports[i].kw);
        }

        sheet.cell(CellIndex.indexByString("E1")).value = const TextCellValue('Tanggal Report');
        for (var i = 0; i < event.reports.length; i++) {
          log("Report Date: ${event.reports[i].reportDate}");
          sheet.cell(CellIndex.indexByString("E${i + 2}")).value = TextCellValue(DateFormat('yyyy-MM-dd').format(event.reports[i].reportDate));
        }

        List<String> gistets = [];
        sheet.cell(CellIndex.indexByString("F1")).value = const TextCellValue('Gistets');
        for (var i = 0; i < event.reports.length; i++) {
          if (event.reports[i].gistets != null) {
            for (var j = 0; j < event.reports[i].gistets!.length; j++) {
              if (event.reports[i].gistets != null && event.reports[i].gistets!.length > j) {
                log("Gistets: ${event.reports[i].gistets![j]}");
                gistets.add(event.reports[i].gistets![j]);
              } else {
                log("Gistets or index out of bounds for event");
              }
            }
          } else {
            log("Gistets is null for event $i");
          }
        }
        sheet.cell(CellIndex.indexByString("F2")).value = TextCellValue(gistets.join("\n"));

        List<String> bays = [];
        sheet.cell(CellIndex.indexByString("G1")).value = const TextCellValue('Bays');
        for (var i = 0; i < event.reports.length; i++) {
          if (event.reports[i].bays != null) {
            for (var j = 0; j < event.reports[i].bays!.length; j++) {
              if (event.reports[i].bays != null && event.reports[i].bays!.length > j) {
                log("Bays: ${event.reports[i].bays![j]}");
                bays.add(event.reports[i].bays![j]);
              } else {
                log("Bays or index out of bounds for event");
              }
            }
          } else {
            log("Bays is null for event $i");
          }
        }
        sheet.cell(CellIndex.indexByString("G2")).value = TextCellValue(bays.join("\n"));

        List<String> tools = [];
        List<int> toolsQuantity = [];
        sheet.cell(CellIndex.indexByString("H1")).value = const TextCellValue('Alat Kerja');
        for (var i = 0; i < event.reports.length; i++) {
          if (event.reports[i].tools != null) {
            for (var j = 0; j < event.reports[i].tools!.length; j++) {
              if (event.reports[i].tools != null && event.reports[i].tools!.length > j) {
                log("Tools: ${event.reports[i].tools![j]}");
                tools.add(event.reports[i].tools![j]);
                toolsQuantity.add(event.reports[i].toolsQuantity![j]);
                
              } else {
                log("Tools or index out of bounds for event");
              }
            }
          } else {
            log("Tools is null for event $i");
          }
        }
        sheet.cell(CellIndex.indexByString("H2")).value = TextCellValue("${tools.join("\n")} (${toolsQuantity.join("\n")})");

        List<String> imageUrls = [];
        sheet.cell(CellIndex.indexByString("I1")).value = const TextCellValue('Image URLs');
        for (var i = 0; i < event.reports.length; i++) {
          if (event.reports[i].images != null) {
            for (var j = 0; j < event.reports[i].images!.length; j++) {
              if (event.reports[i].images != null && event.reports[i].images!.length > j) {
                log("Images: ${event.reports[i].images![j]}");
                imageUrls.add(event.reports[i].images![j]);
              } else {
                log("Images or index out of bounds for event");
              }
            }
          } else {
            log("Images is null for event $i");
          }
        }
        sheet.cell(CellIndex.indexByString("I2")).value = TextCellValue(imageUrls.join("\n"));

        log("Excel Data: ${sheet.maxColumns} ${sheet.maxRows}");

        var fileBytes = excel.save();

        final file = File(
            '${appDocDirectory?.path}/reports_${DateTime.now()}.xlsx')..createSync(recursive: true)..writeAsBytesSync(fileBytes!);
        log("File Path: ${file.path}");

        emit(ExportSuccess(file.path));
      } catch (e) {
        log(e.toString());
        emit(ExportFailure(e.toString()));
      }
    });
  }
}
