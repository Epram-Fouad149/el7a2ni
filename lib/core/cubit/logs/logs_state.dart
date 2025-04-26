import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LogsState {}

class LogsInitialState extends LogsState {}

class LogsLoadingState extends LogsState {}

class LogsSuccessState extends LogsState {
  final User user;
  final List<dynamic> logsData;

  LogsSuccessState({
    required this.user,
    required this.logsData,
  });
}

class LogsFailureState extends LogsState {
  final String errorMessage;

  LogsFailureState({required this.errorMessage});
}
