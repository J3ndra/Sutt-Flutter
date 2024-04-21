import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:report_repository/report_repository.dart';

part 'get_report_event.dart';
part 'get_report_state.dart';

class GetReportBloc extends Bloc<GetReportEvent, GetReportState> {
  ReportRepository _reportRepository;

  GetReportBloc({
    required ReportRepository reportRepository,
  }) : _reportRepository = reportRepository, super(GetReportInitial()) {
    on<GetReports>((event, emit) async {
      emit(GetReportLoading());
      try {
        List<Report> reports = await _reportRepository.getReports(event.city, event.kw);
        emit(GetReportSuccess(reports));
      } catch (e) {
        emit(GetReportFailure(e.toString()));
      }
    });

    on<GetSingleReport>((event, emit) async {
      emit(GetReportLoading());
      try {
        Report report = await _reportRepository.getReport(event.id);
        emit(GetSingleReportSuccess(report));
      } catch (e) {
        emit(GetReportFailure(e.toString()));
      }
    });
  }
}
