part of 'update_report_bloc.dart';

sealed class UpdateReportEvent extends Equatable {
  const UpdateReportEvent();

  @override
  List<Object> get props => [];
}

class UpdateReport extends UpdateReportEvent {
  final Report report;

  const UpdateReport(this.report);

  @override
  List<Object> get props => [report];
}