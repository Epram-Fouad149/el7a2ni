import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothAppState {
  final bool isConnected;
  final bool isConnecting;
  final bool isScanning;
  final List<BluetoothDevice> devices;
  final String? notification;

  BluetoothAppState({
    this.isConnected = false,
    this.isConnecting = false,
    this.isScanning = false,
    this.devices = const [],
    this.notification,
  });

  BluetoothAppState copyWith({
    bool? isConnected,
    bool? isConnecting,
    bool? isScanning,
    List<BluetoothDevice>? devices,
    String? notification,
  }) {
    return BluetoothAppState(
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      isScanning: isScanning ?? this.isScanning,
      devices: devices ?? this.devices,
      notification: notification,
    );
  }
}
