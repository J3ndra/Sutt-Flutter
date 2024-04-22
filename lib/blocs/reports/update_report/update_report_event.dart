part of 'update_report_bloc.dart';

sealed class UpdateReportEvent extends Equatable {
  const UpdateReportEvent();

  @override
  List<Object> get props => [];
}

class GetUpdateReport extends UpdateReportEvent {
  final String reportId;

  const GetUpdateReport(this.reportId);

  @override
  List<Object> get props => [reportId];
}

class UpdateReport extends UpdateReportEvent {
  final Report report;

  const UpdateReport(this.report);

  @override
  List<Object> get props => [report];
}