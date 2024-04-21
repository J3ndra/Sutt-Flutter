import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:report_repository/report_repository.dart';

part 'create_report_event.dart';
part 'create_report_state.dart';

class CreateReportBloc extends Bloc<CreateReportEvent, CreateReportState> {
  ReportRepository _reportRepository;

  CreateReportBloc({
    required ReportRepository reportRepository,
  }) : _reportRepository = reportRepository, super(CreateReportInitial()) {
    on<CreateReport>((event, emit) async {
      emit(CreateReportLoading());
      try {
        Report report = await _reportRepository.saveReport(event.report, event.images);
        emit(CreateReportSuccess(report));
      } catch (e) {
        log(e.toString());
        emit(CreateReportFailure(e.toString()));
      }
    });
  }
}
