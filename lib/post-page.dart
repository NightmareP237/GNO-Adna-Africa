// post-page.dart
import 'dart:io';

import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/components/product/product_card.dart';
import 'package:adna/components/skleton/skelton.dart';
import 'package:adna/constants.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/database/Firebase.dart';
import 'package:adna/models/posts_model.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/route/route_constants.dart';
import 'package:adna/theme/input_decoration_theme.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class PostPageScreen extends StatefulWidget {
  const PostPageScreen({super.key});

  @override
  State<PostPageScreen> createState() => _PostPageScreenState();
}

class _PostPageScreenState extends State<PostPageScreen> {
  List ListofLocation = ["🇫🇷 France", "🇨🇲 Cameroun"];
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

  String fcmToken = '';
  String location = '', secteur = '';
  bool loading = false;
  String description = '';
  List<String> imagesUrls = [];
  final ImagePicker _picker = ImagePicker();
  List<XFile>? imageFileList = [];
  // XFile? image;
  @override
  void dispose() {
    location = secteur = '';
    description = '';
    imageFileList = null;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    uploadPostsFiles(
      List<XFile> _images,
    ) async {
      _images.forEach((_image) async {
        var storage = await FirebaseStorage.instance
            .ref('posts/${_image.name}')
            .putFile(File(_image.path))
            .whenComplete(() {
          print('Upload successufully completed !');
        });
        await storage.ref.getDownloadURL().then((value) {
          imagesUrls.add(value);
        });
        setState(() {});
        print(imagesUrls);
      });
    }

    void selectImages() async {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        imageFileList!.addAll(selectedImages);
      }
      print("Image List Length:" + imageFileList!.length.toString());
      setState(() {});
      Navigator.pop(context);
      if (imageFileList!.length > 3) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Vous ne pouvez choisir que 3 images pas plus !",
            style: TextStyle(color: Theme.of(context).indicatorColor),
          ),
        ));
      }
    }
    // changeProfile({required bool isCamera}) async {
    //   try {
    //     Navigator.pop(context);

    //     if (isCamera) {
    //       image = await _picker.pickImage(source: ImageSource.camera);
    //     } else {
    //       image = await _picker.pickImage(source: ImageSource.gallery);
    //     }
    //   } catch (e) {
    //     if (kDebugMode) {
    //       print('Error : + $e');
    //     }

    //     showAlertDialog(
    //         context: context,
    //         title: 'dialog_error',
    //         body: "${'error_occured_message'} $e");
    //   }
    //   setState(() {
    //     // currentUserProfile = currentUserProfile;
    //     loading = false;
    //   });
    // }

    return Stack(
      children: [
        Scaffold(
          body: (FirebaseAuth.instance.currentUser!.displayName == null ||
                  FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
              ? Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3.2,
                  padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Publications",
                          style: bodyBoldStyle(Colors.black),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 23),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Compte inactif',
                              style: subtitleStyle(Colors.black),
                            ),
                            Text(
                              'Aucun compte actif, connectez ou inscrivez vous !',
                              style: linkStyle(Colors.black38),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ButtonCard1(
                            label: 'S\'inscrire',
                            isOutline: false,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, signUpScreenRoute);
                            }),
                        const SizedBox(
                          height: 8,
                        ),
                        ButtonCard(
                            label: 'Se connecter',
                            isOutline: true,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                logInScreenRoute,
                              );
                            }),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.2, color: primaryColor),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage((FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .photoURL ==
                                                          null ||
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .photoURL!
                                                          .isEmpty)
                                                  ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                                  : FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .photoURL!))),
                                    ),
                                    sizedBoxWidth10,
                                    TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: [
                                            Text('Tout le monde'),
                                            Icon(Icons.arrow_drop_down_outlined)
                                          ],
                                        )),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (description.isNotEmpty &&
                                        secteur.isNotEmpty &&
                                        location.isNotEmpty &&
                                        imageFileList!.isNotEmpty) {
                                      setState(() {
                                        loading = true;
                                      });
                                      // SendNotificationByHoby([secteur.trim()],
                                      //     description.trim());
                                      FirebaseMessaging.instance
                                          .getToken()
                                          .then((value) {
                                        setState(() {
                                          fcmToken = value!;
                                        });
                                      });
                                      print(fcmToken);
                                      uploadPostsFiles(imageFileList!)
                                          .then((value) {
                                        var postDataModel = PostModel(
                                            uid: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            postOwnerName: FirebaseAuth.instance
                                                .currentUser!.displayName!,
                                            description: description.trim(),
                                            urlOwnerName: FirebaseAuth.instance
                                                .currentUser!.photoURL!,
                                            secteur: secteur,
                                            fcmToken: fcmToken,
                                            location: location,
                                            favorites: [],
                                            imagePost: imagesUrls,
                                            like: 0,
                                            comment: 0,
                                            share: 0,
                                            timestamp: timestampAsSecond,
                                            commentaires: []);
                                        if (imagesUrls.isNotEmpty) {
                                          FirebaseFirestore.instance
                                              .collection('historique')
                                              .add(postDataModel.toMap());
                                          FirebaseFirestore.instance
                                              .collection('posts')
                                              .add(postDataModel.toMap())
                                              .then((value) {
                                            setState(() {
                                              description =
                                                  location = secteur = '';
                                              imagesUrls = [];
                                              imageFileList = [];
                                              loading = false;
                                            });
                                            // Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                "Publication effectuer avec success !",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .indicatorColor),
                                              ),
                                            ));
                                            print("User Added");
                                          });
                                        } else {
                                          setState(() {
                                            description =
                                                location = secteur = '';
                                            imagesUrls = [];
                                            imageFileList = [];
                                            loading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              "Oups une probleme inatendu est survenue !",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .indicatorColor),
                                            ),
                                          ));
                                        }
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Champs vide ,veuillez les remplir !",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .indicatorColor),
                                        ),
                                      ));
                                    }
                                  },
                                  child: Container(
                                      width: 90,
                                      height: 40,
                                      padding: const EdgeInsets.all(
                                          defaultPadding / 2),
                                      decoration: BoxDecoration(
                                          color: (description.isNotEmpty &&
                                                  secteur.isNotEmpty &&
                                                  location.isNotEmpty &&
                                                  imageFileList!.isNotEmpty)
                                              ? successColor
                                              : Colors.grey,
                                          border: Border.all(
                                              color: (description.isNotEmpty &&
                                                      secteur.isNotEmpty &&
                                                      location.isNotEmpty &&
                                                      imageFileList!.isNotEmpty)
                                                  ? successColor
                                                  : Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              defaultBorderRadious)),
                                      child: Center(
                                        child: Text(
                                          "Publier",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          sizedBox10,
                          Text(
                            "Creer votre annonce et poster la !",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            // controller: description,
                            maxLines: 10,
                            cursorColor: primaryColor,
                            focusNode: FocusNode(),
                            onChanged: (value) {
                              setState(() {
                                description = value;
                              });
                            },
                            onSaved: (value) {},
                            onFieldSubmitted: (value) {},
                            // validator: (value){},
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Que souhaitez vous publier ?",
                              // filled: false,
                              border: secodaryOutlineInputBorder(context),
                              enabledBorder:
                                  secodaryOutlineInputBorder(context),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                    left: 10,
                                    bottom: MediaQuery.of(context).size.height /
                                        4.2),
                                child: SvgPicture.asset(
                                  "assets/icons/Edit.svg",
                                  height: 26,
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
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadious),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!,
                                )),
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
                                          secteur.isEmpty
                                              ? "Votre secteur d'activité"
                                              : secteur,
                                          style: bodyStyle(Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!),
                                        ),
                                      ),
                                      onMenuStateChange: (val) {
                                        // setState(() {
                                        //   click = val;
                                        // });
                                      },

                                      isExpanded: true,
                                      items: List.generate(
                                          ListofExperience.length,
                                          (index) => DropdownMenuItem<String>(
                                                onTap: () {
                                                  setState(() {
                                                    // loading = true;
                                                  });
                                                },
                                                value: ListofExperience[index]
                                                    .toString(),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    ListofExperience[index]
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
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadious),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!,
                                )),
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
                                              ? "D'ou publiez vous ?"
                                              : location,
                                          style: bodyStyle(Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!),
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
                            height: 8,
                          ),
                          Text(
                            "Choisir des images de presentations",
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
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16.0))),
                                        contentPadding:
                                            const EdgeInsets.all(10),
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
                                                  'Choisir vos images',
                                                  textAlign: TextAlign.center,
                                                  style: subtitleStyle(
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color!),
                                                ),
                                              ),
                                              // GestureDetector(
                                              //   onTap: () {
                                              //     changeProfile(isCamera: true);
                                              //   },
                                              //   child: Container(
                                              //       height: 56.0,
                                              //       width: double.infinity,
                                              //       decoration: BoxDecoration(
                                              //         color: Theme.of(context)
                                              //             .scaffoldBackgroundColor,
                                              //         borderRadius:
                                              //             const BorderRadius
                                              //                 .all(
                                              //                 Radius.circular(
                                              //                     8.0)),
                                              //         boxShadow: [
                                              //           BoxShadow(
                                              //             color: Theme.of(
                                              //                     context)
                                              //                 .textTheme
                                              //                 .bodyLarge!
                                              //                 .color!
                                              //                 .withOpacity(.4),
                                              //             blurRadius: 4,
                                              //             offset: const Offset(
                                              //                 0, 2),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //       child: Padding(
                                              //         padding:
                                              //             const EdgeInsets.all(
                                              //                 8.0),
                                              //         child: Row(
                                              //           children: [
                                              //             Container(
                                              //               height: 40.0,
                                              //               width: 40.0,
                                              //               decoration:
                                              //                   BoxDecoration(
                                              //                 color:
                                              //                     primaryColor,
                                              //                 borderRadius:
                                              //                     const BorderRadius
                                              //                         .all(
                                              //                         Radius.circular(
                                              //                             50.0)),
                                              //                 boxShadow: [
                                              //                   BoxShadow(
                                              //                     color: Theme.of(
                                              //                             context)
                                              //                         .textTheme
                                              //                         .bodyLarge!
                                              //                         .color!
                                              //                         .withOpacity(
                                              //                             .4),
                                              //                     blurRadius: 4,
                                              //                     offset:
                                              //                         const Offset(
                                              //                             0, 4),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //               child: Padding(
                                              //                 padding:
                                              //                     const EdgeInsets
                                              //                         .all(7.0),
                                              //                 child: SvgPicture
                                              //                     .asset(
                                              //                   "assets/icons/camera.svg",
                                              //                   width: 16.0,
                                              //                   color: Theme.of(
                                              //                           context)
                                              //                       .scaffoldBackgroundColor,
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //             Padding(
                                              //               padding:
                                              //                   const EdgeInsets
                                              //                       .only(
                                              //                       left: 16.0,
                                              //                       right:
                                              //                           50.0),
                                              //               child: Column(
                                              //                 crossAxisAlignment:
                                              //                     CrossAxisAlignment
                                              //                         .start,
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween,
                                              //                 children: [
                                              //                   Text(
                                              //                     'Camera',
                                              //                     style: bodyStyle(Theme.of(
                                              //                             context)
                                              //                         .textTheme
                                              //                         .bodyLarge!
                                              //                         .color!),
                                              //                   ),
                                              //                   Text(
                                              //                     "Photo",
                                              //                     style: footnoteStyle(Theme.of(
                                              //                             context)
                                              //                         .textTheme
                                              //                         .bodyLarge!
                                              //                         .color!),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             )
                                              //           ],
                                              //         ),
                                              //       )),
                                              // ),
                                              // const SizedBox(
                                              //   height: 16,
                                              // ),
                                              GestureDetector(
                                                onTap: () {
                                                  selectImages();
                                                },
                                                child: Container(
                                                    height: 56.0,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8.0)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .color!
                                                              .withOpacity(.4),
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                              0, 2),
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
                                                                  const BorderRadius
                                                                      .all(
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
                                                                  blurRadius: 4,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 4),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(7.0),
                                                              child: SvgPicture
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 16.0,
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
                              child: Container(
                                width: double.infinity,
                                // height: 150,
                                padding: EdgeInsets.all(defaultPadding / 2),
                                decoration: BoxDecoration(
                                  // image: image == null
                                  //     ? null
                                  //     : DecorationImage(
                                  //         image: FileImage(File(image!.path)),
                                  //         fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(defaultBorderRadious)),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!,
                                    width: 1,
                                  ),
                                ),
                                child: imageFileList!.isNotEmpty
                                    ? StaggeredGrid.count(
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 4,
                                        children: [
                                          if (imageFileList!.length == 1)
                                            StaggeredGridTile.count(
                                              crossAxisCellCount: 4,
                                              mainAxisCellCount: 3,
                                              child: Container(
                                                child: ImageFile(
                                                    imageFileList![0].path),
                                              ),
                                            ),
                                          if (imageFileList!.length == 2)
                                            ...List.generate(
                                                imageFileList!.length,
                                                (index) =>
                                                    StaggeredGridTile.count(
                                                      crossAxisCellCount: 2,
                                                      mainAxisCellCount: 3,
                                                      child: Container(
                                                        child: ImageFile(
                                                            imageFileList![
                                                                    index]
                                                                .path),
                                                      ),
                                                    )),
                                          if (imageFileList!.length >= 3)
                                            ...List.generate(
                                              3,
                                              (index) {
                                                final imageIndex = index % 3;
                                                return StaggeredGridTile.count(
                                                  crossAxisCellCount: 2,
                                                  mainAxisCellCount:
                                                      imageIndex == 0 ? 3 : 1.5,
                                                  child: Container(
                                                    child: ImageFile(
                                                        imageFileList![index]
                                                            .path),
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                      )
                                    : StaggeredGrid.count(
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 4,
                                        children: [
                                            ...List.generate(
                                              3,
                                              (index) {
                                                final imageIndex = index % 3;
                                                return StaggeredGridTile.count(
                                                    crossAxisCellCount: 2,
                                                    mainAxisCellCount:
                                                        imageIndex == 0
                                                            ? 3
                                                            : 1.5,
                                                    child: Container(
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                            child: Stack(
                                                              children: [
                                                                Skeleton(
                                                                  layer: 3,
                                                                ),
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .wallpaper_sharp,
                                                                        size:
                                                                            40,
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge!
                                                                            .color!
                                                                            .withOpacity(0.35),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            defaultPadding /
                                                                                2,
                                                                      ),
                                                                      Text(
                                                                        "gallerie ou photo",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .labelSmall!
                                                                            .copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.35)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ))));
                                              },
                                            ),
                                          ]),
                              ))
                        ]),
                  ),
                ),
          // floatingActionButton: (FirebaseAuth
          //                 .instance.currentUser!.displayName ==
          //             null ||
          //         FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
          //     ? null
          //     : FloatingActionButton(
          //         onPressed: () {
          //           if (description.text.isNotEmpty &&
          //               secteur.isNotEmpty &&
          //               location.isNotEmpty &&
          //               image != null) {
          //             setState(() {
          //               loading = true;
          //             });
          //             SendNotificationByHoby(
          //                 [secteur.trim()], description.text.trim());
          //             Firebase.uploadImageProfile(image!, context).then((val) {
          //               if (val.isNotEmpty) {
          //                 FirebaseFirestore.instance
          //                     .collection('historique')
          //                     .add({
          //                   "description": description.text.trim(),
          //                   'secteur': secteur.trim(),
          //                   'location': location.trim(),
          //                   'image': val.trim(),
          //                   "uid": user?.uid.toString(),
          //                   "timestamp":
          //                       (DateTime.now().millisecondsSinceEpoch / 1000)
          //                           .round(),
          //                           "favorites":[],
          //                 });
          //                 FirebaseFirestore.instance.collection('posts').add({
          //                   "description": description.text.trim(),
          //                   'secteur': secteur.trim(),
          //                   'location': location.trim(),
          //                   'image': val.trim(),
          //                   "uid": user?.uid.toString(),
          //                   "timestamp":
          //                       (DateTime.now().millisecondsSinceEpoch / 1000)
          //                           .round(),
          //                           "favorites":[],
          //                 }).then((value) {
          //                   setState(() {
          //                     description.text = location = secteur = '';
          //                     image = null;
          //                     loading = false;
          //                   });
          //                   // Navigator.pop(context);
          //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //                     backgroundColor: Colors.green,
          //                     content: Text(
          //                       "Publication effectuer avec success !",
          //                       style: TextStyle(
          //                           color: Theme.of(context).indicatorColor),
          //                     ),
          //                   ));
          //                   print("User Added");
          //                 });
          //               }
          //             });
          //           } else {
          //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //               content: Text(
          //                 "Champs vide ,veuillez les remplir !",
          //                 style: TextStyle(
          //                     color: Theme.of(context).indicatorColor),
          //               ),
          //             ));
          //           }
          //         },
          //         backgroundColor: primaryColor,
          //         child: Text('Publier', style: TextStyle(color: Colors.white)),
          //       ),
        ),
        if (loading) LoadingComponent()
      ],
    );
  }

  static Future<bool> SendNotificationByHoby(
      List<String> experience, String annonce) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        "sendNotificationHoby",
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      final response = await callable.call(<String, dynamic>{
        'interests': experience,
        'annonce': annonce,
      });
      print('result is ${response.data ?? 'No data came back'}');
      if (response.data == null) return false;
      return true;
    } on FirebaseFunctionsException catch (e) {
      print("this is the error $e");
      return false;
    }
  }
}
