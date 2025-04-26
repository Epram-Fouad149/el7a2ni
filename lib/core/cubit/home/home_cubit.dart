import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_cubit.dart';
import 'package:el7a2ni/core/cubit/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final BluetoothCubit bluetoothCubit;

  HomeCubit({required this.bluetoothCubit}) : super(HomeInitialState());

  Future<void> sendHelpRequest() async {
    try {
      // Check if Bluetooth is connected
      if (!bluetoothCubit.state.isConnected) {
        emit(HomeErrorState("Bluetooth not connected. Please connect in Settings."));
        return;
      }

      // Show sending state
      emit(HomeSendingHelpState());

      // Send help message to Arduino
      bluetoothCubit.sendResponse("help\n");

      // Show success state
      emit(HomeSentHelpState());

      // Reset state after 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      emit(HomeInitialState());
    } catch (e) {
      emit(HomeErrorState("Error sending help request: $e"));
    }
  }
}
