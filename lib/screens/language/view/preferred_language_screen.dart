// screens/language/view/preferred_language_screen.dart
import 'package:adna/database/Auth.dart';
import 'package:adna/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/route_constants.dart';
import 'package:adna/theme/input_decoration_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as launch;

import 'components/language_card.dart';

class PreferredLanguageScreen extends StatefulWidget {
  const PreferredLanguageScreen({super.key});

  @override
  State<PreferredLanguageScreen> createState() =>
      _PreferredLanguageScreenState();
}

int selected = 0;
final Uri _url = Uri.parse('https://flutter.dev');
bool loading = false;

class _PreferredLanguageScreenState extends State<PreferredLanguageScreen> {
  Future<bool> CheckConnection() async {
    try {
      await launch.canLaunchUrl(_url);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                "Langue de preference ",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text(
                  "Vous utiliserez cette langue par defaut dans l'application"),
              const Spacer(
                flex: 1,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              //   child: Form(
              //     child: TextFormField(
              //       onSaved: (language) {},
              //       validator: (value) {
              //         return null;
              //       }, // validate your textfield
              //       decoration: InputDecoration(
              //         hintText: "Search your language",
              //         filled: false,
              //         prefixIcon: Padding(
              //           padding: const EdgeInsets.all(defaultPadding / 2),
              //           child: SvgPicture.asset(
              //             "assets/icons/Search.svg",
              //             height: 24,
              //             width: 24,
              //             color: Theme.of(context)
              //                 .textTheme
              //                 .bodyLarge!
              //                 .color!
              //                 .withOpacity(0.25),
              //           ),
              //         ),
              //         border: secodaryOutlineInputBorder(context),
              //         enabledBorder: secodaryOutlineInputBorder(context),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 6,
                child: ListView.separated(
                  itemCount: 2,
                  itemBuilder: (context, index) => LanguageCard(
                    language: demoLanguage[index],
                    flag: demoFlags[index],
                    isActive: index == selected,
                    press: () {
                      setState(() {
                        selected = index;
                      });
                    },
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: defaultPadding / 2,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    loading = true;
                  });
                  CheckConnection().then((value) {
                    if (value) {
                      AuthServices().signInAnonymously().then((value) async {
                        if (value) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('process', "final");
                          setState(() {
                            loading = value;
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const EntryPoint()),
                            (route) => false,
                          );
                        } else {
                          setState(() {
                            loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Aucune connexion internet...",
                              style: TextStyle(color: Theme.of(context).indicatorColor),
                            ),
                          ),
                          );
                        }
                      });
                    }
                  });
                },
                child: loading
                    ? const CircularProgressIndicator(
                        strokeWidth: 1.4,
                        color: Colors.white,
                      )
                    : const Text("Suivant"),
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}

// Only for preview
const List<String> demoFlags = [
  "assets/flags/England.svg",
  "assets/flags/france.svg",
  "assets/flags/German.svg",
  "assets/flags/India.svg",
  "assets/flags/Italy.svg",
  "assets/flags/japaness.svg",
];
const List<String> demoLanguage = [
  "Anglais",
  "Francais",
  "German",
  "India",
  "Italy",
  "Japaness"
];
