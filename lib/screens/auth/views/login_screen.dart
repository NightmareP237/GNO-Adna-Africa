// screens/auth/views/login_screen.dart
import 'package:adna/database/Auth.dart';
import 'package:adna/entry_point.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/route_constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false,obscureText=false;
  String email = '', password = '';
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
                      SizedBox(
                        height: size.height > 700
                            ? size.height * 0.02
                            : defaultPadding,
                      ),
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
                                          builder: (_) => EntryPoint()),
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
                )
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
