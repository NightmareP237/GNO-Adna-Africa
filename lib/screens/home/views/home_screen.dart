// screens/home/views/home_screen.dart
// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:adna/components/product/product_card.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/models/product_model.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:adna/components/Banner/L/banner_l_style_1.dart';
import 'package:adna/components/Banner/S/banner_s_style_1.dart';
import 'package:adna/components/Banner/S/banner_s_style_4.dart';
import 'package:adna/components/Banner/S/banner_s_style_5.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/screen_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/best_sellers.dart';
import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  List<Map<String, dynamic>> posts = [];
  List<UserInfoView> users = [];
  AuthServices auth = AuthServices();
  User? user;
  Future<User?> getuser() async {
    return user = await auth.user;
  }

  GetPostsAndUsersData() {
    try {
      setState(() {
        loading = true;
      });
      final db = FirebaseFirestore.instance;
      db.collection("posts").get().then((value) {
        value.docs.forEach((element) {
          posts.add(element.data());
        });
      }).then((value) {
        db.collection("users").get().then((value) {
          value.docs.forEach((element) {
            print(element.data());
            print(element.id);
            UserInfoView.fromDocumentSnapshot(element, element.id)
                .then((value) {
              setState(() {
                print(value.email);
                users.add(value);
                print(users);
              });
            });
          });
          setState(() {
            loading = false;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getuser().then((user) {
      setState(() {
        this.user = user;
      });
      if (user != null) GetPostsAndUsersData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
                SliverToBoxAdapter(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: defaultPadding / 2),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(
                        "Les plus populaires",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    // While loading use 👇
                    // const ProductsSkelton(),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // Find demoPopularProducts on models/ProductModel.dart
                        itemCount: users.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                            left: defaultPadding,
                            right:
                                index == users.length - 1 ? defaultPadding : 0,
                          ),
                          child: PopularAccount(
                            image: users[index].image.isEmpty
                                ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                : users[index].image,
                            brandName: users[index].name,
                            title: users[index].phoneNumber,
                            location: users[index].country,
                            rate: index % 2,
                            // priceAfetDiscount: demoPopularProducts[index].priceAfetDiscount,
                            // dicountpercent: demoPopularProducts[index].dicountpercent,
                            press: () {
                              (FirebaseAuth.instance.currentUser!.displayName ==
                                          null ||
                                      FirebaseAuth.instance.currentUser!
                                          .displayName!.isEmpty)
                                  ? NoAccount(context)
                                  : Navigator.pushNamed(
                                      context, productDetailsScreenRoute,
                                      arguments: index.isEven);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                )),
                // const SliverPadding(
                //   padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
                //   sliver: SliverToBoxAdapter(child: FlashSale()),
                // ),
                // SliverToBoxAdapter(
                //   child: Column(
                //     children: [
                //       // While loading use 👇
                //       // const BannerMSkelton(),‚
                //       BannerSStyle1(
                //         title: "New \narrival",
                //         subtitle: "SPECIAL OFFER",
                //         discountParcent: 50,
                //         press: () {
                //           Navigator.pushNamed(context, onSaleScreenRoute);
                //         },
                //       ),
                //       const SizedBox(height: defaultPadding / 4),
                //       // While loading use 👇
                //       //  const BannerMSkelton(),
                //       BannerSStyle4(
                //         title: "SUMMER \nSALE",
                //         subtitle: "SPECIAL OFFER",
                //         bottomText: "UP TO 80% OFF",
                //         press: () {
                //           Navigator.pushNamed(context, onSaleScreenRoute);
                //         },
                //       ),
                //       const SizedBox(height: defaultPadding / 4),
                //       // While loading use 👇
                //       //  const BannerMSkelton(),
                //       BannerSStyle4(
                //         image: "https://i.imgur.com/dBrsD0M.png",
                //         title: "Black \nfriday",
                //         subtitle: "50% off",
                //         bottomText: "Collection".toUpperCase(),
                //         press: () {
                //           Navigator.pushNamed(context, onSaleScreenRoute);
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                // const SliverToBoxAdapter(child: BestSellers()),
                // const SliverToBoxAdapter(child: MostPopular()),
                // SliverToBoxAdapter(
                //   child: Column(
                //     children: [
                //       const SizedBox(height: defaultPadding * 1.5),
                //       // While loading use 👇
                //       // const BannerLSkelton(),
                //       BannerLStyle1(
                //         title: "Summer \nSale",
                //         subtitle: "SPECIAL OFFER",
                //         discountPercent: 50,
                //         press: () {
                //           Navigator.pushNamed(context, onSaleScreenRoute);
                //         },
                //       ),
                //       const SizedBox(height: defaultPadding / 4),
                //       // While loading use 👇
                //       // const BannerSSkelton(),
                //       BannerSStyle5(
                //         title: "Black \nfriday",
                //         subtitle: "50% Off",
                //         bottomText: "Collection".toUpperCase(),
                //         press: () {
                //           Navigator.pushNamed(context, onSaleScreenRoute);
                //         },
                //       ),
                //       const SizedBox(height: defaultPadding / 4),
                //       // While loading use 👇
                //       // const BannerSSkelton(),
                //       BannerSStyle5(
                //         image: "https://i.imgur.com/2443sJb.png",
                //         title: "Grab \nyours now",
                //         subtitle: "65% Off",
                //         press: () {
                //           Navigator.pushNamed(context, onSaleScreenRoute);
                //         },
                //       ),
                //     ],
                //   ),
                // ),

                SliverToBoxAdapter(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 16,),
                    //  const SizedBox(height: defaultPadding / 2),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(
                        "Nos Publications",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    // Container(
                    //   child: SingleChildScrollView(
                    //     child: Column(
                    //       children: [
                    //         ServiceActu(
                    //
                    //             "",
                    //             "",
                    //             ""),
                    //         ServiceActu(
                    //
                    //             "",
                    //             "",
                    //             ""),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                )),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: defaultPadding,
                      crossAxisSpacing: defaultPadding,
                      childAspectRatio: .9,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ProductCard(
                          press1: () {},
                          press2: () {},
                          asset: false,
                          price: 100,
                          image: posts[index]['image'].toString(),
                          brandName: posts[index]['location']
                                  .toString()
                                  .split(' ')[0] +
                              " " +
                              posts[index]['secteur'].toString(),
                          title: "Aucun",
                          date: "1min , " +
                              posts[index]['location'].toString().split(' ')[1],
                          // priceAfetDiscount:
                          // demoPopularProducts[index].priceAfetDiscount,
                          // dicountpercent: demoPopularProducts[index].dicountpercent,
                          press: () {
                            (FirebaseAuth.instance.currentUser!.displayName == null|| FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
                                ? NoAccount(context)
                                : Navigator.pushNamed(
                                    context, productDetailsScreenRoute);
                          },
                        );
                      },
                      childCount: posts.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (loading) LoadingComponent()
      ],
    );
  }
}
