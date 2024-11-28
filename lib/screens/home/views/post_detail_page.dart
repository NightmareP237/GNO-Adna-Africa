// screens/home/views/post_detail_page.dart
import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/constants.dart';
import 'package:adna/database/Firebase.dart';
import 'package:adna/models/comment_model.dart';
import 'package:adna/models/posts_model.dart';
import 'package:adna/screens/product/views/components/product_images.dart';
import 'package:adna/theme/input_decoration_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeline_tile/timeline_tile.dart';

class PostDetailPage extends StatefulWidget {
  PostDetailPage({super.key, required this.PostDetail});
  PostModel PostDetail;
  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

final ScrollController _scrollController = ScrollController();
final editcontroller = TextEditingController();
final focus = FocusNode();

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    var post = widget.PostDetail;
    _scrollController.addListener(() {});
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                floating: true,
                actions: [
                  PopupMenuButton<String>(
                    color: Colors.white,
                    onSelected: (String result) {
                      // Handle the selected menu item
                      if (result == 'Option 0') {
                        // _showModalBottomSheet(
                        //     context);
                      }
                      print('Selected: $result');
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Option 0',
                        child: Text('Contacter l\'annonceur'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Option 1',
                        child: Text('Ajouter au favoris'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Option 2',
                        child: Text('Copier le lien du post'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Option 3',
                        child: Text('A propos de ce profil'),
                      ),
                    ],
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: SvgPicture.asset('assets/icons/more-fill.svg',
                  //       color: Theme.of(context).textTheme.bodyLarge!.color),
                  // ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 1.25,
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      margin: const EdgeInsets.only(
                        left: defaultPadding,
                        right: defaultPadding,
                      ),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: post.urlOwnerName.isEmpty
                                                ? Image.asset(
                                                    'assets/images/user-flat.png')
                                                : NetworkImageWithLoader(
                                                    post.urlOwnerName),
                                          ),
                                          const SizedBox(
                                            width: defaultPadding / 2,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post.postOwnerName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              Text(post.location),
                                              Row(
                                                children: [
                                                  const Text('Depuis 4jrs. '),
                                                  SvgPicture.asset(
                                                      'assets/icons/fluent.svg')
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      // SvgPicture.asset(
                                      // 'assets/icons/share-plus.svg')
                                      GestureDetector(
                                        onTap: () {
                                          if (!post.favorites.contains(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)) {
                                            addLikePost(post.postId);
                                            addFavoriteUser(
                                                post.postId,
                                                FirebaseAuth
                                                    .instance.currentUser!.uid);
                                          } else {
                                            removeLikePost(post.postId);
                                            removeFavoriteUser(
                                                post.postId,
                                                FirebaseAuth
                                                    .instance.currentUser!.uid);
                                          }
                                        },
                                        child: Container(
                                            width: 90,
                                            height: 40,
                                            padding: const EdgeInsets.all(
                                                defaultPadding / 2),
                                            decoration: BoxDecoration(
                                                color: (post.favorites.contains(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid))
                                                    ? Colors.white
                                                    : successColor,
                                                border: Border.all(
                                                    color: successColor),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        defaultBorderRadious)),
                                            child: Center(
                                              child: Text(
                                                (post.favorites.contains(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid))
                                                    ? "Abonné"
                                                    : "S'Abonner",
                                                style: TextStyle(
                                                    color: (post.favorites
                                                            .contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid))
                                                        ? successColor
                                                        : Colors.white),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                  sizedBox10,
                                  Text(
                                    post.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.black),
                                  ),
                                  sizedBox10,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Afficher la suite',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Scaffold(
                                      appBar: AppBar(
                                        title: Text(
                                          'Posts',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color),
                                        ),
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                      ),
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      body: Column(
                                        children: [
                                          ProductImages(
                                            images: post.imagePost,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(
                                                defaultPadding),
                                            child: Column(
                                              children: [
                                                Container(
                                                    width: double.infinity,
                                                    height: 45,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            defaultPadding / 2),
                                                    decoration: BoxDecoration(
                                                        color: successColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                defaultBorderRadious)),
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.call,
                                                          color: Colors.white,
                                                        ),
                                                        sizedBoxWidth10,
                                                        Text(
                                                          'Contacter l\'annonceur',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    )),
                                                sizedBox15,
                                                Container(
                                                  width: double.infinity,
                                                  height: 45,
                                                  padding: const EdgeInsets.all(
                                                      defaultPadding / 2),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              defaultBorderRadious)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.call_made,
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                      ),
                                                      sizedBoxWidth10,
                                                      Text(
                                                        'A propos de ce profil',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                            child: StaggeredGrid.count(
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
                                      child: NetworkImageWithLoader(
                                          post.imagePost[0]),
                                    )),
                                  ),
                                if (post.imagePost.length == 2)
                                  ...List.generate(
                                      post.imagePost.length,
                                      (index) => StaggeredGridTile.count(
                                            crossAxisCellCount: 2,
                                            mainAxisCellCount: 3,
                                            child: Expanded(
                                                child: Container(
                                              child: NetworkImageWithLoader(
                                                  post.imagePost[index]),
                                            )),
                                          )),
                                if (post.imagePost.length >= 3)
                                  ...List.generate(
                                    3,
                                    (index) {
                                      final imageIndex = index % 3;
                                      return StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount:
                                            imageIndex == 0 ? 3 : 1.5,
                                        child: NetworkImageWithLoader(
                                            post.imagePost[index]),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          (post.imagePost.length > 3)
                              ? sizedBox10
                              : const SizedBox(),
                          if (post.imagePost.length > 3)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Scaffold(
                                        body: ProductImages(
                                          images:
                                              post.imagePost as List<String>,
                                        ),
                                      ),
                                    ));
                              },
                              child: const Text('Voir plus'),
                            ),
                          sizedBox10,
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                              fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${post.comment.toString()} ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Commentaires',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                    ),
                                    sizedBoxWidth30,
                                    Text(
                                      '${post.share.toString()} ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Partages',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Divider(),
                          Expanded(
                              child: SizedBox(
                                  width: double.infinity,
                                  // color: Colors.amber,
                                  child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          for (var i = 0; i <= 1; i++)
                                            Column(
                                              children: [
                                                Card.outlined(
                                                    child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                          defaultPadding,
                                                      vertical:
                                                          defaultPadding / 2),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'assets/images/simple.jpeg'),
                                                      ),

                                                      sizedBoxWidth10, // Add some space between the image and text
                                                      Expanded(
                                                          child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            textAlign: TextAlign
                                                                .justify,
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .displayName!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                          ),
                                                          Text(
                                                            textAlign: TextAlign
                                                                .justify,
                                                            'Super tres belle offre ou etes vous cituez et comment fait-on pour vous joindre ?',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Card.filled(
                                                                    child: Container(
                                                                        padding: const EdgeInsets.all(2),
                                                                        width: 60,
                                                                        height: 30,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                                          const Icon(
                                                                            Icons.thumb_up,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                          Text(
                                                                            "0",
                                                                            style:
                                                                                Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w800),
                                                                          ),
                                                                        ])),
                                                                  ),
                                                                  Card.filled(
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              2),
                                                                      width: 60,
                                                                      height:
                                                                          30,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Text(
                                                                            "0",
                                                                            style:
                                                                                Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w800),
                                                                          ),
                                                                          const Icon(
                                                                            Icons.thumb_down,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            focus);
                                                                  },
                                                                  child: const Text(
                                                                      "Repondre")),
                                                            ],
                                                          ),
                                                          sizedBox5,
                                                          for (var i = 0;
                                                              i <= 1;
                                                              i++)
                                                            TimelineTile(
                                                              // isFirst: true,
                                                              isLast: true,
                                                              indicatorStyle:
                                                                  const IndicatorStyle(
                                                                height: 40,
                                                                width: 40,
                                                                indicator:
                                                                    CircleAvatar(
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          'assets/images/simple.jpeg'),
                                                                ),
                                                              ),
                                                              alignment:
                                                                  TimelineAlign
                                                                      .start,
                                                              lineXY: 0,
                                                              endChild:
                                                                  Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        defaultPadding /
                                                                            2),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // Add some space between the image and text
                                                                    //  sizedBox5,
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                          FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .displayName!,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .titleSmall!
                                                                              .copyWith(fontSize: 14, fontWeight: FontWeight.w800),
                                                                        ),
                                                                        Text(
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                          'Super tres belle offre ou etes vous cituez et comment fait-on pour vous joindre ?',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodySmall!
                                                                              .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                        ],
                                                      )),
                                                    ],
                                                  ),
                                                )),
                                              ],
                                            )
                                        ]),
                                  )))
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding / 2),
                          child: Form(
                            child: TextFormField(
                              focusNode: focus,
                              onTap: () {
                                _scrollController.animateTo(
                                    curve: Curves.easeIn,
                                    duration: const Duration(microseconds: 700),
                                    _scrollController.position.maxScrollExtent);
                              },
                              controller: editcontroller,
                              validator: (value) {
                                setState(() {
                                  editcontroller.text = value!;
                                });
                                return value!;
                              },
                              onChanged: (value) {
                                setState(() {
                                  editcontroller.text = value;
                                });
                              },
                              decoration: InputDecoration(
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (editcontroller.text
                                          .trim()
                                          .isNotEmpty) {
                                        SendNotification(
                                            FirebaseAuth.instance.currentUser!
                                                .displayName
                                                .toString(),
                                            'Nouveau Message',
                                            post.fcmToken.toString(),
                                            (FirebaseAuth.instance.currentUser!
                                                            .photoURL ==
                                                        null ||
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .photoURL!
                                                        .isEmpty)
                                                ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                                : FirebaseAuth.instance
                                                    .currentUser!.photoURL!);
                                        var comment = CommentModel(
                                            timestamp: DateTime.now()
                                                .microsecondsSinceEpoch,
                                            commentCount: 0,
                                            dislike: 0,
                                            displayName: FirebaseAuth.instance
                                                .currentUser!.displayName!,
                                            imagePost: [],
                                            like: 0,
                                            message: editcontroller.text.trim(),
                                            photoURL: (FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .photoURL ==
                                                        null ||
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .photoURL!
                                                        .isEmpty)
                                                ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                                : FirebaseAuth.instance
                                                    .currentUser!.photoURL!);
                                        addUserComment(
                                            post.postId, comment.toMap());
                                        setState(() {
                                          editcontroller.clear();
                                        });
                                      }
                                    },
                                    child: Container(
                                        width: 40,
                                        height: 40,
                                        padding: const EdgeInsets.all(
                                            defaultPadding / 2),
                                        decoration: BoxDecoration(
                                            color: editcontroller.text.isEmpty
                                                ? Colors.grey
                                                : successColor,
                                            borderRadius: BorderRadius.circular(
                                                defaultBorderRadious)),
                                        child: Center(
                                            child: SvgPicture.asset(
                                          'assets/icons/Send.svg',
                                          color: Colors.white,
                                        ))),
                                  ),
                                ),
                                filled: false,
                                hintText: "Partager votre opinion ici...",
                                border: secodaryOutlineInputBorder(context),
                                enabledBorder:
                                    secodaryOutlineInputBorder(context),
                                focusedBorder: focusedOutlineInputBorder,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
