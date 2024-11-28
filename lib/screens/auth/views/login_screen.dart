// screens/auth/views/login_screen.dart
import 'package:adna/database/Auth.dart';
import 'package:adna/entry_point.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/route_constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false, obscureText = false;
  String email = '', password = '';
  String? fcmToken;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcmToken = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/login_dark.png",
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Heureux de vous revoir!",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: defaultPadding / 2),
                      const Text(
                        "Remplissez vous informations et connectez-vous .",
                      ),
                      const SizedBox(height: defaultPadding),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              onSaved: (emal) {
                                // Email
                              },
                              validator: emaildValidator.call,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Addresse email",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding * 0.75),
                                  child: SvgPicture.asset(
                                    "assets/icons/Message.svg",
                                    height: 24,
                                    width: 24,
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withOpacity(0.3),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: defaultPadding),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              onSaved: (pass) {
                                // Password
                              },
                              validator: passwordValidator.call,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: defaultPadding * 0.75),
                                    child: SvgPicture.asset(
                                      obscureText
                                          ? "assets/icons/eye.svg"
                                          : "assets/icons/eye_close.svg",
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
                                hintText: "Mot de passe",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding * 0.75),
                                  child: SvgPicture.asset(
                                    "assets/icons/Lock.svg",
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
                          ],
                        ),
                      ),
                      // Align(
                      //   child: TextButton(
                      //     child: const Text("Forgot password"),
                      //     onPressed: () {
                      //       Navigator.pushNamed(
                      //           context, passwordRecoveryScreenRoute);
                      //     },
                      //   ),
                      // ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, passwordRecoveryScreenRoute);
                            },
                            child: const Text("Mot de passe oublie?"),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: size.height > 700
                      //       ? size.height * 0.02
                      //       : defaultPadding,
                      // ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            AuthServices().signOut().then((val) async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('process', "");
                              AuthServices()
                                  .signIn(email.trim(), password.trim())
                                  .then((val) async {
                                if (val) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    "fcmToken": fcmToken,
                                  });
                                  setState(() {
                                    loading = !val;
                                  });
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('process', "final");
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "Connexion reussi !",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const EntryPoint()),
                                      (close) => false);
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  showAlertDialog(
                                      isError: true,
                                      context: context,
                                      title: "Erreur",
                                      body:
                                          "Addresse email ou mot de passe incorrect !");
                                }
                              });
                            });

                            // Navigator.pushNamedAndRemoveUntil(
                            //     context,
                            //     entryPointScreenRoute,
                            //     ModalRoute.withName(logInScreenRoute));
                          }
                        },
                        child: const Text("Connexion"),
                      ),
                      sizedBox20,
                      const SocialButton(
                        social: "google",
                        fcmToken: "",
                      ),
                      sizedBox10,
                      const SocialButton(social: "facebook", fcmToken: ""),
                      sizedBox5,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Vous n'avez pas de compte?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, signUpScreenRoute);
                            },
                            child: const Text("Inscrivez-vous"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // ignore: dead_code
        if (loading) LoadingComponent()
      ],
    );
  }
}

class SocialButton extends StatefulWidget {
  const SocialButton({super.key, required this.social, required this.fcmToken});

  final String social, fcmToken;

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8),
        side: const BorderSide(width: 1, color: Colors.black),
      ),
      onPressed: () async{
        if (widget.social == "google") {
          // Future<UserCredential> signInWithGoogle() async {
            AuthServices().signOut();
            print("Disconnection of account...");
            // Trigger the authentication flow

            //  if (googleAuth != null) {
            // }
            final GoogleSignInAccount? googleUser =
                await GoogleSignIn().signIn();

            // Obtain the auth details from the request
            final GoogleSignInAuthentication? googleAuth =
                await googleUser?.authentication;

            // Create a new credential
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );
            //  if (googleAuth != null) {
            //   AuthServices().signOut();
            // }
            // Once signed in, return the UserCredential
            var resultAuth =
                await FirebaseAuth.instance.signInWithCredential(credential);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "Connexion reussi !",
                style: TextStyle(color: Colors.white),
              ),
            ));
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const EntryPoint()),
                (close) => false);
            // return resultAuth;
          // }

          // showAlertDialog(
          //     isError: true,
          //     context: context,
          //     title: "Erreur",
          //     body: "Aucune ou mauvaise connexion internet !");
        }else{
          // ignore: avoid_print
          showAlertDialog(
              isError: true,
              context: context,
              title: "Erreur",
              body: "Connexion par facebook indisponible pour l'instand !"
              );
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              'assets/images/${widget.social}.png',
              width: 40,
              height: 40,
            ),
            Text(
              widget.social.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
