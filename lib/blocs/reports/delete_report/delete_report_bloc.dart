import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:report_repository/report_repository.dart';

part 'delete_report_event.dart';
part 'delete_report_state.dart';

class DeleteReportBloc extends Bloc<DeleteReportEvent, DeleteReportState> {
  ReportRepository _reportRepository;

  DeleteReportBloc({
    required ReportRepository reportRepository,
  }) : _reportRepository = reportRepository, super(DeleteReportInitial()) {
    on<DeleteReport>((event, emit) async {
      emit(DeleteReportLoading());
      try {
        await _reportRepository.deleteReport(event.reportId);
        emit(DeleteReportSuccess());
      } catch (e) {
        emit(DeleteReportFailure(e.toString()));
      }
    });
  }
}
