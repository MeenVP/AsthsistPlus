import 'package:asthsist_plus/backend/firebase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // initialize notifications
  Future<void> initNotifications() async {
    // Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_notification');

    // IOS settings
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          // your call back to the UI
        });

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

// notification details
  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          '0',
          'Asthma Attack Alert',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails());
  }

// show notification
  Future showNotification(int id, [String? error]) async {
    String title = 'You shouldn\'t see this message.';
    String body = 'You shouldn\'t see this message.';
    switch (id) {
      case 0: // normal
        title = 'Asthma Attack Alert';
        body = 'Your vitals are normal';
      case 1: // caution
        title = 'Asthma Attack Alert';
        body =
            'You are at risk of an asthma attack. Please take necessary precautions.';
        break;
      case 2: // danger
        title = 'Asthma Attack Alert';
        title =
            'You are at high risk of an asthma attack. Please take action immediately.';
        break;
      case 3: // data imported
        title = 'Data Imported';
        body = 'Your data has been imported successfully';
        break;
      case 4: // insufficient data
        title = 'Prediction Failed';
        body = 'Insufficient Data';
      case 5: // unhealthy air
        title = 'Unhealthy Air Condition';
        body = 'Current AQI is $error';
      case 6: // high heart rate
        title = 'High Heart Rate Alert';
        body = 'Your heart rate is above the maximum threshold';
    }
    // add notification to firebase
    await FirebaseService().addNotification(title, body, error);
    // show notification
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}
