part of 'delete_report_bloc.dart';

sealed class DeleteReportState extends Equatable {
  const DeleteReportState();
  
  @override
  List<Object> get props => [];
}

final class DeleteReportInitial extends DeleteReportState {}

final class DeleteReportFailure extends DeleteReportState {
  final String message;

  const DeleteReportFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class DeleteReportLoading extends DeleteReportState {}

final class DeleteReportSuccess extends DeleteReportState {}
