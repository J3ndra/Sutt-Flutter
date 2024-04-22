part of 'update_report_bloc.dart';

sealed class UpdateReportState extends Equatable {
  const UpdateReportState();
  
  @override
  List<Object> get props => [];
}

final class UpdateReportInitial extends UpdateReportState {}

final class UpdateReportFailure extends UpdateReportState {
  final String message;

  const UpdateReportFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class UpdateReportLoading extends UpdateReportState {}

final class UpdateReportSuccess extends UpdateReportState {
  final Report report;

  const UpdateReportSuccess(this.report);

  @override
  List<Object> get props => [report];
}
