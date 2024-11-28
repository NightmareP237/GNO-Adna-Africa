// screens/auth/views/custom-experience.dart
import 'package:adna/constants.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/database/Firebase.dart';
import 'package:adna/screens/auth/views/verification_method_screen.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Experience extends StatefulWidget {
  const Experience({super.key, required this.dataUser});
  final Map dataUser;
  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  bool isUpload = false;
  String? fcm;
  List ListofHobby = [];

  int selectedItem = 12;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcm = value;
        print(fcm);
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
            // leading: const SizedBox(),
            title: const Text("Choix du secteur d'activite"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  "assets/icons/info.svg",
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(defaultPadding),
                            // height: MediaQuery.of(context).size.height / 2.2,
                            child: Wrap(
                                runSpacing: 4,
                                spacing: 4,
                                children: List.generate(
                                    ListofExperience.length,
                                    (index) => OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              if (ListofHobby.contains(
                                                  ListofExperience[index])) {
                                                ListofHobby.remove(
                                                    ListofExperience[index]);
                                              } else {
                                                ListofHobby.add(
                                                    ListofExperience[index]);
                                              }
                                            });
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                                ListofHobby.contains(
                                                        ListofExperience[index])
                                                    ? Colors.green.shade500
                                                    : Colors.white,
                                            // fixedSize: const Size(140, 150),
                                            padding: const EdgeInsets.all(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              ListofExperience[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!,
                                            ),
                                          ),
                                        ))),
                          ),
                          const SizedBox(width: defaultPadding),
                          ElevatedButton(
                            onPressed: () {
                              if (ListofHobby.isNotEmpty) {
                                if (widget.dataUser['image'] != null) {
                                  setState(() {
                                    isUpload = true;
                                  });
                                  AuthServices().signOut().then((val) async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('process', "");
                                    Firebase.uploadImageProfile(
                                            widget.dataUser['image']!, context)
                                        .then((val) {
                                      if (val.isNotEmpty) {
                                        AuthServices()
                                            .signUp(
                                                widget.dataUser['email']
                                                    .toString()
                                                    .trim(),
                                                widget.dataUser['password']
                                                    .toString()
                                                    .trim(),
                                                widget.dataUser['name']
                                                    .toString()
                                                    .trim())
                                            .then((value) {
                                          if (value) {
                                            FirebaseAuth.instance.currentUser!
                                                .updatePhotoURL(val);
                                            FirebaseAuth.instance.currentUser!
                                                .updateDisplayName(widget
                                                    .dataUser['name']
                                                    .toString()
                                                    .trim());
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid
                                                    .toString())
                                                .set({
                                              "email": widget.dataUser['email']
                                                  .toString()
                                                  .trim(),
                                              'name': widget.dataUser['name']
                                                  .toString()
                                                  .trim(),
                                              'date': widget.dataUser['date']
                                                  .toString()
                                                  .trim(),
                                              'phoneNumber': widget
                                                  .dataUser['phoneNumber']
                                                  .toString()
                                                  .trim(),
                                              'location': widget
                                                  .dataUser['location']
                                                  .toString()
                                                  .trim(),
                                              'entreprise': widget
                                                  .dataUser['entreprise']
                                                  .toString()
                                                  .trim(),
                                              'keyentreprise': widget
                                                  .dataUser['keyentreprise']
                                                  .toString()
                                                  .trim(),
                                              'image': val.trim(),
                                              'secteur': ListofHobby,
                                              'fcmToken': fcm,
                                              "followers": [],
                                              'share': 0
                                            }).then((value) async {
                                              setState(() {
                                                isUpload = false;
                                              });
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.setString(
                                                  'process', "final");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                  "Inscription reussi !",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ));
                                              FirebaseAuth.instance.currentUser!
                                                  .sendEmailVerification(
                                                      ActionCodeSettings(
                                                          url:
                                                              "https://www.google.com/"))
                                                  .then((value) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const VerificationMethodScreen()),
                                                    (close) => false);
                                              });
                                              print("User Added");
                                            });
                                          } else {
                                            setState(() {
                                              isUpload = false;
                                            });
                                            showAlertDialog(
                                              context: context,
                                              title: "Attention",
                                              body:
                                                  "Ce compte existe deja avec cette addresse email,veuillez en creez un autre",
                                              isError: true,
                                            );
                                          }
                                        });
                                      } else {
                                        setState(() {
                                          isUpload = false;
                                        });
                                        showAlertDialog(
                                            isError: true,
                                            context: context,
                                            title: 'Erreur',
                                            body:
                                                'Probleme de connection internet !');
                                      }
                                    });
                                  });
                                } else {
                                  setState(() {
                                    isUpload = true;
                                  });
                                  AuthServices().signOut().then((val) async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('process', "");
                                    AuthServices()
                                        .signUp(
                                            widget.dataUser['email']
                                                .toString()
                                                .trim(),
                                            widget.dataUser['password']
                                                .toString()
                                                .trim(),
                                            widget.dataUser['name']
                                                .toString()
                                                .trim())
                                        .then((value) {
                                      if (value) {
                                        FirebaseAuth.instance.currentUser!
                                            .updateDisplayName(widget
                                                .dataUser['name']
                                                .toString()
                                                .trim());
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .add({
                                          "email": widget.dataUser['email']
                                              .toString()
                                              .trim(),
                                          'name': widget.dataUser['name']
                                              .toString()
                                              .trim(),
                                          'date': widget.dataUser['date']
                                              .toString()
                                              .trim(),
                                          'phoneNumber': widget
                                              .dataUser['phoneNumber']
                                              .toString()
                                              .trim(),
                                          'location': widget
                                              .dataUser['location']
                                              .toString()
                                              .trim(),
                                          'entreprise': widget
                                              .dataUser['entreprise']
                                              .toString()
                                              .trim(),
                                          'keyentreprise': widget
                                              .dataUser['keyentreprise']
                                              .toString()
                                              .trim(),
                                          'image': '',
                                          'secteur': ListofHobby,
                                          'fcmToken': fcm,
                                          "followers": [],
                                          'share': 0
                                        }).then((value) async {
                                          setState(() {
                                            isUpload = false;
                                          });
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.setString(
                                              'process', "final");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                              "Inscription reussi !",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ));
                                          // FirebaseAuth.instance.sendSignInLinkToEmail(email: email, actionCodeSettings: ActionCodeSettings(url: url))
                                          //                                   var acs = ActionCodeSettings(
                                          // // URL you want to redirect back to. The domain (www.example.com) for this
                                          // // URL must be whitelisted in the Firebase Console.
                                          // url: 'https://www.example.com/finishSignUp?cartId=1234',
                                          // // This must be true
                                          // handleCodeInApp: true,
                                          // iOSBundleId: 'com.example.ios',
                                          // androidPackageName: 'com.example.android',
                                          // // installIfNotAvailable
                                          // androidInstallApp: true,
                                          // // minimumVersion
                                          // androidMinimumVersion: '12');
                                          FirebaseAuth.instance.currentUser!
                                              .sendEmailVerification(
                                                  ActionCodeSettings(
                                                      url:
                                                          "https://www.google.com/"))
                                              .then((value) {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const VerificationMethodScreen()),
                                                (close) => false);
                                          });

                                          print("User Added");
                                        });
                                      } else {
                                        setState(() {
                                          isUpload = false;
                                        });
                                        showAlertDialog(
                                          context: context,
                                          title: "Attention",
                                          body:
                                              "Ce compte existe deja avec cette addresse email,veuillez en creez un autre",
                                          isError: true,
                                        );
                                      }
                                    });
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Veuillez choissir au moins un secteur d'activite",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).indicatorColor),
                                  ),
                                ));
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    ListofHobby.isEmpty
                                        ? Colors.grey
                                        : Colors.green)),
                            child: const Text("S'inscrire"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        isUpload ? LoadingComponent() : const SizedBox()
      ],
    );
  }
}
