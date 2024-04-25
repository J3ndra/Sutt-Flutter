part of 'export_bloc.dart';

sealed class ExportState extends Equatable {
  const ExportState();
  
  @override
  List<Object> get props => [];
}

final class ExportInitial extends ExportState {}

final class ExportFailure extends ExportState {
  final String message;

  const ExportFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class ExportLoading extends ExportState {}

final class ExportSuccess extends ExportState {
  final String filePath;

  const ExportSuccess(this.filePath);

  @override
  List<Object> get props => [filePath];
}