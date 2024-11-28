// constants.dart
import 'package:adna/components/product/product_card.dart';
import 'package:adna/route/route_constants.dart';
import 'package:adna/screens/auth/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

// Just for demo
const productDemoImg1 = "assets/images/cuisine.jpeg";
const productDemoImg2 = "assets/images/cleaning.jpeg";
const productDemoImg3 = "assets/images/cuisine.jpeg";
const productDemoImg4 = "assets/images/cleaning.jpeg";
const productDemoImg5 = "assets/images/cuisine.jpeg";
const productDemoImg6 = "assets/images/cleaning.jpeg";

// End For demo

const grandisExtendedFont = "Grandis Extended";

// On color 80, 60.... those means opacity

const Color primaryColor = Color(0xff04A502);
const SizedBox sizedBox10 = SizedBox(height: 10,);
const SizedBox sizedBox5 = SizedBox(height: 5,);
const SizedBox sizedBox15 = SizedBox(height: 15,);
const SizedBox sizedBox20 = SizedBox(height: 20,);
const SizedBox sizedBox40 = SizedBox(height: 40,);
 SizedBox sizedBoxWidth20 = const SizedBox(width: 20,);
 const SizedBox sizedBoxWidth10 = SizedBox(width: 10,);
const SizedBox sizedBoxWidth30 = SizedBox(width: 30,);

const Color gPrimaryColor = Color(0xff294D9C);
const Color gSecondaryColor = Color(0xFF77246C);
const Color gWhite = Color(0xffffffff);
const Color gBlack = Color(0xFF000000);
const Color gOffBlack = Colors.black26;
const Color gOffWhite = Color(0xffE3E3E3);
const MaterialColor primaryMaterialColor =
    MaterialColor(0xFF20FF76, <int, Color>{
  50: Color.fromARGB(255, 232, 245, 233),
  100: Color.fromARGB(255, 200, 230, 201),
  200: Color.fromARGB(255, 165, 214, 167),
  300: Color.fromARGB(255, 129, 199, 132),
  400: Color.fromARGB(255, 102, 187, 106),
  500: Color.fromARGB(255, 76, 175, 80),
  600: Color.fromARGB(255, 67, 160, 71),
  700: Color.fromARGB(255, 56, 142, 60),
  800: Color.fromARGB(255, 46, 125, 50),
  900: Color.fromARGB(255, 27, 94, 32),
});

const Color blackColor = Color(0xFF16161E);
const Color blackColor80 = Color(0xFF45454B);
const Color blackColor60 = Color(0xFF737378);
const Color blackColor40 = Color(0xFFA2A2A5);
const Color blackColor20 = Color(0xFFD0D0D2);
const Color blackColor10 = Color(0xFFE8E8E9);
const Color blackColor5 = Color(0xFFF3F3F4);

const Color whiteColor = Colors.white;
const Color whileColor80 = Color(0xFFCCCCCC);
const Color whileColor60 = Color(0xFF999999);
const Color whileColor40 = Color(0xFF666666);
const Color whileColor20 = Color(0xFF333333);
const Color whileColor10 = Color(0xFF191919);
const Color whileColor5 = Color(0xFF0D0D0D);

const Color greyColor = Color(0xFFB8B5C3);
const Color lightGreyColor = Color(0xFFF8F8F9);
const Color darkGreyColor = Color(0xFF1C1C25);
// const Color greyColor80 = Color(0xFFC6C4CF);
// const Color greyColor60 = Color(0xFFD4D3DB);
// const Color greyColor40 = Color(0xFFE3E1E7);
// const Color greyColor20 = Color(0xFFF1F0F3);
// const Color greyColor10 = Color(0xFFF8F8F9);
// const Color greyColor5 = Color(0xFFFBFBFC);

const Color purpleColor = Color(0xFF7B61FF);
const Color successColor = Color(0xFF2ED573);
const Color warningColor = Color(0xFFFFBE21);
const Color errorColor = Color(0xFFEA5B5B);

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

 List ListofExperience = [
    "Electronique",
    "Numérique",
    "Banque",
    "Travaux publics",
    "Prestation de service",
    "Influenceur",
    "Hôtellerie",
    "Restauration",
    "Automobile",
    "Agriculture",
    "Alimentaire",
  ];
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: "Mot de passe requis"
  // 'Password is required'
  ),
  MinLengthValidator(8, errorText: 'Le mot de passe doit avoir plus de 8 caractere'
  // 'password must be at least 8 digits long'
  ),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'Le mot de passe doit contenir un caractere special'
      // 'passwords must have at least one special character'
      )
]);

final emaildValidator = MultiValidator([
  RequiredValidator(errorText: 'Email requis'),
  EmailValidator(errorText: "Entrer une addresse email valide"),
]);

const pasNotMatchErrorText = "passwords do not match";

Future<void> showAlertDialog2(
    {required BuildContext context,
    required String title,
    String? body,
    required void Function()? methodYes,
    VoidCallback? methodNo}) {
  // ignore: missing_return
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 24, left: 24, right: 24, bottom: 8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: subtitleStyle(errorColor),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (body != null)
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Center(
                      child: Text(body,
                          // maxLines: 2,
                          textAlign: TextAlign.center,
                          style: bodyStyle( Theme.of(context).textTheme.bodySmall!.color!)),
                    ),
                  ),
                const SizedBox(
                  height: 28,
                ),
                Divider(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            methodNo;
                          },
                          child: Center(
                            child: Text(
                              "Non",
                              style: buttonStyle(primaryColor),
                            ),
                          )),
                      Container(height: 50, width: 1, color: const Color(0xFFE1E1E1)),
                      TextButton(
                          onPressed: methodYes,
                          child: Center(
                            child: Text(
                              "Oui",
                              style: buttonStyle(primaryColor),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}


Future<void> showAlertDialog3(
    {required BuildContext context,
    required String title,
    String? body,
    required void Function()? methodYes,methodNo,
    }) {
  // ignore: missing_return
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 24, left: 24, right: 24, bottom: 8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: subtitleStyle(errorColor),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (body != null)
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Center(
                      child: Text(body,
                          // maxLines: 2,
                          textAlign: TextAlign.center,
                          style: bodyStyle( Theme.of(context).textTheme.bodySmall!.color!)),
                    ),
                  ),
                const SizedBox(
                  height: 28,
                ),
                Divider(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed:
                            methodNo,
                          child: Center(
                            child: Text(
                              "Supprimer de l'historique",
                              style: buttonStyle(errorColor),
                            ),
                          )),
                      Container(height: 2, width: double.infinity, color: const Color(0xFFE1E1E1)),
                      TextButton(
                          onPressed: methodYes,
                          child: Center(
                            child: Text(
                              "Supprimer definitivement",
                              style: buttonStyle(errorColor),
                            ),
                          )),
                           Container(height: 2, width: double.infinity, color: const Color(0xFFE1E1E1)),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              "Annuler",
                              style: buttonStyle(Theme.of(context).textTheme.bodySmall!.color!),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future<void> showAlertDialog(
    {required BuildContext context,
    required String title,
    required String body,
    String button='',
    bool? isError,
    VoidCallback? method}) {
  // ignore: missing_return
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: subtitleStyle((isError != null && isError)
                        ? errorColor
                        :  Theme.of(context).textTheme.bodyMedium!.color!),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    body,
                    // maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color!,
                        fontFamily: 'SignikaNegative',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        inherit: false),
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                Divider(
                  height: 1,
                  color:  Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => 
                                        const LoginScreen()
                                        ),
                                    );
                        method;
                      },
                      child: Text(
                        button.isEmpty?"Ok":button,
                        style: buttonStyle(primaryColor),
                      )),
                ),
              ],
            ),
          ),
        );
      });
}

Future NoAccount(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
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
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(30)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 23),
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
    ),
  );
}
