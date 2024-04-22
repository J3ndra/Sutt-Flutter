import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:report_repository/src/entities/entities.dart';
import 'package:report_repository/src/models/report.dart';
import 'package:report_repository/src/report_repo.dart';
import 'package:uuid/uuid.dart';

class FirebaseReportRepository implements ReportRepository {
  final reportCollection = FirebaseFirestore.instance.collection('reports');

  @override
  Future<Report> saveReport(Report report, List<String> images) async {
    try {
      List<String> imageUrls = [];

      report.reportId = const Uuid().v1();

      // Save images to storage
      for (var image in images) {
        File imagFile = File(image);

        Reference firebaseStoreReference = FirebaseStorage.instance.ref().child('reports/${report.reportId}/${imagFile.path.split('/').last}');

        await firebaseStoreReference.putFile(imagFile);

        String downloadUrl = await firebaseStoreReference.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      report.images = imageUrls;

      await reportCollection
          .doc(report.reportId)
          .set(report.toEntity().toDocument());

      return report;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Report>> getReports(String city, String kw) {
    try {
      return reportCollection
          .where('city', isEqualTo: city)
          .where('kw', isEqualTo: kw)
          .get()
          .then((snapshot) {
        return snapshot.docs
            .map((doc) => Report.fromEntity(ReportEntity.fromDocument(doc.data())))
            .toList();
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteReport(String reportId) async {
    try {
      Report report = await getReport(reportId);

      // Delete images from storage
      for (var imageUrl in report.images ?? []) {
        FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      return reportCollection.doc(report.reportId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Report> updateReport(Report report) async {
    try {
      // Delete old images
      for (var imageUrl in report.images ?? []) {
        FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }

      // Save new images
      List<String> imageUrls = [];

      for (var image in report.images ?? []) {
        File imagFile = File(image);

        Reference firebaseStoreReference = FirebaseStorage.instance.ref().child('reports/${report.reportId}/${imagFile.path.split('/').last}');

        await firebaseStoreReference.putFile(imagFile);

        String downloadUrl = await firebaseStoreReference.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      report.images = imageUrls;

      await reportCollection
          .doc(report.reportId)
          .update(report.toEntity().toDocument());

      return report;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Future<Report> getReport(String id) {
    try {
      return reportCollection.doc(id).get().then((doc) {
        return Report.fromEntity(ReportEntity.fromDocument(doc.data() ?? {}));
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
