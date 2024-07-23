// main.dart
import 'package:flutter/material.dart';
import 'package:adna/firebase-options.dart';
import 'package:adna/route/route_constants.dart';
import 'package:adna/route/router.dart' as router;
import 'package:adna/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  // String decodedstring1 = utf8. decode(decodedint1);
  // final apikey = "6d539427d7fd42f195dcf00863ecbd33";
  // final Xreference = "a2e951d8-2820-4969-bcf1-6216e16162cf";
  // String userKey = apikey + ':' + Xreference;
  // String decodedint1 = base64.encode(userKey.codeUnits);
  // final User64Base = base64Encode(decodedint1);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);
  // print(decodedint1);
  // await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
