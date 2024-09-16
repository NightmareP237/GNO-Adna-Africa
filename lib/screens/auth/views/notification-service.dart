// screens/auth/views/notification-service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  const NotificationServices._();
  static final FlutterLocalNotificationsPlugin _notificationsPlugins = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel _androidChannel=
  AndroidNotificationChannel(
    'high_importance_channel',
   'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
  playSound: true);

  static NotificationDetails _notificationDetails(){
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        icon: "@mipmap/ic_launcher"),
        iOS: DarwinNotificationDetails()
        );
  }
  
  static Future<void> initializeNotification() async{
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings,iOS: DarwinInitializationSettings());
    await _notificationsPlugins.initialize(initializationSettings);
  }

  static void onMessage(RemoteMessage message){
    RemoteNotification? notification =message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    AppleNotification? appleNotification =message.notification?.apple;
    if(notification==null)return;
    if (androidNotification != null|| appleNotification !=null) {
_notificationsPlugins.show(notification.hashCode, notification.title, notification.body, _notificationDetails());
  }
}

static void onMessageOpenedApp(BuildContext context,RemoteMessage message){
   RemoteNotification? notification =message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    AppleNotification? appleNotification =message.notification?.apple;
    if(notification==null)return;
    if (androidNotification != null|| appleNotification !=null) {
      showDialog(context: context, builder: (_)=>AlertDialog(
        title: Text(notification.title??'No title'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(notification.body??'No body'),
            ],
          ),
        ),
      ));
    }
}
}