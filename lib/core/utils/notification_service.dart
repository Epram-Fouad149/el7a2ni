import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // Initialize settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle when notification is tapped
        if (response.payload != null) {
          print('Notification payload: ${response.payload}');
        }
      },
    );
  }

  // Show notification with Yes/No buttons
  Future<void> showNotificationWithButtons({
    required String title,
    required String body,
  }) async {
    // Setup Yes action
    final List<AndroidNotificationAction> androidActions = [
      const AndroidNotificationAction(
        'yes_id',
        'Yes',
        showsUserInterface: true,
      ),
      const AndroidNotificationAction(
        'no_id',
        'No',
        showsUserInterface: true,
      ),
    ];

    // Android notification details with actions
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'arduino_channel',
      'Arduino Notifications',
      channelDescription: 'Notifications from Arduino device',
      importance: Importance.max,
      priority: Priority.high,
      actions: androidActions,
    );

    // iOS notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    // Platform-specific notification details
    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show notification
    await _notificationsPlugin.show(
      DateTime.now().millisecond, // Unique ID
      title,
      body,
      platformDetails,
    );
  }
}
