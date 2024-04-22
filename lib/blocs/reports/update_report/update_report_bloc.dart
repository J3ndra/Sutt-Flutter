import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:report_repository/report_repository.dart';

part 'update_report_event.dart';
part 'update_report_state.dart';

class UpdateReportBloc extends Bloc<UpdateReportEvent, UpdateReportState> {
  ReportRepository _reportRepository;

  UpdateReportBloc({
    required ReportRepository reportRepository,
  }) : _reportRepository = reportRepository, super(UpdateReportInitial()) {
    on<GetUpdateReport>((event, emit) async {
      emit(GetReportForUpdateLoading());
      try {
        Report report = await _reportRepository.getReport(event.reportId);
        emit(GetReportForUpdateSuccess(report));
      } catch (e) {
        log(e.toString());
        emit(GetReportForUpdateFailure(e.toString()));
      }
    });

    on<UpdateReport>((event, emit) async {
      emit(UpdateReportLoading());
      try {
        Report report = await _reportRepository.updateReport(event.report);
        emit(UpdateReportSuccess(report));
      } catch (e) {
        log(e.toString());
        emit(UpdateReportFailure(e.toString()));
      }
    });
  }
}
