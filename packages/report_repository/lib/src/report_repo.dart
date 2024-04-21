import 'package:report_repository/src/models/models.dart';

abstract class ReportRepository {
  Future<Report> saveReport(Report report, List<String> images);
  Future<List<Report>> getReports(String city, String kw);
  Future<void> deleteReport(Report report);
  Future<void> updateReport(Report report);
  Future<Report> getReport(String id);
}