import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Global instance of the notification plugin that we can access anywhere
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Callback function that will be passed to the handler
Function(String)? onYesButtonPressed;
Function(String)? onNoButtonPressed;

Future<void> setupNotifications({
  required Function(String) onYes,
  required Function(String) onNo,
}) async {
  // Store callbacks
  onYesButtonPressed = onYes;
  onNoButtonPressed = onNo;

  // Android setup
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS setup
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  // Initialization settings for all platforms
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: _onNotificationResponse,
  );

  // Note: We removed the requestPermission line that was causing errors
}

void _onNotificationResponse(NotificationResponse response) {
  // Extract payload (message from Arduino)
  final String? payload = response.payload;

  if (payload == null) return;

  // Check which button was pressed
  if (response.actionId == 'yes_action') {
    if (onYesButtonPressed != null) {
      onYesButtonPressed!(payload);
    }
  } else if (response.actionId == 'no_action') {
    if (onNoButtonPressed != null) {
      onNoButtonPressed!(payload);
    }
  }
}

// Show notification with yes/no buttons
Future<void> showNotificationWithButtons({
  required String title,
  required String body,
  required String payload,
}) async {
  // Define actions for Android
  final List<AndroidNotificationAction> androidActions = [
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
  final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'arduino_channel',
    'Arduino Notifications',
    channelDescription: 'Notifications from Arduino device',
    importance: Importance.max,
    priority: Priority.high,
    actions: androidActions,
  );

  // Configure iOS notification
  const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

  // Platform specific settings
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  // Show the notification
  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title,
    body,
    platformChannelSpecifics,
    payload: payload,
  );
}
