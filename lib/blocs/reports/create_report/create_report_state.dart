part of 'create_report_bloc.dart';

sealed class CreateReportState extends Equatable {
  const CreateReportState();
  
  @override
  List<Object> get props => [];
}

final class CreateReportInitial extends CreateReportState {}

final class CreateReportFailure extends CreateReportState {
  final String message;

  const CreateReportFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class CreateReportLoading extends CreateReportState {}

final class CreateReportSuccess extends CreateReportState {
  final Report report;

  const CreateReportSuccess(this.report);

  @override
  List<Object> get props => [report];
}