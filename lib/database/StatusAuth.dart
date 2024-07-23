// database/StatusAuth.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:connecteo/connecteo.dart';

// class StatusAuth extends StatefulWidget {
//   StatusAuth({Key? key}) : super(key: key);
//   @override
//   State<StatusAuth> createState() => _StatusAuthState();
// }

// class _StatusAuthState extends State<StatusAuth> {
//   bool authentificated = false;
//   late ConnectionChecker _connecteo;
//   late StreamSubscription<bool> _streamSubscription;
// //this plugin is added to check network connection and Stream
//   bool? isConnected;
//   // ConnectionType? _connectionType;
//   //this is line required to verify the type of connection(cellular,wifi and others)

//   @override
//   void initState() {
//     _connecteo = ConnectionChecker();
//     _setupConnectionStatus();
//     _setupConnectionListener();
//     _registerConnectionBackCallback();
//     // FlutterNativeSplash.remove();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _streamSubscription.cancel();
//     super.dispose();
//   }

//   void _setupConnectionListener() {
//     _streamSubscription =
//         _connecteo.connectionStream.listen(_updateConnectionStatus);
//   }

//   void _setupConnectionStatus() {
//     _connecteo.isConnected.then(_updateConnectionStatus);
//   }

//   void _updateConnectionStatus(bool isConnect) {
//     setState(() {
//       isConnected = isConnect;
//     });
//   }

//   void _registerConnectionBackCallback() {
//     Future<void>.delayed(const Duration(seconds: 5)).then((_) async {
//       final isConnected = await _connecteo.isConnected;

//       if (!isConnected) {
//         // Register callback to be triggered once connection back
//         await _connecteo
//             .untilConnects()
//             // ignore: avoid_print
//             .then((_) => print('Connection is back!'));
//       }
//     });
//   }
  

//   Widget build(BuildContext context) {
//     getuser();
//     return user != null
//         ? (isConnected == null || !isConnected!)
//             ? NetworkFailed()
//             : (FirebaseAuth.instance.currentUser!.isAnonymous ||
//                     FirebaseAuth.instance.currentUser!.emailVerified)
//                 ? DocumentsScreen()
//                 : BottomNavBar()
//         : const TermsAndConditions();
//   }
// }
