// Create a new file: lib/core/services/bluetooth_background_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothBackgroundService {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    // Create notification channel for foreground service
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'bluetooth_service',
      'Bluetooth Service',
      description: 'Used for maintaining Bluetooth connection',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Fix the syntax error here
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Configure the service
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'bluetooth_service',
        initialNotificationTitle: 'Bluetooth Service',
        initialNotificationContent: 'Running in background',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    // Start the service
    service.startService();
  }

  // iOS background handler
  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  // Main background worker
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    // Create a map to store custom data
    Map<String, dynamic> customData = {};

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Initialize notification
    final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notificationsPlugin.initialize(initializationSettings);

    // Start background Bluetooth connection
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _tryBluetoothConnection(service, notificationsPlugin, customData);
    });

    // Initial connection attempt
    await _tryBluetoothConnection(service, notificationsPlugin, customData);
  }

  static Future<void> _tryBluetoothConnection(
    ServiceInstance service,
    FlutterLocalNotificationsPlugin notificationsPlugin,
    Map<String, dynamic> customData,
  ) async {
    try {
      // Check if connected already
      if (customData['isConnected'] == true) {
        return;
      }

      // Get saved device address
      final prefs = await SharedPreferences.getInstance();
      final lastDeviceAddress = prefs.getString('last_bluetooth_device_address');

      if (lastDeviceAddress == null) {
        service.invoke('updateStatus', {'status': 'No saved device'});
        return;
      }

      // Check if Bluetooth is enabled
      final isBluetoothEnabled = await FlutterBluetoothSerial.instance.isEnabled;
      if (isBluetoothEnabled != true) {
        service.invoke('updateStatus', {'status': 'Bluetooth disabled'});
        return;
      }

      // Get paired devices
      final bondedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();

      // Find the matching device
      final matchingDevices = bondedDevices.where((d) => d.address == lastDeviceAddress).toList();
      if (matchingDevices.isEmpty) {
        service.invoke('updateStatus', {'status': 'Device not found'});
        return;
      }

      final device = matchingDevices.first;

      // Connect to device
      final connection = await BluetoothConnection.toAddress(device.address);
      service.invoke('updateStatus', {'status': 'Connected to ${device.name}'});

      // Set connected flag
      customData['isConnected'] = true;
      customData['connection'] = connection;

      // Listen for incoming data
      connection.input?.listen((data) {
        final message = utf8.decode(data);

        // Show notification with action buttons
        _showNotificationWithActions(
          notificationsPlugin,
          title: 'Arduino Notification',
          body: message,
        );

        service.invoke('receivedMessage', {'message': message});
      }).onDone(() {
        customData['isConnected'] = false;
        customData['connection'] = null;
      });
    } catch (e) {
      service.invoke('updateStatus', {'status': 'Error: $e'});
      customData['isConnected'] = false;
      customData['connection'] = null;
    }
  }

  static Future<void> _showNotificationWithActions(
    FlutterLocalNotificationsPlugin notificationsPlugin, {
    required String title,
    required String body,
  }) async {
    // Define Yes/No actions for Android
    final List<AndroidNotificationAction> actions = [
      const AndroidNotificationAction(
        'yes_action',
        'Yes',
        showsUserInterface: true,
      ),
      const AndroidNotificationAction(
        'no_action',
        'No',
        showsUserInterface: true,
      ),
    ];

    // Configure Android notification
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'arduino_channel',
      'Arduino Notifications',
      channelDescription: 'Notifications from Arduino device',
      importance: Importance.max,
      priority: Priority.high,
      actions: actions,
    );

    // Show notification
    await notificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }
}
