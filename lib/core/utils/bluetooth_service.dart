import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:el7a2ni/core/utils/notification_handler.dart';
import 'package:el7a2ni/core/utils/shared_prefs_helper.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  BluetoothConnection? _connection;
  bool get isConnected => _connection != null && _connection!.isConnected;

  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();

  // Stream controller for notifications
  final notificationStreamController = StreamController<String>.broadcast();
  Stream<String> get notificationStream => notificationStreamController.stream;

  // Constructor - Initialize notifications but NOT auto-connect
  BluetoothService() {
    setupNotifications(
      onYes: (message) {
        // Send YES to Arduino
        sendResponse("YES");
      },
      onNo: (message) {
        // Send NO to Arduino
        sendResponse("NO");
      },
    );

    // Don't call autoConnect here - will be called by the Cubit
  }

  // Auto-connect to last paired device
  Future<bool> autoConnect() async {
    try {
      // First check if we're already connected
      if (isConnected) {
        print('Already connected to a device');
        return true;
      }

      final lastAddress = await _prefsHelper.getLastBluetoothDevice();

      if (lastAddress == null) {
        print('No previously connected device found');
        return false;
      }

      print('Found last device address: $lastAddress');

      // Check if Bluetooth is enabled
      final isEnabled = await FlutterBluetoothSerial.instance.isEnabled;
      if (isEnabled != true) {
        print('Bluetooth is disabled');
        // Try to enable Bluetooth
        await FlutterBluetoothSerial.instance.requestEnable();
        // Check again
        final isNowEnabled = await FlutterBluetoothSerial.instance.isEnabled;
        if (isNowEnabled != true) {
          return false;
        }
      }

      // Get paired devices
      final bondedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();
      print('Found ${bondedDevices.length} paired devices');

      // Find the last connected device in the bonded devices list
      final matchingDevices = bondedDevices.where((d) => d.address == lastAddress).toList();

      if (matchingDevices.isEmpty) {
        print('Device not found in paired devices');
        return false;
      }

      // Connect to the device
      final device = matchingDevices.first;
      print('Attempting to auto-connect to ${device.name} (${device.address})');
      return await connectToDevice(device);
    } catch (e) {
      print('Error auto-connecting: $e');
      return false;
    }
  }

  // Connect to HC-06
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      print('Connecting to ${device.name} (${device.address})');
      _connection = await BluetoothConnection.toAddress(device.address);

      if (_connection != null && _connection!.isConnected) {
        print('Successfully connected to ${device.address}');
        _startListening();

        // Save the device address for future auto-connect
        await _prefsHelper.saveLastBluetoothDevice(device.address);
        return true;
      } else {
        print('Connection failed or lost immediately');
        return false;
      }
    } catch (e) {
      print('Error connecting to device: $e');
      return false;
    }
  }

  // Start listening for incoming data - THIS WAS MISSING
  void _startListening() {
    _connection?.input?.listen((Uint8List data) {
      // Process incoming data
      String message = utf8.decode(data);

      // Show notification with Yes/No buttons
      showNotificationWithButtons(
        title: "Arduino Notification",
        body: message,
        payload: message,
      );

      // Also send to stream for in-app handling
      notificationStreamController.add(message);
    }).onDone(() {
      disconnect();
    });
  }

  // Send response back to Arduino - THIS WAS MISSING
  Future<void> sendResponse(String response) async {
    if (isConnected) {
      _connection!.output.add(Uint8List.fromList(utf8.encode("$response\n")));
      await _connection!.output.allSent;
      print('Sent response: $response');
    } else {
      print('Cannot send response: not connected');
    }
  }

  // Disconnect
  void disconnect() {
    if (_connection != null) {
      _connection?.dispose();
      _connection = null;
      print('Device disconnected');
    }
  }

  // Clear saved device
  Future<void> clearSavedDevice() async {
    print('Clearing saved device');
    await _prefsHelper.clearSavedBluetoothDevice();
    disconnect();
  }

  void dispose() {
    notificationStreamController.close();
    disconnect();
  }
}
