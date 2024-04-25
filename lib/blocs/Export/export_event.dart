part of 'export_bloc.dart';

sealed class ExportEvent extends Equatable {
  const ExportEvent();

  @override
  List<Object> get props => [];
}

class ExportPdfReport extends ExportEvent {
  final Report report;

  const ExportPdfReport(this.report);

  @override
  List<Object> get props => [report];
}

class ExportExcelReport extends ExportEvent {
  final List<Report> reports;

  const ExportExcelReport(this.reports);

  @override
  List<Object> get props => [reports];
}