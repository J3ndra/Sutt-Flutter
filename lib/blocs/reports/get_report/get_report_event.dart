part of 'get_report_bloc.dart';

sealed class GetReportEvent extends Equatable {
  const GetReportEvent();

  @override
  List<Object> get props => [];
}

class GetReports extends GetReportEvent {
  final String category;
  final String city;
  final String kw;

  const GetReports(this.category, this.city, this.kw);

  @override
  List<Object> get props => [category, city, kw];
}

class GetSingleReport extends GetReportEvent {
  final String id;

  const GetSingleReport(this.id);

  @override
  List<Object> get props => [id];
}