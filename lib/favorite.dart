// favorite.dart
import 'package:adna/components/product/product_card.dart';
import 'package:adna/constants.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/route/route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  AuthServices auth = AuthServices();
  User? user;
  Future<User?> getuser() async {
    return user = await auth.user;
  }
   @override
  void initState() {
    // TODO: implement initState
    getuser().then((user){
      setState(() {
        this.user = user;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:(  FirebaseAuth
                                          .instance.currentUser!.displayName ==
                                      null|| FirebaseAuth
                                          .instance.currentUser!.displayName!.isEmpty)?
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
          children: [
            Text("Mes Favories",style: bodyBoldStyle(Colors.black),),
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
            SizedBox(
              height: 16,
            ),
            ButtonCard1(
                label: 'S\'inscrire',
                isOutline: false,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, signUpScreenRoute);
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
    ):
      Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding/2,horizontal: defaultPadding*2),
          child: Text(
            "Mes posts favories",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Expanded(child: Container(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[ Icon(Icons.now_widgets_sharp,size: 80,color: primaryColor.withOpacity(.5),),
               Text(
            "Aucun post favoris pour le moment !",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.w500
            ),
          ),
              ]
            ),
          ),
        ))
          ],
        ),
      ),
    );
  }
}