import 'dart:async';

import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_app_state.dart'; // Updated import
import 'package:el7a2ni/core/utils/bluetooth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothCubit extends Cubit<BluetoothAppState> {
  final BluetoothService _bluetoothService = BluetoothService();
  StreamSubscription? _notificationSubscription;

  BluetoothCubit() : super(BluetoothAppState()) {
    _notificationSubscription = _bluetoothService.notificationStream.listen((notification) {
      emit(state.copyWith(notification: notification));
    });

    // Try auto-connect when the cubit is created
    _tryAutoConnect();
  }

  Future<void> _tryAutoConnect() async {
    // First emit a loading state if you want to show a loading indicator
    emit(state.copyWith(isConnecting: true));

    // Delay a bit to let Bluetooth initialize
    await Future.delayed(const Duration(milliseconds: 500));

    final success = await _bluetoothService.autoConnect();

    // Update state based on connection result
    emit(state.copyWith(
      isConnected: success,
      isConnecting: false,
    ));
  }

  Future<void> scanDevices() async {
    emit(state.copyWith(isScanning: true));

    final flutterBluetoothSerial = FlutterBluetoothSerial.instance;
    final bonded = await flutterBluetoothSerial.getBondedDevices();

    emit(state.copyWith(
      devices: bonded,
      isScanning: false,
    ));
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    emit(state.copyWith(isConnecting: true));

    final success = await _bluetoothService.connectToDevice(device);

    emit(state.copyWith(
      isConnected: success,
      isConnecting: false,
    ));
  }

  void disconnect() {
    _bluetoothService.disconnect();
    emit(state.copyWith(isConnected: false));
  }

  // Explicitly call the clearSavedDevice method
  Future<void> forgetDevice() async {
    await _bluetoothService.clearSavedDevice();
    emit(state.copyWith(isConnected: false));
  }

  void sendResponse(String response) {
    _bluetoothService.sendResponse(response);
    // Clear notification after response
    emit(state.copyWith(notification: null));
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    _bluetoothService.dispose();
    return super.close();
  }
}
