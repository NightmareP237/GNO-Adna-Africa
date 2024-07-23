// screens/checkout/views/cart_screen.dart
import 'package:adna/components/product/product_card.dart';
import 'package:adna/database/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:adna/components/product/secondary_product_card.dart';
import 'package:adna/models/product_model.dart';
import 'package:adna/route/screen_export.dart';
import 'package:adna/screens/order/views/components/order_summary_card.dart';

import '../../../constants.dart';
import 'components/coupon_code.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
            Text("Messagerie",style: bodyBoldStyle(Colors.black),),
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
    ): Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                "Review your order",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            // While loading use 👇
            // const ReviewYourItemsSkelton(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: SecondaryProductCard(
                      image: demoPopularProducts[index].image,
                      brandName: demoPopularProducts[index].brandName,
                      title: demoPopularProducts[index].title,
                      price: demoPopularProducts[index].price,
                      // priceAfetDiscount:
                      //     demoPopularProducts[index].priceAfetDiscount,
                      style: ElevatedButton.styleFrom(
                        maximumSize: const Size(double.infinity, 80),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  childCount: 3,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: CouponCode(),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(
                child: OrderSummaryCard(
                  subTotal: 169.0,
                  discount: 10,
                  totalWithVat: 185,
                  vat: 5,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              sliver: SliverToBoxAdapter(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, paymentMethodScreenRoute);
                  },
                  child: const Text("Continue"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
