// screens/auth/views/password_recovery_screen.dart
import 'package:adna/widgets/loader-component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adna/constants.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

bool loading = false;

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  var editingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future ResetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: editingController.text.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      showAlertDialog(
          context: context, title: "Erreur", body: e.message.toString());
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    editingController.dispose();
    loading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: defaultPadding),
                  Text(
                    "Mot de passe oublie",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                      "Entrer votre addresse email et modifier votre mot de passe"),
                  const SizedBox(height: defaultPadding * 2),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      controller: editingController,
                      validator: emaildValidator.call,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Adresse email",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75),
                          child: SvgPicture.asset(
                            "assets/icons/Message.svg",
                            height: 24,
                            width: 24,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        ResetPassword().then((value) {
                          if (value) {
                            setState(() {
                              loading = !value;
                            });
                            showAlertDialog(
                                method: () {
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                context: context,
                                title: "Success",
                                button: "Se connecter",
                                body:
                                    "Consulter votre adresse email un lien de mise a jour de votre mot de passe vous a ete envoye.");
                          }
                        });
                      }
                    },
                    child: const Text("Modifier le mot de passe"),
                  )
                ],
              ),
            ),
          ),
        ),
        if (loading) LoadingComponent()
      ],
    );
  }
}
