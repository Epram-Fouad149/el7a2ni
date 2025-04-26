import 'package:el7a2ni/core/cubit/logs/logs_cubit.dart';
import 'package:el7a2ni/core/cubit/logs/logs_state.dart';

class AccidentLogsViewModel {
  final LogsCubit logsCubit;

  AccidentLogsViewModel(this.logsCubit);

  void fetchLogsData() async {
    await logsCubit.fetchLogsData();
    final logsData = logsCubit.state is LogsSuccessState ? (logsCubit.state as LogsSuccessState).logsData : null;
  }
}
