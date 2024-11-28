// edit-post.dart
import 'dart:io';
import 'dart:io';

import 'package:adna/components/product/product_card.dart';
import 'package:adna/constants.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/database/Firebase.dart';
import 'package:adna/theme/input_decoration_theme.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class EditPostScreen extends StatefulWidget {
  EditPostScreen(
      {super.key,
      required this.docHistoryId,
      required this.docPostId,
      required this.activity,
      required this.annonce,
      required this.imageUrl,
      required this.postName});
  String postName, activity, annonce, imageUrl, docPostId, docHistoryId;
  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  List ListofLocation = ["🇫🇷 France", "🇨🇲 Cameroun"];
  List ListofSectors = [
    "Plomberie",
    "Electricite",
    "Depannage",
    "Agro-Alimentaire",
    "Avocat",
    "Product designer",
    "Agent de Netoyage",
    "Prestation de service",
    "Electronique"
  ];
  AuthServices auth = AuthServices();
  User? user;
  Future<User?> getuser() async {
    return user = await auth.user;
  }

  @override
  void initState() {
    // TODO: implement initState
    getuser().then((user) {
      setState(() {
        this.user = user;
      });
    });
    super.initState();
  }

  String location = '', secteur = '';
  bool loading = false;
  final description = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  @override
  void dispose() {
    location = secteur = '';
    description.text = '';
    image = null;
    // TODO: implement dispose
    super.dispose();
  }

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
        loading = false;
      });
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Modification du poste"),
          ),
          body: Container(
            padding: const EdgeInsets.all(defaultPadding),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //   Container(
                    //     width: double.infinity,
                    //     height: 200,
                    // // child: Col,
                    //   ),
                    Text(
                      "Modifier votre annonce et reposter la !",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: description,
                      maxLines: 7,
                      autofocus: false,
                      cursorColor: primaryColor,
                      focusNode: FocusNode(),
                      enabled: true,
                      // onChanged: (value) {
                      //   setState(() {
                      //     description = value;
                      //   });
                      // },
                      onSaved: (value) {},
                      onFieldSubmitted: (value) {},
                      // validator: (value){},
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: widget.postName,
                        filled: false,
                        border: secodaryOutlineInputBorder(context),
                        enabledBorder: secodaryOutlineInputBorder(context),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              left: 10,
                              bottom: MediaQuery.of(context).size.height / 5.2),
                          child: SvgPicture.asset(
                            "assets/icons/Edit.svg",
                            height: 24,
                            color: Theme.of(context)
                                .iconTheme
                                .color!
                                .withOpacity(0.3),
                          ),
                        ),
                        // suffixIcon: SizedBox(
                        //   width: 40,
                        //   child: Row(
                        //     children: [
                        //       const SizedBox(
                        //         height: 24,
                        //         child: VerticalDivider(width: 1),
                        //       ),
                        //       Expanded(
                        //         child: IconButton(
                        //           onPressed: onTabFilter,
                        //           icon: SvgPicture.asset(
                        //             "assets/icons/Filter.svg",
                        //             height: 24,
                        //             color: Theme.of(context).iconTheme.color,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Quel est votre secteur d'activite ?",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 8,
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
                          padding: const EdgeInsets.symmetric(horizontal: 1),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
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
                                    secteur.isEmpty ? widget.activity : secteur,
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
                                    ListofSectors.length,
                                    (index) => DropdownMenuItem<String>(
                                          onTap: () {
                                            setState(() {
                                              // loading = true;
                                            });
                                          },
                                          value:
                                              ListofSectors[index].toString(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              ListofSectors[index].toString(),
                                              style: bodyStyle(Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .color!),
                                            ),
                                          ),
                                        )),
                                onChanged: (value) {
                                  setState(() {
                                    secteur = value!.toString();
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
                      height: 8,
                    ),
                    Text(
                      "D'ou publiez vous cette annance ?",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 8,
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
                          padding: const EdgeInsets.symmetric(horizontal: 1),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
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
                                        ? widget.annonce
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
                                          value:
                                              ListofLocation[index].toString(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              ListofLocation[index].toString(),
                                              style: bodyStyle(Theme.of(context)
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
                      height: 8,
                    ),
                    Text(
                      "Modifier l' image de presentation",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                          textAlign: TextAlign.center,
                                          style: subtitleStyle(Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          changeProfile(isCamera: true);
                                        },
                                        child: Container(
                                            height: 56.0,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color!
                                                      .withOpacity(.4),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 40.0,
                                                    width: 40.0,
                                                    decoration: BoxDecoration(
                                                      color: primaryColor,
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
                                                              .withOpacity(.4),
                                                          blurRadius: 4,
                                                          offset: const Offset(0, 4),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(7.0),
                                                      child: SvgPicture.asset(
                                                        "assets/icons/camera.svg",
                                                        width: 16.0,
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16.0,
                                                        right: 50.0),
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
                                                          style: bodyStyle(
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color!),
                                                        ),
                                                        Text(
                                                          "Photo",
                                                          style: footnoteStyle(
                                                              Theme.of(context)
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
                                          changeProfile(isCamera: false);
                                        },
                                        child: Container(
                                            height: 56.0,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color!
                                                      .withOpacity(.4),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 40.0,
                                                    width: 40.0,
                                                    decoration: BoxDecoration(
                                                      color: primaryColor,
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
                                                              .withOpacity(.4),
                                                          blurRadius: 4,
                                                          offset: const Offset(0, 4),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(7.0),
                                                      child: SvgPicture.asset(
                                                        "assets/icons/gallery.svg",
                                                        width: 16.0,
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16.0,
                                                        right: 50.0),
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
                                                          style: bodyStyle(
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color!),
                                                        ),
                                                        Text(
                                                          "Image",
                                                          style: footnoteStyle(
                                                              Theme.of(context)
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
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          image: image == null
                              ? DecorationImage(
                                  image: NetworkImage(widget.imageUrl),
                                  fit: BoxFit.cover)
                              : DecorationImage(
                                  image: FileImage(File(image!.path)),
                                  fit: BoxFit.cover),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(defaultBorderRadious)),
                          border: Border.all(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: image != null
                            ? const SizedBox()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wallpaper_sharp,
                                    size: 40,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.25),
                                  ),
                                  const SizedBox(
                                    height: defaultPadding / 2,
                                  ),
                                  Text(
                                    "Prendre une image de gallerie ou de l'appareil photo",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                      ),
                    )
                  ]),
            ),
          ),
          floatingActionButton: user == null
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    if (description.text.isNotEmpty ||
                        secteur.isNotEmpty ||
                        location.isNotEmpty ||
                        image != null) {
                      setState(() {
                        loading = true;
                      });
                      Firebase.uploadImageProfile(image!, context).then((val) {
                        if (val.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.docPostId)
                              .update({
                            "description": description.text.trim().isEmpty
                                ? widget.postName
                                : description.text.trim(),
                            'secteur': secteur.isEmpty
                                ? widget.activity
                                : secteur.trim(),
                            'location': location.isEmpty
                                ? widget.annonce
                                : location.trim(),
                            'image':
                                image == null ? widget.imageUrl : val.trim(),
                            "uid": user?.uid.toString(),
                            "timestamp":
                                (DateTime.now().millisecondsSinceEpoch / 1000)
                                    .round()
                          }).then((value) {
                            FirebaseFirestore.instance
                                .collection('historique')
                                .doc(widget.docPostId)
                                .update({
                              "description": description.text.trim().isEmpty
                                  ? widget.postName
                                  : description.text.trim(),
                              'secteur': secteur.isEmpty
                                  ? widget.activity
                                  : secteur.trim(),
                              'location': location.isEmpty
                                  ? widget.annonce
                                  : location.trim(),
                              'image':
                                  image == null ? widget.imageUrl : val.trim(),
                              "uid": user?.uid.toString(),
                              "timestamp":
                                  (DateTime.now().millisecondsSinceEpoch / 1000)
                                      .round()
                            }).then((vaue) {
                              setState(() {
                                description.text = location = secteur = '';
                                image = null;
                                loading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "Publication effectuer avec success !",
                                  style: TextStyle(
                                      color: Theme.of(context).indicatorColor),
                                ),
                              ));
                            });
                            print("User Added");
                          });
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Aucun Champs modifier ,veuillez les remplir !",
                          style: TextStyle(
                              color: Theme.of(context).indicatorColor),
                        ),
                      ));
                    }
                  },
                  backgroundColor: primaryColor,
                  child: Text('Publier', style: TextStyle(color: Colors.white)),
                ),
        ),
        if (loading) LoadingComponent()
      ],
    );
  }
}
