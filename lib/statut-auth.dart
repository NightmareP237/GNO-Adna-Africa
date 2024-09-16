// statut-auth.dart
import 'package:adna/database/Auth.dart';
import 'package:adna/entry_point.dart';
import 'package:adna/screens/auth/views/verification_method_screen.dart';
import 'package:adna/screens/onbording/views/onbording_screnn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatutAuth extends StatefulWidget {
  const StatutAuth({super.key});

  @override
  State<StatutAuth> createState() => _StatutAuthState();
}

class _StatutAuthState extends State<StatutAuth> {
  AuthServices auth = AuthServices();
  User? user;
  String process = '';
  // Future<User?> getuser() async {
  //   return user = auth.currentUser;
  // }

  Future<String> GetProcessing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('process') == null
        ? ''
        : prefs.getString('process')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    GetProcessing().then((value) {
      setState(() {
        process = value;
      });
    });
    // getuser().then((us) {
    //   setState(() {
    //     user = us;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser);
    return 
    (FirebaseAuth.instance.currentUser == null 
    // && process.isEmpty
    )
        ? 
        const OnBordingScreen()
        : const EntryPoint();
  }
}
