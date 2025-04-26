import 'package:el7a2ni/core/cubit/logs/logs_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogsCubit extends Cubit<LogsState> {
  LogsCubit() : super(LogsInitialState());

  final supabase = Supabase.instance.client;

  Future<void> fetchLogsData() async {
    emit(LogsLoadingState());
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final response = await supabase.from('driver_logs').select().eq('driver_id', user.id);

        emit(LogsSuccessState(user: user, logsData: response));
      } else {
        emit(LogsFailureState(errorMessage: "User not found"));
      }
    } catch (e) {
      emit(LogsFailureState(errorMessage: e.toString()));
    }
  }
}
