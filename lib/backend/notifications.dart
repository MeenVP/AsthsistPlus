import 'package:asthsist_plus/backend/firebase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_notification');

    var InitializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
        // your call back to the UI
      }
    );



    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: InitializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
    });
  }

  notificationDetails() {
    return const NotificationDetails(
            android: AndroidNotificationDetails(
              'your channel id',
              'your channel name',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: false,
            ),
        iOS: DarwinNotificationDetails());
  }




  Future showNotification(int id, [String? error]) async {
    String title = 'You shouldn\'t see this message.';
    String body = 'You shouldn\'t see this message.';
    switch (id) {
      case 0 :
        title = 'Asthma Attack Alert';
        body = 'Your vitals are normal';
      case 1 :
          title = 'Asthma Attack Alert';
          body = 'You are at risk of an asthma attack. Please take necessary precautions.';
          break;
        case 2 :
          title = 'Asthma Attack Alert';
          title = 'You are at high risk of an asthma attack. Please take action immediately.';
        break;
        case 3 :
          title = 'Data Imported';
          body = 'Your data has been imported successfully';
          break;
        case 4 :
          title = 'Prediction Failed';
          body = 'Insufficient Data';
        case 5:
          title = 'Unhealthy Air Condition';
          body = 'Current AQI is $error';
        case 6:
          title = 'High Heart Rate Alert';
          body = 'Your heart rate is above the maximum threshold';


    }
    await FirebaseService().addNotification(title, body,error);
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}