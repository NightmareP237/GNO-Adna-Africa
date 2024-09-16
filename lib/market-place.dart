// market-place.dart
import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/components/product/product_card.dart';
import 'package:adna/constants.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/models/product_model.dart';
import 'package:adna/route/route_constants.dart';
import 'package:adna/screens/brand/views/components/brand_search_form.dart';
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
    getuser().then((user) {
      setState(() {
        this.user = user;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (FirebaseAuth.instance.currentUser!.displayName == null ||
              FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
          ? Container(
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
                    Text(
                      "Mes Favories",
                      style: bodyBoldStyle(Colors.black),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 23),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Market place',
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
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: defaultPadding / 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultPadding / 2,
                          horizontal: defaultPadding ),
                      child: BrandSearchForm(),
                    ),
                    // sizedBox5,
                     Expanded(
                       child: GridView.count(
                        padding: EdgeInsets.all(defaultPadding),
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                                         crossAxisCount: 2,
                                           semanticChildCount: kidsProducts.length,
                                         children: [
                                           ...kidsProducts.map((product) => CardofProduct(() {
                                             
                                           },product.image,product.brandName,product.title,product.price) )
                        .toList()
                        ]),
                     )
                  ])),
    );
  }
  Widget CardofProduct(VoidCallback press,String image,brandName,title,price)=>OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
        // fixedSize: const Size(140, 150),
        padding: const EdgeInsets.all(8),
      ),
      child: Column(
        children: [
          NetworkImageWithLoader(image, radius: defaultBorderRadious),
          IntrinsicHeight(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: defaultPadding / 1.2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (brandName.toUpperCase()).length >= 40
                            ? (brandName.toUpperCase()).substring(0, 30) + "..."
                            : (brandName.toUpperCase()),
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 10),
                      ),
                       Text(
                       price.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 12),
                  ),
                 
                ],
              ),
            ),
          ),
        ],
      ),
    );
}
