// screens/user_info/views/edit_user_info_screen.dart
import 'dart:io';

import 'package:adna/components/product/product_card.dart';
import 'package:adna/entry_point.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:adna/database/Firebase.dart';
import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/constants.dart';
import 'package:image_picker/image_picker.dart';

import 'components/user_info_form.dart';

class EditUserInfoScreen extends StatefulWidget {
  EditUserInfoScreen({super.key, required this.userInfo});
  UserInfoView userInfo = UserInfoView(
    birthday: '',
    country: '',
      fcmToken: '',
    email: '',
    name: '',
    image: '',
    phoneNumber: '',
    entreprise: '',
    keyofentreprise: '',
    secteur: [],
    followers: []
  );
  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  bool isUpload = false;
  final name = TextEditingController(),
      email = TextEditingController(),
      date = TextEditingController(),
      phoneNumber = TextEditingController();
  changeProfile({required bool isCamera}) async {
    try {
      Navigator.pop(context);

      if (isCamera) {
        image = await _picker.pickImage(source: ImageSource.camera);
      } else {
        image = await _picker.pickImage(source: ImageSource.gallery);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error : + $e');
      }

      showAlertDialog(
          context: context,
          title: 'dialog_error',
          body: "${'error_occured_message'} $e");
    }
    setState(() {
      // currentUserProfile = currentUserProfile;
      isUpload = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Modifier mon profil"),
            actions: [
              IconButton(
                onPressed: () async {},
                icon: SvgPicture.asset(
                  "assets/icons/info.svg",
                  color: Theme.of(context).iconTheme.color,
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            image == null
                                ? CircleAvatar(
                                    radius: 60,
                                    child: NetworkImageWithLoader(
                                      FirebaseAuth
                                          .instance.currentUser!.photoURL!,
                                      radius: 60,
                                      expand: true,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    backgroundImage: image == null
                                        ? null
                                        : FileImage(File(image!.path)),
                                    radius: 60,
                                    child: null),
                            Positioned(
                              bottom: -14,
                              right: -14,
                              child: SizedBox(
                                height: 56,
                                width: 56,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.0))),
                                            contentPadding: const EdgeInsets.all(10),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.only(
                                                        top: 24,
                                                        left: 24,
                                                        right: 24,
                                                        bottom: 8),
                                                    child: Text(
                                                      'Choisir une image',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: subtitleStyle(
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .color!),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      changeProfile(
                                                          isCamera: true);
                                                    },
                                                    child: Container(
                                                        height: 56.0,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Theme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor,
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color!
                                                                  .withOpacity(
                                                                      .4),
                                                              blurRadius: 4,
                                                              offset:
                                                                  const Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  8.0),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: 40.0,
                                                                width: 40.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      primaryColor,
                                                                  borderRadius:
                                                                      const BorderRadius.all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .color!
                                                                          .withOpacity(
                                                                              .4),
                                                                      blurRadius:
                                                                          4,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              4),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                              7.0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/icons/camera.svg",
                                                                    width: 16.0,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .scaffoldBackgroundColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            16.0,
                                                                        right:
                                                                            50.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Camera',
                                                                      style: bodyStyle(Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .color!),
                                                                    ),
                                                                    Text(
                                                                      "Photo",
                                                                      style: footnoteStyle(Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .color!),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      changeProfile(
                                                          isCamera: false);
                                                    },
                                                    child: Container(
                                                        height: 56.0,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Theme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor,
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color!
                                                                  .withOpacity(
                                                                      .4),
                                                              blurRadius: 4,
                                                              offset:
                                                                  const Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  8.0),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: 40.0,
                                                                width: 40.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      primaryColor,
                                                                  borderRadius:
                                                                      const BorderRadius.all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .color!
                                                                          .withOpacity(
                                                                              .4),
                                                                      blurRadius:
                                                                          4,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              4),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                              7.0),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "assets/icons/gallery.svg",
                                                                    width: 16.0,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .scaffoldBackgroundColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            16.0,
                                                                        right:
                                                                            50.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Gallerie',
                                                                      style: bodyStyle(Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .color!),
                                                                    ),
                                                                    Text(
                                                                      "Image",
                                                                      style: footnoteStyle(Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .color!),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    side: BorderSide(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/icons/Edit-Bold.svg",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Changer ma photo"),
                        ),
                        const SizedBox(height: defaultPadding),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Column(
                            children: [
                              TextField(
                                // initialValue: ,
                                textInputAction: TextInputAction.next,
                                controller: name,
                                decoration: InputDecoration(
                                  hintText: widget.userInfo.name,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: defaultPadding * 0.75),
                                    child: SvgPicture.asset(
                                      "assets/icons/Profile.svg",
                                      color: Theme.of(context).iconTheme.color,
                                      height: 24,
                                      width: 24,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding),
                                child: TextField(
                                  controller: email,
                                  // initialValue:,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: widget.userInfo.email,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: defaultPadding * 0.75),
                                      child: SvgPicture.asset(
                                        "assets/icons/Message.svg",
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextField(
                                // initialValue: ,
                                controller: date,
                                decoration: InputDecoration(
                                  hintText: widget.userInfo.birthday,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: defaultPadding * 0.75),
                                    child: SvgPicture.asset(
                                      "assets/icons/Calender.svg",
                                      color: Theme.of(context).iconTheme.color,
                                      height: 24,
                                      width: 24,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding),
                                child: TextField(
                                  // initialValue: ,
                                  controller: phoneNumber,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: widget.userInfo.phoneNumber,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: defaultPadding),
                                      child: SizedBox(
                                        width: 72,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/Call.svg",
                                              height: 24,
                                              width: 24,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color!,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: widget
                                                          .userInfo.country
                                                          .contains("Cameroun")
                                                      ? 0
                                                      : 4),
                                              child: Text(
                                                  widget.userInfo.country
                                                          .contains("Cameroun")
                                                      ? "+237"
                                                      : "+33",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                            ),
                                            const SizedBox(
                                              height: 24,
                                              child: VerticalDivider(
                                                thickness: 1,
                                                width: defaultPadding / 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: ElevatedButton(
                    onPressed: () {
                      if (image != null) {
                        setState(() {
                          isUpload = true;
                          print("loading...");
                        });
                        Firebase.uploadImageProfile(image!, context)
                            .then((val) {
                          if (val.isNotEmpty) {
                            FirebaseAuth.instance.currentUser!
                                .updatePhotoURL(val);
                            FirebaseAuth.instance.currentUser!
                                .updateDisplayName(name.text.isEmpty
                                    ? widget.userInfo.name
                                    : name.text.trim());
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid
                                    .toString())
                                .update({
                              "email": email.text.isEmpty
                                  ? widget.userInfo.email
                                  : email.text.trim(),
                              'name': name.text.isEmpty
                                  ? widget.userInfo.name
                                  : name.text.trim(),
                              'date': date.text.isEmpty
                                  ? widget.userInfo.birthday
                                  : date.text.trim(),
                              'phoneNumber': phoneNumber.text.isEmpty
                                  ? widget.userInfo.phoneNumber
                                  : phoneNumber.text.trim(),
                              'location': widget.userInfo.country,
                              'entreprise': widget.userInfo.entreprise,
                              'keyentreprise': widget.userInfo.keyofentreprise,
                              'image': val,
                            }).then((value) {
                              setState(() {
                                isUpload = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "mise a jour du profil reussi !",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const EntryPoint()),
                                  (close) => false);

                              print("User updated !");
                            });
                          }
                        });
                      } else {
                        setState(() {
                          isUpload = true;
                        });
                        FirebaseAuth.instance.currentUser!.updateDisplayName(
                            name.text.isEmpty
                                ? widget.userInfo.name
                                : name.text.trim());
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid
                                .toString())
                            .update({
                          "email": email.text.isEmpty
                              ? widget.userInfo.email
                              : email.text.trim(),
                          'name': name.text.isEmpty
                              ? widget.userInfo.name
                              : name.text.trim(),
                          'date': date.text.isEmpty
                              ? widget.userInfo.birthday
                              : date.text.trim(),
                          'phoneNumber': phoneNumber.text.isEmpty
                              ? widget.userInfo.phoneNumber
                              : phoneNumber.text.trim(),
                          'location': widget.userInfo.country,
                          'entreprise': widget.userInfo.entreprise,
                          'keyentreprise': widget.userInfo.keyofentreprise,
                          'image':  widget.userInfo.image,
                        }).then((value) {
                          setState(() {
                            isUpload = false;
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "mise a jour du profil reussi !",
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const EntryPoint()),
                              (close) => false);
                          print("User updated !");
                        });
                      }
                    },
                    child: const Text("Mettre a jour"),
                  ),
                )
              ],
            ),
          ),
        ),
        if (isUpload) LoadingComponent()
      ],
    );
  }
}
