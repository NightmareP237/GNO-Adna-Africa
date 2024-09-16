// screens/home/views/home_screen.dart
// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/components/product/product_card.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/models/product_model.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/screens/brand/views/components/brand_search_form.dart';
import 'package:adna/screens/user_info/views/account-pro.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/best_sellers.dart';
import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';

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
  int selectIndex = 0;
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
            var value = UserInfoView.fromDocumentSnapshot(element, element.id);
            setState(() {
              print(value.email);
              users.add(value);
              print(users);
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
    // Sample data for tabs
    List<TabData> tabs = [
      TabData(
        index: 1,
        title: const Tab(
          child: Text('Annonces'),
        ),
        content: Scaffold(
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
                      height: 180,
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
                            brandName: users[index].country.split(' ')[0] +
                                " " +
                                users[index].name,

                            rate: index % 2,
                            // priceAfetDiscount: demoPopularProducts[index].priceAfetDiscount,
                            // dicountpercent: demoPopularProducts[index].dicountpercent,
                            press: () {
                              (FirebaseAuth.instance.currentUser!.displayName ==
                                          null ||
                                      FirebaseAuth.instance.currentUser!
                                          .displayName!.isEmpty)
                                  ? NoAccount(context)
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ProfileBaseScreen(
                                              userInfo: users[index],
                                              postUserPro: posts
                                                  .where((element) =>
                                                      element['uid'] ==
                                                      users[index].uid)
                                                  .toList())));
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
                      crossAxisSpacing: defaultPadding / 3,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            (FirebaseAuth.instance.currentUser!.displayName ==
                                        null ||
                                    FirebaseAuth.instance.currentUser!
                                        .displayName!.isEmpty)
                                ? NoAccount(context)
                                : Navigator.pushNamed(
                                    context, productDetailsScreenRoute);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                // color: Colors.grey,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: .5,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!)),

                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // _createPhotoTitle(),
                                    Stack(
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                9,
                                            child: Image.network(
                                                posts[index]['image']
                                                    .toString(),
                                                fit: BoxFit.fitWidth)),
                                        _createActionBar(),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        posts[index]['description'],
                                        style: footnoteStyle(
                                          Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .color!,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      height: 30,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          posts[index]['location']
                                                  .toString()
                                                  .split(' ')[0] +
                                              " Postuler a l'offre",
                                          style: footboldStyle(lightGreyColor),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
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
      ),
      TabData(
        index: 2,
        title: const Tab(
          child: Text('Market place'),
        ),
        content: Scaffold(
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
                                           ...kidsProducts.map((product) => 
                                           CardofProduct(() {
                                           },product.image,product.brandName,product.title,product.price) )
                        .toList()
                        ]),
                     )
                  ])),
    )
      ),
      TabData(
        index: 3,
        title: const Tab(
          child: Text('Annuaire'),
        ),
        content: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.map,
                size: 40,
              ),
              Text("Aucune donnee pour l'instant...")
            ],
          ),
        ),
      )
      // Add more tabs as needed
    ];
    
    return Stack(
      children: [
        DynamicTabBarWidget(
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          dynamicTabs: tabs,
          // optional properties :-----------------------------
          isScrollable: false,
          onTabControllerUpdated: (controller) {
            debugPrint("onTabControllerUpdated");
          },
          onTabChanged: (index) {
            debugPrint("Tab changed: $index");
          },
          onAddTabMoveTo: MoveToTab.last,
          // backIcon: Icon(Icons.keyboard_double_arrow_left),
          // nextIcon: Icon(Icons.keyboard_double_arrow_right),
          showBackIcon: false,
          showNextIcon: false,
          // leading: leading,
          // trailing: trailing,
        ),
        if (loading) LoadingComponent()
      ],
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

Widget _createActionBar() => Container(
      padding:
          EdgeInsets.symmetric(vertical: 10.0, horizontal: defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Icon(
                size: 20,
                Icons.favorite_border,
              ),
            ),
          ),
          // Icon(
          //   Icons.chat_bubble_outline_outlined,
          //   color: Colors.black,
          // ),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Icon(
                size: 20,
                Icons.ios_share_rounded,
              ),
            ),
          ),
        ],
      ),
    );
