part of 'create_report_bloc.dart';

sealed class CreateReportEvent extends Equatable {
  const CreateReportEvent();

  @override
  List<Object> get props => [];
}

class CreateReport extends CreateReportEvent {
  final Report report;
  final List<String> images;

  const CreateReport(this.report, this.images);

  @override
  List<Object> get props => [report, images];
}
