// screens/home/views/home_screen.dart
// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/components/product/product_card.dart';
import 'package:adna/components/skleton/skelton.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/models/posts_model.dart';
import 'package:adna/models/product_model.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/screens/brand/views/components/brand_search_form.dart';
import 'package:adna/screens/home/views/post_detail_page.dart';
import 'package:adna/screens/user_info/views/account-pro.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  List<PostModel> posts = [];
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
      db.collection("users").get().then((value) {
        for (var element in value.docs) {
          print(element.data());
          print(element.id);
          var value = UserInfoView.fromDocumentSnapshot(element, element.id);
          setState(() {
            print(value.email);
            users.add(value);
            print(users);
          });
        }
        setState(() {
          loading = false;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  int selectedIndex = 0;

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

  List listofannuaire = [
    "Emploi",
    "Lieu",
    "Tourisme",
    "Entreprise",
    "Voyages",
    "Finances",
    "Communication",
    "Leadership",
  ];
  List listofjob = [
    {
      "image": "assets/images/liquid.png",
      "name": "Liquid Telecom (Afrique du Sud)",
      "description":
          "Fournisseur de services de télécommunications et de solutions ",
      "date": "1 semaine"
    },
    {
      "image": "assets/images/vadophone.png",
      "name": "Vodacom (Afrique du Sud)",
      "description":
          "Fournisseur de services de télécommunications et de solutions numériques.",
      "date": "1 semaine"
    },
    {
      "image": "assets/images/glo-mobile.png",
      "name": "Glo Mobile (Nigeria)",
      "description":
          "Fournisseur de services de télécommunications avec des solutions numériques.",
      "date": "1 semaine"
    },
    {
      "image": "assets/images/paystack.png",
      "name": "Paystack (Nigeria)",
      "description": "Solutions de paiement en ligne pour les entreprises.",
      "date": "2 semaines"
    },
    {
      "image": "assets/images/china.png",
      "name": "China Civil Engineering Construction",
      "description": "",
      "date": "2 semaines"
    },
    {
      "image": "assets/images/dangote.png",
      "name": "Dangote ciment (Nigeria)",
      "description":
          "Fournisseur de services de construction et des solutions numériques.",
      "date": "2 semaines"
    }
  ];
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: const Column(
            children: <Widget>[
              Text(
                'Modal Bottom Sheet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('This is a modal bottom sheet.'),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
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
          body: StreamBuilder<QuerySnapshot>(
            // Stream to listen to Firestore collection
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for data, show a loading spinner
                return const Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ));
              } else if (snapshot.hasError) {
                // If there is an error, display it
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                // If no data, display a message
                return const Center(child: Text('Aucun post disponible...'));
              } else {
                // If data is available, display it
                posts = PostModel.PostListModel(snapshot.data!);
                return SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                          child: OffersCarouselAndCategories()),
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
                                  right: index == users.length - 1
                                      ? defaultPadding
                                      : 0,
                                ),
                                child: PopularAccount(
                                  image: users[index].image,
                                  brandName:
                                      "${users[index].country.split(' ')[0]} ${users[index].name}",
                                  rate: index % 2,
                                  // priceAfetDiscount: demoPopularProducts[index].priceAfetDiscount,
                                  // dicountpercent: demoPopularProducts[index].dicountpercent,
                                  press: () {
                                    (FirebaseAuth.instance.currentUser!
                                                    .displayName ==
                                                null ||
                                            FirebaseAuth.instance.currentUser!
                                                .displayName!.isEmpty)
                                        ? NoAccount(context)
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ProfileBaseScreen(
                                                        userInfo: users[index],
                                                        postUserPro: posts
                                                            .where((element) =>
                                                                element.uid ==
                                                                users[index]
                                                                    .uid)
                                                            .toList())));
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
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
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var post in posts)
                                  GestureDetector(
                                    onTap: () {
                                      (FirebaseAuth.instance.currentUser!
                                                      .displayName ==
                                                  null ||
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .displayName!
                                                  .isEmpty)
                                          ? NoAccount(context)
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    PostDetailPage(
                                                  PostDetail: post,
                                                ),
                                              ),
                                            );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                          defaultPadding),
                                      margin: const EdgeInsets.only(
                                          left: defaultPadding,
                                          right: defaultPadding,
                                          bottom: defaultPadding),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              defaultBorderRadious),
                                          border: Border.all(
                                              width: 2, color: Colors.black)),
                                      child: Column(
                                        children: [
                                          IntrinsicHeight(
                                            child: Container(
                                              width: double.infinity,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 60,
                                                            height: 60,
                                                            decoration:
                                                                const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: post
                                                                    .urlOwnerName
                                                                    .isEmpty
                                                                ? Image.asset(
                                                                    'assets/images/user-flat.png')
                                                                : NetworkImageWithLoader(
                                                                    post.urlOwnerName),
                                                          ),
                                                          const SizedBox(
                                                            width:
                                                                defaultPadding /
                                                                    2,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                post.postOwnerName,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium,
                                                              ),
                                                              Text(post
                                                                  .location),
                                                              Row(
                                                                children: [
                                                                  const Text(
                                                                      'Depuis 4jrs. '),
                                                                  SvgPicture
                                                                      .asset(
                                                                          'assets/icons/fluent.svg')
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      PopupMenuButton<String>(
                                                        color: Colors.white,
                                                        onSelected:
                                                            (String result) {
                                                          // Handle the selected menu item
                                                          if (result ==
                                                              'Option 0') {
                                                            _showModalBottomSheet(
                                                                context);
                                                          }
                                                          print(
                                                              'Selected: $result');
                                                        },
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry<
                                                                    String>>[
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Option 0',
                                                            child: Text(
                                                                'Contacter l\'annonceur'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Option 1',
                                                            child: Text(
                                                                'Ajouter au favoris'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Option 2',
                                                            child: Text(
                                                                'Copier le lien du post'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Option 3',
                                                            child: Text(
                                                                'A propos de ce profil'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  sizedBox10,
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 40,
                                                    child: AutoSizeText(
                                                      post.description,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Colors
                                                                  .black),
                                                      minFontSize: 14,
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                  sizedBox10,
                                                ],
                                              ),
                                            ),
                                          ),
                                          StaggeredGrid.count(
                                            crossAxisCount: 4,
                                            mainAxisSpacing: 4,
                                            crossAxisSpacing: 4,
                                            children: [
                                              if (post.imagePost.length == 1)
                                                StaggeredGridTile.count(
                                                  crossAxisCellCount: 4,
                                                  mainAxisCellCount: 3,
                                                  child: Expanded(
                                                      child: Container(
                                                    child:
                                                        NetworkImageWithLoader(
                                                            post.imagePost[
                                                                0]),
                                                  )),
                                                ),
                                              if (post.imagePost.length == 2)
                                                ...List.generate(
                                                    post.imagePost.length,
                                                    (index) =>
                                                        StaggeredGridTile
                                                            .count(
                                                          crossAxisCellCount:
                                                              2,
                                                          mainAxisCellCount:
                                                              3,
                                                          child: Expanded(
                                                              child:
                                                                  Container(
                                                            child: NetworkImageWithLoader(
                                                                post.imagePost[
                                                                    index]),
                                                          )),
                                                        )),
                                              if (post.imagePost.length >= 3)
                                                ...List.generate(
                                                  3,
                                                  (index) {
                                                    final imageIndex =
                                                        index % 3;
                                                    return StaggeredGridTile
                                                        .count(
                                                      crossAxisCellCount: 2,
                                                      mainAxisCellCount:
                                                          imageIndex == 0
                                                              ? 3
                                                              : 1.5,
                                                      child:
                                                          NetworkImageWithLoader(
                                                              post.imagePost[
                                                                  index]),
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                          sizedBox10,
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal:
                                                        defaultPadding),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/hero-flag.svg',
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      post.like.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text(
                                                      '${post.comment.toString()} ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    Text(
                                                      'Commentaires',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    sizedBoxWidth20,
                                                    Text(
                                                      '${post.share.toString()} ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    Text(
                                                      'Partages',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          sizedBox10,
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .08),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      if (!post.favorites
                                                          .contains(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)) {
                                                        addLikePost(post.postId);
                                                        addFavoriteUser(
                                                            post.postId,
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid);
                                                      } else {
                                                        removeLikePost(
                                                            post.postId);
                                                        removeFavoriteUser(
                                                            post.postId,
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid);
                                                      }
                                                    },
                                                    child: SvgPicture.asset(
                                                      'assets/icons/like-blue.svg',
                                                      color: post.favorites
                                                              .contains(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                          ? primaryColor
                                                          : Colors.black,
                                                    )),
                                                SvgPicture.asset(
                                                    'assets/icons/commentaire.svg'),
                                                SvgPicture.asset(
                                                    'assets/icons/share-plus.svg')
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      )),
                      // SliverPadding(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: defaultPadding,
                      //   ),
                      //   sliver:

                      // SliverGrid(
                      //   gridDelegate:
                      //       const SliverGridDelegateWithMaxCrossAxisExtent(
                      //     maxCrossAxisExtent: 200.0,
                      //     mainAxisSpacing: defaultPadding,
                      //     crossAxisSpacing: defaultPadding / 3,
                      //     childAspectRatio: 1,
                      //   ),
                      //   delegate: SliverChildBuilderDelegate(
                      //     (BuildContext context, int index) {
                      //       return InkWell(
                      //
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(horizontal: 16.0),
                      //           child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(16.0),
                      //             child: Container(
                      //               // color: Colors.grey,
                      //               decoration: BoxDecoration(
                      //                   border: Border.all(
                      //                       width: .5,
                      //                       color: Theme.of(context)
                      //                           .textTheme
                      //                           .bodyLarge!
                      //                           .color!),
                      //                           ),
                      //               child: Column(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceBetween,
                      //                 children: [
                      //                   // _createPhotoTitle(),
                      //                   Stack(
                      //                     children: [
                      //                       Container(
                      //                           width: double.infinity,
                      //                           height: MediaQuery.of(context)
                      //                                   .size
                      //                                   .height /
                      //                               9,
                      //                           child: Image.network(
                      //                               posts[index]['image']
                      //                                   .toString(),
                      //                               fit: BoxFit.fitWidth)),
                      //                       _createActionBar(),
                      //                     ],
                      //                   ),
                      //                   Padding(
                      //                     padding: const EdgeInsets.all(2.0),
                      //                     child: Text(
                      //                       maxLines: 2,
                      //                       textAlign: TextAlign.center,
                      //                       posts[index]['description'],
                      //                       style: footnoteStyle(
                      //                         Theme.of(context)
                      //                             .textTheme
                      //                             .labelLarge!
                      //                             .color!,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   SizedBox(
                      //                     height: 4,
                      //                   ),
                      //                   Container(
                      //                     height: 30,
                      //                     width: double.infinity,
                      //                     decoration: BoxDecoration(
                      //                       color: primaryColor,
                      //                       borderRadius:
                      //                           BorderRadius.circular(4.0),
                      //                     ),
                      //                     child: Center(
                      //                       child: Text(
                      //                         posts[index]['location']
                      //                                 .toString()
                      //                                 .split(' ')[0] +
                      //                             " Postuler a l'offre",
                      //                         style: footboldStyle(lightGreyColor),
                      //                       ),
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //     childCount: posts.length,
                      //   ),
                      // ),
                      //     ),
                    ],
                  ),
                );
              }
            },
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
                                style: linkStyle(Colors.black),
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
                  )
                : SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: defaultPadding / 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding / 2,
                                  horizontal: defaultPadding),
                              child: const BrandSearchForm(),
                            ),
                            // sizedBox5,
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(colors: [
                                    Color(0xff4BDA4A),
                                    Color(0xff04A502)
                                  ])),
                              margin: const EdgeInsets.symmetric(
                                  // vertical: defaultPadding / 2,
                                  horizontal: defaultPadding),
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding / 2,
                                  horizontal: defaultPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Les meilleurs produits",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                          ),
                                          const Text(
                                            "De l'Afrique vers le monde et du monde vers l'Afrique",
                                            selectionColor: Colors.white,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                18,
                                          ),
                                          Container(
                                            width: 150,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Explorer maintenant",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          sizedBox5,
                                          Text(
                                            "Votre espace de ventes.",
                                            selectionColor: Colors.white,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 4),
                                    child:
                                        Image.asset("assets/images/image.png"),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 16, bottom: 8),
                              child: Text(
                                "Selection du jour",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                              ),
                            ),
                            Wrap(
                                // padding: EdgeInsets.all(defaultPadding),
                                // mainAxisSpacing: defaultPadding/2,
                                // crossAxisSpacing: defaultPadding/2,
                                // crossAxisCount: 2,
                                // semanticChildCount: kidsProducts.length,
                                children: [
                                  ...kidsProducts.map((product) =>
                                      CardofProduct(
                                          () {},
                                          product.image,
                                          product.brandName,
                                          product.title,
                                          product.price))
                                ])
                          ]),
                    )),
          )),
      TabData(
        index: 3,
        title: const Tab(
          child: Text('Annuaire'),
        ),
        content: SafeArea(
          child:
              (FirebaseAuth.instance.currentUser!.displayName == null ||
                      FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 40,
                        ),
                        Text("Aucune donnee pour l'instant...")
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding / 2,
                            horizontal: defaultPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Categories populaires",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                            ),
                            sizedBox5,
                            Wrap(
                                runSpacing: 8,
                                spacing: 8,
                                children: List.generate(
                                    listofannuaire.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                            print(selectIndex);
                                          },
                                          child: Container(
                                            width: 120,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    width:
                                                        selectedIndex == index
                                                            ? 2
                                                            : 1,
                                                    color:
                                                        selectedIndex == index
                                                            ? primaryColor
                                                            : Colors.black)),
                                            child: Center(
                                              child: Text(listofannuaire[index],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: selectedIndex ==
                                                                index
                                                            ? primaryColor
                                                            : Colors.black,
                                                      )),
                                            ),
                                          ),
                                        ))),
                            sizedBox20,
                            Text(
                              "Le meilleure pour vous !",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                            ),
                            // sizedBox20,
                            selectedIndex != 0
                                ? Expanded(
                                    child: SizedBox(
                                    width: double.infinity,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.map,
                                          size: 40,
                                        ),
                                        Text(
                                          "Aucune donnee pour l'instant...",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        )
                                      ],
                                    ),
                                  ))
                                : Expanded(
                                    child: SizedBox(
                                        // margin: EdgeInsets.all(4),
                                        // padding: EdgeInsets.all(4),
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          child: Column(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              children: List.generate(
                                                  listofjob.length,
                                                  (index) => Card.filled(
                                                        child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 100,
                                                            // decoration: BoxDecoration(border: Border.all(width: 1)),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  listofjob[
                                                                          index]
                                                                      ['image'],
                                                                  width: 100,
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        listofjob[index]
                                                                            [
                                                                            'name'],
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleMedium),
                                                                    Text(
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        listofjob[index]
                                                                            [
                                                                            'description'],
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .labelMedium),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            "Vue par 17 personnes",
                                                                            style:
                                                                                Theme.of(context).textTheme.labelMedium),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 16),
                                                                          child: Text(
                                                                              listofjob[index]['date'],
                                                                              style: Theme.of(context).textTheme.labelLarge),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ))
                                                              ],
                                                            )),
                                                      ))),
                                        )))
                          ],
                        ),
                      ),
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

  Widget CardofProduct(
          VoidCallback press, String image, brandName, title, price) =>
      OutlinedButton(
        onPressed: press,
        style: OutlinedButton.styleFrom(
          // fixedSize: const Size(140, 150),
          padding: const EdgeInsets.all(8),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                cacheKey: image,
                // width: isprofil?60:null,
                height: 180,
                fit: BoxFit.cover,
                imageUrl: image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const Skeleton(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            IntrinsicHeight(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: defaultPadding / 1.2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (brandName.toUpperCase()).length >= 40
                              ? (brandName.toUpperCase()).substring(0, 30) +
                                  "..."
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
      padding: const EdgeInsets.symmetric(
          vertical: 10.0, horizontal: defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Center(
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
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Center(
              child: Icon(
                size: 20,
                Icons.ios_share_rounded,
              ),
            ),
          ),
        ],
      ),
    );
