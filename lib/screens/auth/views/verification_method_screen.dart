// screens/auth/views/verification_method_screen.dart
import 'dart:async';

import 'package:adna/entry_point.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/screen_export.dart';

import 'components/verification_method_card.dart';

class VerificationMethodScreen extends StatefulWidget {
  const VerificationMethodScreen({super.key});

  @override
  State<VerificationMethodScreen> createState() =>
      _VerificationMethodScreenState();
}

class _VerificationMethodScreenState extends State<VerificationMethodScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? "assets/Illustration/Password.png"
                        : "assets/Illustration/Password_dark.png",
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                const Spacer(),
                Text(
                  "Verification d'information",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: defaultPadding / 2),
                const Text(
                    "Nous avons envoyer un lien d'authentification a votre addresse email. Consultez vous mails !"),
                // const Spacer(),
                // VerificationMethodCard(
                //   text: "+19******1233",
                //   svgSrc: "assets/icons/Call.svg",
                //   isActive: true,
                //   press: () {},
                // ),
                const SizedBox(height: defaultPadding),
                VerificationMethodCard(
                  text: "${FirebaseAuth.instance.currentUser!.email!
                          .substring(0, 7)}*******@gmail.com",
                  svgSrc: "assets/icons/Message.svg",
                  isActive: true,
                  press: () {},
                ),
                const Spacer(),
                const Spacer(),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    FirebaseAuth.instance.currentUser!.reload();
                    Timer(const Duration(seconds: 4), () {
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const EntryPoint()),
                            (close) => false);
                      } else {
                        setState(() {
                          loading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).canvasColor,
                          content: const Text(
                            "Email non verifie !",
                            style: TextStyle(color: Colors.red),
                          ),
                        ));
                      }
                    });
                  },
                  child: loading
                      ? const Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeCap: StrokeCap.butt,
                            semanticsValue: AutofillHints.countryCode,
                          ),
                        )
                      : const Text("Verifier"),
                )
              ],
            ),
          ),
        ),
      );
}
