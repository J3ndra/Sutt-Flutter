part of 'get_report_bloc.dart';

sealed class GetReportState extends Equatable {
  const GetReportState();
  
  @override
  List<Object> get props => [];
}

final class GetReportInitial extends GetReportState {}

final class GetReportFailure extends GetReportState {
  final String message;

  const GetReportFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class GetReportLoading extends GetReportState {}

final class GetReportSuccess extends GetReportState {
  final List<Report> reports;

  const GetReportSuccess(this.reports);

  @override
  List<Object> get props => [reports];
}

final class GetSingleReportSuccess extends GetReportState {
  final Report report;

  const GetSingleReportSuccess(this.report);

  @override
  List<Object> get props => [report];
}