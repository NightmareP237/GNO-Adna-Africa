// database/Auth.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> get user async {
    final user = auth.currentUser;
    print(user);
    return user;
  }

  Future<bool> signUp(String email, String pass, displayName) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (credential.user != null) {
        FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      UserCredential user = await auth.signInAnonymously();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  // static Future<String> signUpEmailAndPassword(
  //     email, password, firstName, lastName, phone) async {
  //   print('$email $password $firstName $lastName $phone');
  //   try {
  //     final credential = await auth
  //         .createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     )
  //         .then((value) async {
  //       auth.currentUser!
  //           .updateDisplayName("$firstName $lastName")
  //           .then((value) {
  //         displayName =
  //             FirebaseAuth.instance.currentUser!.displayName.toString();
  //       });
  //       await Firebase.sendDataToID(
  //         'users',
  //         value.user!.uid,
  //         {
  //           'firstName': firstName,
  //           'lastName': lastName,
  //           'createDate': getStamp,
  //           'codepromo':'',
  //           "role": "Anonym",
  //           'phoneNumber': phone,
  //           "walletPending": 0,
  //           "wallet": 0,
  //           "PIN": 0,
  //         },
  //       ).whenComplete(() {
  //         print("getprofile");
  //         Firebase.getProfile(FirebaseAuth.instance.currentUser!.uid);
  //         print("getprofile");
  //       });
  //     });

  //     return '';
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //       return 'Votre mot de passe n\'est pas securisé, changez le et reessayez !';
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //       return 'Ce numero de telephone est deja utilisé par un autre compte !';
  //     } else if (e.code == 'network-request-failed') {
  //       return 'Probleme de connection internet, reessayez plutard ! ';
  //     }
  //   } catch (e) {
  //     print(e);
  //     return 'Probleme de connection internet, reessayez plutard ! ';
  //   }
  //   return '';
  // }

  // static Future<String> SignInWithEmailAndPassword(email, password) async {
  //   print('$email $password');
  //   try {
  //     final credential = await auth
  //         .signInWithEmailAndPassword(email: email, password: password)
  //         .then((value) {
  //       print("getprofile");
  //       print(value.user);
  //       displayName = value.user!.displayName.toString();
  //       if (value.user!.uid != '') {
  //         if (value.user!.emailVerified) {
  //           getTenantInfos(value.user!.uid);
  //           print(value.user!);
  //           print("getprofile");
  //           return '';
  //         } else {
  //           Firebase.getProfile(value.user!.uid);
  //           return '';
  //         }
  //       }
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'network-request-failed') {
  //       return 'Probleme de connection internet, reessayez plutard ! ';
  //     } else if (e.code == 'wrong-password') {
  //       return 'Numero de telephone ou mot de passe incorrect !';
  //     } else if (e.code == 'user-not-found') {
  //       return 'Ce numero de telephone ne correspond a aucun compte !';
  //     } else if (e.code == 'too-many-requests') {
  //       return 'Trop de connection au meme moment ,svp patientez un instant !';
  //     }
  //   } catch (e) {
  //     print(e);
  //     return "$e";
  //   }
  //   return '';
  // }

  Future<bool> signOut() async {
    try {
      auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}

// class DatabaseService {
//   final String? uid;
//   DatabaseService({this.uid});

//   // reference for our collections
//   final CollectionReference userCollection =
//       FirebaseFirestore.instance.collection("users");
//   final CollectionReference groupCollection =
//       FirebaseFirestore.instance.collection("groups");
// final CollectionReference messageCollection =
//       FirebaseFirestore.instance.collection("messages");
//   // saving the userdata
//   Future savingUserData(String fullName, String email) async {
//     return await userCollection.doc(uid).set({
//       "fullName": fullName,
//       "email": email,
//       "groups": [],
//       "profilePic": "",
//       "uid": uid,
//     });
//   }

//   // getting user data
//   Future gettingUserData(String email) async {
//     QuerySnapshot snapshot =
//         await userCollection.where("email", isEqualTo: email).get();
//     return snapshot;
//   }

//   // get user groups
//   getUserGroups() async {
//     return userCollection.doc(uid).snapshots();
//   }

//   // creating a group
//   Future createGroup(String userName, String id, String groupName) async {
//     DocumentReference groupDocumentReference = await groupCollection.add({
//       "groupName": groupName,
//       "groupIcon": "",
//       "admin": "${id}_$userName",
//       "members": [],
//       "groupId": "",
//       "recentMessage": "",
//       "recentMessageSender": "",
//     });
//     // update the members
//     await groupDocumentReference.update({
//       "members": FieldValue.arrayUnion(["${uid}_$userName"]),
//       "groupId": groupDocumentReference.id,
//     });

//     DocumentReference userDocumentReference = userCollection.doc(uid);
//     return await userDocumentReference.update({
//       "groups":
//           FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
//     });
//   }

//   // getting the chats
//   getChats() async {
//     return messageCollection
//         .doc('tous')
//         .collection("discussions")
//         .orderBy("time")
//         .snapshots();
//   }

//   Future getGroupAdmin(String groupId) async {
//     DocumentReference d = groupCollection.doc(groupId);
//     DocumentSnapshot documentSnapshot = await d.get();
//     return documentSnapshot['admin'];
//   }

  // // get group members
  // getGroupMembers(groupId) async {
  //   return groupCollection.doc(groupId).snapshots();
  // }

  // // search
  // searchByName(String groupName) {
  //   return groupCollection.where("groupName", isEqualTo: groupName).get();
  // }

  // // function -> bool
  // Future<bool> isUserJoined(
  //     String groupName, String groupId, String userName) async {
  //   DocumentReference userDocumentReference = userCollection.doc(uid);
  //   DocumentSnapshot documentSnapshot = await userDocumentReference.get();

  //   List<dynamic> groups = await documentSnapshot['groups'];
  //   if (groups.contains("${groupId}_$groupName")) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // // toggling the group join/exit
  // Future toggleGroupJoin(
  //     String groupId, String userName, String groupName) async {
  //   // doc reference
  //   DocumentReference userDocumentReference = userCollection.doc(uid);
  //   DocumentReference groupDocumentReference = groupCollection.doc(groupId);

  //   DocumentSnapshot documentSnapshot = await userDocumentReference.get();
  //   List<dynamic> groups = await documentSnapshot['groups'];

  //   // if user has our groups -> then remove then or also in other part re join
  //   if (groups.contains("${groupId}_$groupName")) {
  //     await userDocumentReference.update({
  //       "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
  //     });
  //     await groupDocumentReference.update({
  //       "members": FieldValue.arrayRemove(["${uid}_$userName"])
  //     });
  //   } else {
  //     await userDocumentReference.update({
  //       "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
  //     });
  //     await groupDocumentReference.update({
  //       "members": FieldValue.arrayUnion(["${uid}_$userName"])
  //     });
  //   }
  // }

  // send message
//   sendMessage(Map<String, dynamic> chatMessageData) async {
//     messageCollection
//         .doc('tous')
//         .collection("discussions").add(chatMessageData);
//     // groupCollection.doc(groupId).update({
//     //   "recentMessage": chatMessageData['message'],
//     //   "recentMessageSender": chatMessageData['sender'],
//     //   "recentMessageTime": chatMessageData['time'].toString(),
//     // });
//   }
// }