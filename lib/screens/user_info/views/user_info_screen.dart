// screens/user_info/views/user_info_screen.dart
import 'package:adna/models/user_model.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/screens/user_info/views/edit_user_info_screen.dart';
import 'package:adna/statut-auth.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/route_constants.dart';

import '../../profile/views/components/profile_card.dart';
import 'components/user_info_list_tile.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool loading = false;
  UserInfoView userInfo = UserInfoView(
      email: '',
      image: '',
      phoneNumber: '',
      fcmToken: '',
      country: '',
      name: '',
       followers:[],
              share: 0,
    secteur: [],
      birthday: '');
  Future<void> GetUserInfo() async {
    try {
      final db = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .get();
      db.then((value) {
        setState(() {
          Map<String, dynamic>? doc = value.data();
          userInfo = UserInfoView(
              fcmToken: doc!['fcmToken'],
              email: doc['email'],
              image: doc['image'],
              phoneNumber: doc['phoneNumber'],
              country: doc['location'],
              name: doc['name'],
              secteur: doc['secteur'],
              followers: doc['followers'],
              share: doc['share'],
              birthday: doc['date']);
        });
      });
      print(userInfo);
    } catch (e) {
      setState(() {
        loading = false;
      });
      showAlertDialog(
          context: context,
          title: "Attention",
          body: "Un probleme inattendu est survenue !");
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    // TODO: implement initState
    GetUserInfo().then((value) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Profil"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: defaultPadding),
                ProfileCard(
                  name: FirebaseAuth.instance.currentUser!.displayName!,
                  email: FirebaseAuth.instance.currentUser!.email!,
                  imageSrc: FirebaseAuth.instance.currentUser!.photoURL!,
                  // proLableText: "Sliver",
                  // isPro: true, if the user is pro
                  isShowHi: false,
                  isShowArrow: false,
                ),
                const SizedBox(height: defaultPadding * 1.5),
                UserInfoListTile(
                  leadingText: "Nom complet",
                  trailingText: FirebaseAuth.instance.currentUser!.displayName!,
                ),
                UserInfoListTile(
                  leadingText: "Date de naissance",
                  trailingText: userInfo.birthday,
                ),
                UserInfoListTile(
                  leadingText: "Phone number",
                  trailingText: userInfo.phoneNumber,
                ),
                UserInfoListTile(
                  leadingText: "Localisation",
                  trailingText: userInfo.country,
                ),
                UserInfoListTile(
                  leadingText: "Email",
                  trailingText: userInfo.email,
                ),
                ListTile(
                  leading: const Text("Profil complet"),
                  trailing: TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(primaryColor)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditUserInfoScreen(
                                    userInfo: userInfo,
                                  )));
                    },
                    child: const Text("Modifier mon profil",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                ListTile(
                  selectedColor: errorColor,
                  splashColor: errorColor,
                  focusColor: errorColor,
                  // tileColor: errorColor,
                  textColor: errorColor,
                  leading: const Text("Supprimer mon compte"),
                  trailing: TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(errorColor)),
                    onPressed: () {
                      showAlertDialog2(
                        context: context,
                        title: "Attention",
                        body:
                            "La suppression de votre compte sera definitive !",
                        methodYes: () {
                          Navigator.pop(context);
                          setState(() {
                            loading = true;
                          });
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .delete()
                              .then((value) {
                            FirebaseAuth.instance.currentUser!
                                .delete()
                                .then((value) {
                              setState(() {
                                loading = false;
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const StatutAuth()),
                                  (route) => false);
                            });
                          });
                        },
                      );
                    },
                    child: const Text(
                      "Supprimer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (loading) LoadingComponent()
      ],
    );
  }
}
