// screens/auth/views/signup_screen.dart
import 'package:adna/screens/auth/views/profile_setup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:adna/screens/auth/views/components/sign_up_form.dart';
import 'package:adna/route/route_constants.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false, _check = false;
  String password = '', email = '';
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signUp_dark.png",
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vous etes des notre !",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Bienvenue entrer vos informations correctes et creer votre compte.",
                  ),
                  const SizedBox(height: defaultPadding),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (emal) {
                            setState(() {
                              email = emal;
                            });
                          },
                          onSaved: (emal) {
                            setState(() {
                              email = emal!;
                            });
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
                          onSaved: (pass) {
                            //
                            setState(() {
                              password = pass!;
                            });
                          },
                          onChanged: (pass) {
                            setState(() {
                              password = pass;
                            });
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
                  const SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _check = !_check;
                          });
                        },
                        value: _check,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "J'acceptes avoir lue et accepter les",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, termsOfServicesScreenRoute);
                                  },
                                text: "Conditions d'utilisation ",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    "& Politique de confidentialite de la plateforme.",
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  ElevatedButton(
                    onPressed: () {
                      // Validate Form
                      if (_formKey.currentState!.validate()) {
                        if (_check) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileSetupScreen(
                                    email: email.toString().trim(),
                                    password: password.toString().trim()),
                              ));
                        } else {
                          showAlertDialog(
                              context: context,
                              title: "Attention",
                              body:
                                  "Validez les conditons d'utilisation et la politique de confidentialite puis continuez.",
                              isError: true);
                        }
                      }
                    },
                    child: const Text("Suivant"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Avez-vous deja un compte?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, logInScreenRoute);
                        },
                        child: const Text("Connectez-vous"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
