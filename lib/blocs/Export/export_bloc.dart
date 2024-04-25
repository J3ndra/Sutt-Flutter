import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
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
                  for (var image in images)
                    pw.Row(
                      children: [
                        pw.Image(pw.MemoryImage(image),
                          width: 100, height: 100, fit: pw.BoxFit.fill),
                      ],
                    ),
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

        OpenFile.open(file.path);
      } catch (e) {
        log(e.toString());
        emit(ExportFailure(e.toString()));
      }
    });
  }
}
