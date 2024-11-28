// main.dart
import 'package:adna/screens/auth/views/notification-service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:adna/firebase-options.dart';
import 'package:adna/route/route_constants.dart';
import 'package:adna/route/router.dart' as router;
import 'package:adna/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  FirebaseFunctions.instanceFor(region: 'us-central1');
   FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await NotificationServices.initializeNotification();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  testHeath();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adna',
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: statusAuth,
    );
  }
}
Future<void> testHeath() async{
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkHeath');
  final response = await callable.call();
  print('response of cloud functions ${response.data}');
}
Future<void> _onBackgroundMessage(RemoteMessage message)async {
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("we have received notification ${message.notification}");
}
