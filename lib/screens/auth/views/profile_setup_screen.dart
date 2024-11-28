// screens/auth/views/profile_setup_screen.dart
import 'dart:io';

import 'package:adna/components/product/product_card.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/database/Firebase.dart';
import 'package:adna/entry_point.dart';
import 'package:adna/screens/auth/views/custom-experience.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/screen_export.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'components/setup_profile_form.dart';
import 'components/user_image_upload.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  bool isUpload = false, _swicth = false, _showpicker = false;
  String name = '',
      date = '',
      phoneNumber = '',
      country = '',
      nameofentreprise = '',
      keyofentreprise = '';
  bool isStartLoading = false;
  List ListofLocation = ["🇫🇷 France", "🇨🇲 Cameroun"];
  String location = '';
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  @override
  Widget build(BuildContext context) {
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
        isStartLoading = false;
      });
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            // leading: const SizedBox(),
            title: const Text("Configurer votre profil"),
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
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                backgroundImage: image == null
                                    ? null
                                    : FileImage(File(image!.path)),
                                radius: 60,
                                child: SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/Profile.svg",
                                        height: 40,
                                        width: 40,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withOpacity(0.3),
                                      ),
                                      Positioned(
                                        height: 40,
                                        width: 40,
                                        right: 0,
                                        bottom: 0,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    16.0))),
                                                    contentPadding:
                                                        const EdgeInsets.all(10),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    top: 24,
                                                                    left: 24,
                                                                    right: 24,
                                                                    bottom: 8),
                                                            child: Text(
                                                              'Choisir une image',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: subtitleStyle(
                                                                  Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .color!),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              changeProfile(
                                                                  isCamera:
                                                                      true);
                                                            },
                                                            child: Container(
                                                                height: 56.0,
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                                  borderRadius:
                                                                      const BorderRadius.all(
                                                                          Radius.circular(
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
                                                                      blurRadius:
                                                                          4,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              2),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            40.0,
                                                                        width:
                                                                            40.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              primaryColor,
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(50.0)),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.4),
                                                                              blurRadius: 4,
                                                                              offset: const Offset(0, 4),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(7.0),
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            "assets/icons/camera.svg",
                                                                            width:
                                                                                16.0,
                                                                            color:
                                                                                Theme.of(context).scaffoldBackgroundColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                16.0,
                                                                            right:
                                                                                50.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              'Camera',
                                                                              style: bodyStyle(Theme.of(context).textTheme.bodyLarge!.color!),
                                                                            ),
                                                                            Text(
                                                                              "Photo",
                                                                              style: footnoteStyle(Theme.of(context).textTheme.bodyLarge!.color!),
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
                                                                  isCamera:
                                                                      false);
                                                            },
                                                            child: Container(
                                                                height: 56.0,
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                                  borderRadius:
                                                                      const BorderRadius.all(
                                                                          Radius.circular(
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
                                                                      blurRadius:
                                                                          4,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              2),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            40.0,
                                                                        width:
                                                                            40.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              primaryColor,
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(50.0)),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.4),
                                                                              blurRadius: 4,
                                                                              offset: const Offset(0, 4),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(7.0),
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            "assets/icons/gallery.svg",
                                                                            width:
                                                                                16.0,
                                                                            color:
                                                                                Theme.of(context).scaffoldBackgroundColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                16.0,
                                                                            right:
                                                                                50.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              'Gallerie',
                                                                              style: bodyStyle(Theme.of(context).textTheme.bodyLarge!.color!),
                                                                            ),
                                                                            Text(
                                                                              "Image",
                                                                              style: footnoteStyle(Theme.of(context).textTheme.bodyLarge!.color!),
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
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/icons/Camera-Bold.svg",
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Text(
                                "Choisir une image",
                                style: TextStyle(color: primaryColor),
                              )
                            ],
                          ),
                          const SizedBox(height: defaultPadding),
                          Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      name = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Nom complet ou speudo",
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: defaultPadding * 0.75),
                                      child: SvgPicture.asset(
                                        "assets/icons/Profile.svg",
                                        height: 24,
                                        width: 24,
                                        colorFilter: ColorFilter.mode(
                                            Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color!
                                                .withOpacity(0.3),
                                            BlendMode.srcIn),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        _showpicker = !_showpicker;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding * 0.75,
                                          vertical: defaultPadding * 0.25),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .color!
                                              .withOpacity(.05),
                                          borderRadius: BorderRadius.circular(
                                              defaultPadding / 1.25)),
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: defaultPadding * 0.75,
                                                horizontal:
                                                    defaultPadding * 0.75),
                                            child: SvgPicture.asset(
                                              "assets/icons/Calender.svg",
                                              height: 24,
                                              width: 24,
                                              colorFilter: ColorFilter.mode(
                                                  Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color!
                                                      .withOpacity(0.3),
                                                  BlendMode.srcIn),
                                            ),
                                          ),
                                          Text(
                                            date.isEmpty
                                                ? "Date de naissance (Ex: 24-10-1990)"
                                                : date,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .color!
                                                        .withOpacity(
                                                            date.isEmpty
                                                                ? 0.4
                                                                : 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      phoneNumber = val;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Numero de telephone",
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
                                              colorFilter: ColorFilter.mode(
                                                  Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color!
                                                      .withOpacity(0.3),
                                                  BlendMode.srcIn),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          defaultPadding / 8),
                                              child: Text(
                                                "+xxx",
                                                style: Theme.of(context)
                                                    .inputDecorationTheme
                                                    .hintStyle!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
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
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Container(
                            // margin: EdgeInsets.symmetric(
                            //     vertical: MediaQuery.of(context).size.width * .02,
                            //     horizontal: 16),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width * .12,
                              width: double.infinity,
                              child: Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  // ignore: dead_code
                                  // border: Border.all(
                                  //     width: 1, color: primaryMain),

                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.05),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      // barrierColor: primaryMain,
                                      // selectedItemHighlightColor:
                                      //     primaryColor,
                                      // focusColor: primaryColor,
                                      autofocus: true,
                                      style: TextStyle(
                                        color: primaryColor,
                                        background: Paint()..color,
                                      ),
                                      // dropdownFullScreen: true,
                                      // dropdownWidth: 200,
                                      hint: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          location.isEmpty
                                              ? "Pays d'origine"
                                              : location,
                                          style: bodyStyle(Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!
                                              .withOpacity(0.45)),
                                        ),
                                      ),
                                      onMenuStateChange: (val) {
                                        // setState(() {
                                        //   click = val;
                                        // });
                                      },

                                      isExpanded: true,
                                      items: List.generate(
                                          ListofLocation.length,
                                          (index) => DropdownMenuItem<String>(
                                                onTap: () {
                                                  setState(() {
                                                    // loading = true;
                                                  });
                                                },
                                                value: ListofLocation[index]
                                                    .toString(),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    ListofLocation[index]
                                                        .toString(),
                                                    style: bodyStyle(
                                                        Theme.of(context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .color!),
                                                  ),
                                                ),
                                              )),
                                      onChanged: (value) {
                                        setState(() {
                                          location = value!.toString();
                                        });
                                      },
                                      // icon: Icon(
                                      //   Icons
                                      //       .keyboard_arrow_down_rounded,
                                      //   color:Theme.of(context).textTheme.labelSmall!.color!
                                      // ),
                                      // iconSize: 30,
                                      // buttonDecoration: BoxDecoration(
                                      //   borderRadius:
                                      //       BorderRadius.circular(4),
                                      //   color:Theme.of(context).canvasColor,
                                      // ),
                                      // // buttonElevation: 2,
                                      // // itemHeight: 40,
                                      // itemPadding:
                                      //     const EdgeInsets.symmetric(
                                      //         horizontal: 0),
                                      // dropdownMaxHeight: 200,
                                      // // dropdownWidth: 264,
                                      // dropdownPadding:
                                      //     const EdgeInsets.all(0),
                                      // dropdownDecoration: BoxDecoration(
                                      //     borderRadius:
                                      //         BorderRadius.circular(4),
                                      //     color:
                                      //         Theme.of(context).canvasColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Container(
                            padding: const EdgeInsets.all(defaultPadding / 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.05),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(defaultBorderRadious)),
                            ),
                            child: Row(
                              children: [
                                // SvgPicture.asset(
                                //   "assets/icons/Notification.svg",
                                //   color: Theme.of(context).iconTheme.color,
                                // ),
                                const SizedBox(width: defaultPadding),
                                Text(
                                  "Etes-vous une entreprise ?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                CupertinoSwitch(
                                  activeColor: primaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _swicth = !_swicth;
                                    });
                                  },
                                  value: _swicth,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          !_swicth
                              ? const SizedBox()
                              : Column(children: [
                                  TextFormField(
                                    onChanged: (val) {
                                      setState(() {
                                        nameofentreprise = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Nom de l'entreprise",
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: defaultPadding * 0.75),
                                        child: SvgPicture.asset(
                                          "assets/icons/Address.svg",
                                          height: 24,
                                          width: 24,
                                          colorFilter: ColorFilter.mode(
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color!
                                                  .withOpacity(0.3),
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    onChanged: (val) {
                                      setState(() {
                                        keyofentreprise = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: location.contains("Cameroun")
                                          ? "Imatriculation au registre du commerce"
                                          : "Numero du SIRET",
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: defaultPadding * 0.75),
                                        child: Icon(
                                          Icons.key,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ])
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Retour"),
                        ),
                      ),
                      const SizedBox(width: defaultPadding),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (name.isEmpty ||
                                date.isEmpty ||
                                phoneNumber.isEmpty ||
                                location.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Veuillez remplir tous les champs"),
                              ));
                            } else if ((name.isEmpty ||
                                    date.isEmpty ||
                                    phoneNumber.isEmpty ||
                                    location.isEmpty ||
                                    nameofentreprise.isEmpty ||
                                    keyofentreprise.isEmpty) &&
                                _swicth) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Veuillez remplir tous les champs"),
                              ));
                            } else {
                              var userModel = {
                                "email": widget.email,
                                'name': name.trim(),
                                'password':widget.password,
                                'date': date.trim(),
                                'phoneNumber': phoneNumber.trim(),
                                'location': location.trim(),
                                'entreprise': nameofentreprise.trim(),
                                'keyentreprise': keyofentreprise.trim(),
                                'image': image,
                               
                              };
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>Experience(dataUser: userModel,)));
                            }
                          },
                          child: const Text("Suivant"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_showpicker)
          GestureDetector(
            onTap: () {
              setState(() {
                _showpicker = false;
                date = '';
              });
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(.3),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 200,
                  right: 20,
                  bottom: 200,
                ),
                child: SfDateRangePicker(
                  toggleDaySelection: true,
                  enablePastDates: true,
                  showNavigationArrow: true,
                  showActionButtons: true,
                  // showTodayButton: true,
                  confirmText: 'Annuler',
                  onSubmit: (p0) {
                    setState(() {
                      _showpicker = false;
                      date = '';
                    });
                  },
                  cancelText: '',
                  selectionShape: DateRangePickerSelectionShape.circle,
                  onSelectionChanged: (value) {
                    setState(() {
                      _showpicker = false;
                      date = value.value[0].toString().split(' ')[0];
                    });
                  },
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  initialDisplayDate:
                      DateTime.now().subtract(const Duration(days: 10000)),
                ),
              ),
            ),
          ),
        if (isUpload) LoadingComponent()
      ],
    );
  }
}
