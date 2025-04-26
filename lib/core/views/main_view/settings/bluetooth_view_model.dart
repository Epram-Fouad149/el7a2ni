import 'package:el7a2ni/core/cubit/bluetooth/bluetooth_cubit.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothViewModel {
  final BluetoothCubit cubit;

  BluetoothViewModel({required this.cubit});

  void scanForDevices() {
    cubit.scanDevices();
  }

  void connectToDevice(BluetoothDevice device) {
    cubit.connectToDevice(device);
  }

  void disconnect() {
    cubit.disconnect();
  }

  void forgetDevice() {
    cubit.forgetDevice();
  }

  void sendYesResponse() {
    cubit.sendResponse("YES");
  }

  void sendNoResponse() {
    cubit.sendResponse("NO");
  }
}
