part of 'delete_report_bloc.dart';

sealed class DeleteReportEvent extends Equatable {
  const DeleteReportEvent();

  @override
  List<Object> get props => [];
}

class DeleteReport extends DeleteReportEvent {
  final String reportId;

  const DeleteReport(this.reportId);

  @override
  List<Object> get props => [reportId];
}