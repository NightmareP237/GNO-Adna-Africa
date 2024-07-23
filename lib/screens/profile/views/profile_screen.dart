// screens/profile/views/profile_screen.dart
import 'package:adna/components/product/product_card.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/historique.dart';
import 'package:adna/statut-auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:adna/components/list_tile/divider_list_tile.dart';
import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/screen_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthServices auth = AuthServices();
  User? user;
  String? photoURL;
  Future<User?> getuser() async {
    return user = await auth.user;
  }

  @override
  void initState() {
    // TODO: implement initState
    getuser().then((us) {
      setState(() {
        user = us;
        photoURL = user?.photoURL;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ProfileCard(
            name: (FirebaseAuth.instance.currentUser!.displayName == null ||
                    FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
                ? "Aucune connexion"
                : FirebaseAuth.instance.currentUser!.displayName!,
            email: (FirebaseAuth.instance.currentUser!.displayName == null ||
                    FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
                ? "Aucune connexion"
                : FirebaseAuth.instance.currentUser!.email!,
            imageSrc: (FirebaseAuth.instance.currentUser!.displayName == null ||
                    FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
                ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                : photoURL == null
                    ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                    : photoURL!,
            // proLableText: "Sliver",
            isPro: user == null ? false : true,
            press: () {
              if ((FirebaseAuth.instance.currentUser!.displayName == null ||
                  FirebaseAuth.instance.currentUser!.displayName!.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Aucun compte actif, veuillez vous connectez ! ",
                    style: TextStyle(color: Colors.white),
                  ),
                ));
              } else {
                Navigator.pushNamed(context, userInfoScreenRoute);
              }
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       horizontal: defaultPadding, vertical: defaultPadding * 1.5),
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: const AspectRatio(
          //       aspectRatio: 1.8,
          //       child:
          //           NetworkImageWithLoader("https://i.imgur.com/dz0BBom.png"),
          //     ),
          //   ),
          (FirebaseAuth.instance.currentUser!.displayName == null ||
                  FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
              ? // ),
              Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 3.2,
                        padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Aucun compte actif !'),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 80,
                              ),
                              ButtonCard1(
                                  label: 'S\'inscrire',
                                  isOutline: false,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, signUpScreenRoute);
                                  }),
                              SizedBox(
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
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Text(
                        "Mon Compte",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    ProfileMenuListTile(
                      text: "Mes posts",
                      svgSrc: "assets/icons/Order.svg",
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => HistoriqueScreen()));
                      },
                    ),
                    // ProfileMenuListTile(
                    //   text: "Returns",
                    //   svgSrc: "assets/icons/Return.svg",
                    //   press: () {},
                    // ),
                    // ProfileMenuListTile(
                    //   text: "Wishlist",
                    //   svgSrc: "assets/icons/Wishlist.svg",
                    //   press: () {},
                    // ),
                    ProfileMenuListTile(
                      text: "Addresses",
                      svgSrc: "assets/icons/Address.svg",
                      press: () {
                        Navigator.pushNamed(context, addressesScreenRoute);
                      },
                    ),
                    ProfileMenuListTile(
                      text: "Payment",
                      svgSrc: "assets/icons/card.svg",
                      press: () {
                        Navigator.pushNamed(context, emptyPaymentScreenRoute);
                      },
                    ),
                    // ProfileMenuListTile(
                    //   text: "Wallet",
                    //   svgSrc: "assets/icons/Wallet.svg",
                    //   press: () {
                    //     Navigator.pushNamed(context, walletScreenRoute);
                    //   },
                    // ),
                    const SizedBox(height: defaultPadding),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2),
                      child: Text(
                        "Personalization",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    DividerListTileWithTrilingText(
                      svgSrc: "assets/icons/Notification.svg",
                      title: "Notification",
                      trilingText: "Off",
                      press: () {
                        Navigator.pushNamed(
                            context, enableNotificationScreenRoute);
                      },
                    ),
                    ProfileMenuListTile(
                      text: "Preferences",
                      svgSrc: "assets/icons/Preferences.svg",
                      press: () {
                        Navigator.pushNamed(context, preferencesScreenRoute);
                      },
                    ),
                    const SizedBox(height: defaultPadding),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2),
                      child: Text(
                        "Settings",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    ProfileMenuListTile(
                      text: "Language",
                      svgSrc: "assets/icons/Language.svg",
                      press: () {
                        Navigator.pushNamed(context, selectLanguageScreenRoute);
                      },
                    ),
                    ProfileMenuListTile(
                      text: "Location",
                      svgSrc: "assets/icons/Location.svg",
                      press: () {},
                    ),
                    const SizedBox(height: defaultPadding),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2),
                      child: Text(
                        "Help & Support",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    ProfileMenuListTile(
                      text: "Get Help",
                      svgSrc: "assets/icons/Help.svg",
                      press: () {
                        Navigator.pushNamed(context, getHelpScreenRoute);
                      },
                    ),
                    ProfileMenuListTile(
                      text: "FAQ",
                      svgSrc: "assets/icons/FAQ.svg",
                      press: () {},
                      isShowDivider: false,
                    ),
                    const SizedBox(height: defaultPadding),
                    // Log Out
                    ListTile(
                      onTap: () {
                        showAlertDialog2(
                            context: context,
                            title: "Deconnexion",
                            body: "La deconnexion sera definitive !",
                            methodYes: () {
                              Navigator.pop(context);
                               AuthServices().signOut().then((value) async{
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('process', "");
                          if (value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoginScreen()));
                          }
                        });
                            });
                      },
                      minLeadingWidth: 24,
                      leading: SvgPicture.asset(
                        "assets/icons/Logout.svg",
                        height: 24,
                        width: 24,
                        color: errorColor,
                      ),
                      title: const Text(
                        "Deconnexion",
                        style: TextStyle(
                            color: errorColor, fontSize: 14, height: 1),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
