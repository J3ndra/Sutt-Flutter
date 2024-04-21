part of 'get_report_bloc.dart';

sealed class GetReportEvent extends Equatable {
  const GetReportEvent();

  @override
  List<Object> get props => [];
}

class GetReports extends GetReportEvent {
  final String city;
  final String kw;

  const GetReports(this.city, this.kw);

  @override
  List<Object> get props => [city, kw];
}