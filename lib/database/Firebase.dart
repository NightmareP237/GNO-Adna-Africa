// database/Firebase.dart
// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class Firebase {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static Future<DocumentReference<Map<String, dynamic>>> sendDataToFirestore(
          String collectionName, Map<String, dynamic> data) =>
      db.collection(collectionName).add(data);
  final format = DateFormat('dd-MM-yyyy');
  static Future<bool> getProfile(String userId) async {
    print(userId);
    var result = await db.collection('users').doc(userId).get();
    if (result == null) {
      return true;
    } else {
      // global = Global(
      //     createAt: result['createDate'].runtimeType.toString() == 'String'
      //         ? result['createDate']
      //         : DateFormat('dd-MM-yyyy').format(
      //             DateTime.fromMillisecondsSinceEpoch(
      //                     result['createDate'] * 1000)
      //                 .toLocal(),
      //           ),
      //     phoneNumber: result['phoneNumber'],
      //     lastName: result['lastName'],
      //     firstName: result['firstName'],
      //     role: result['role'],
      //     Pin: result['PIN'],
      //     walletPending: result['walletPending'],
      //     wallet: result['wallet']);
      // if (kDebugMode) {
      //   print(global.firstName);
      //   print(global.role);
      // }
      // if (global.role != 'Anonym') {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('role', global.role);
      //   await prefs.setInt('PIN', global.Pin);
      //   if (kDebugMode) {
      //     print(prefs.getString('role'));
      //     print(prefs.getInt('PIN'));
      //   }
      // }
      return false;
    }
  }

  static Future<bool> SignCollector(
      String userId, Map<String, dynamic> colMap) async {
    print(userId);
    var result = db.collection('users').doc(userId);
    try {
      // ignore: unnecessary_null_comparison
      if (result == null) {
        return false;
      } else {
        result.set(colMap).whenComplete(() => result.get().then((value) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('role', value['role']);
              if (kDebugMode) {
                print(prefs.getString('role'));
              }
            }));
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> updateDocumentStatus(
      String id, Map<String, dynamic> data) async {
    return db
        .collection('documents')
        .doc(id)
        .update(data)
        .then((value) => print("successfully updated"))
        .catchError((error) => print("error has occured: $error"));
  }

  static Future<bool> updateUser(
      String id, var lastName, firstName, phoneNumber) async {
    try {
      db.collection('users').doc(id).update({
        'lastName': lastName,
        "firstName": firstName,
        "phoneNumber": phoneNumber
      }).then((value) => print("user successfully updated"));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> sendData(
      String collectionName, Map<String, dynamic> data) async {
    print(data);
    var result = await db.collection(collectionName).add(data);
    if (result == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> sendDataToID(
      String collectionName, String id, Map<String, dynamic> data) async {
    await db.collection(collectionName).doc(id).set(data);
    return true;
  }

  static Future<String> uploadImage(XFile image, BuildContext context) async {
    var storage = FirebaseStorage.instance;
    if (image != null) {
      //Upload to Firebase
      var snapshot = await storage
          .ref('documents/${image.name}')
          .putFile(File(image.path));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      if (kDebugMode) {
        print('No Image Path Received');
      }
    }
    return '';
  }

  static Future<String> uploadChatImage(
      XFile image, BuildContext context) async {
    var storage = FirebaseStorage.instance;
    if (image != null) {
      //Upload to Firebase
      var snapshot =
          await storage.ref('chats/${image.name}').putFile(File(image.path));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      if (kDebugMode) {
        print('No Image Path Received');
      }
    }
    return '';
  }

  
  static Future<String> uploadImageProfile(
      XFile image, BuildContext context) async {
    var storage = FirebaseStorage.instance;
    if (image != null) {
      //Upload to Firebase
      var snapshot =
          await storage.ref('profiles/${image.name}').putFile(File(image.path));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      if (kDebugMode) {
        print(downloadUrl);
      }
      return downloadUrl;
    } else {
      if (kDebugMode) {
        print('No Image Path Received');
      }
    }
    return '';
  }

  static Future<String> uploadCollectorImage(
      XFile image, BuildContext context) async {
    var storage = FirebaseStorage.instance;
    if (image != null) {
      //Upload to Firebase
      var snapshot = await storage
          .ref('collectors/${image.name}')
          .putFile(File(image.path));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      if (kDebugMode) {
        print('No Image Path Received');
      }
    }
    return '';
  }
}

Future<bool> SendNotification(String title, body, token, String image) async {
  try {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotification');

    final response = await callable.call(<String, dynamic>{
      'title': title,
      'body': body,
      'token': token,
      'image': image,
    });
    print('result is ${response.data ?? 'No data came back'}');

    if (response.data == null) return false;
    return true;
  } catch (e) {
    print("this is the error $e");
    return false;
  }
}
