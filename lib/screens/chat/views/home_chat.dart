// screens/chat/views/home_chat.dart
import 'package:adna/components/chat_active_dot.dart';
import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/components/product/product_card.dart';
import 'package:adna/constants.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/route/route_constants.dart';
import 'package:adna/screens/chat/views/chat_page.dart';
import 'package:adna/screens/chat/views/chat_screen.dart';
import 'package:adna/screens/chat/views/components/support_person_info.dart';
import 'package:adna/screens/chat/views/new_chat.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  AuthServices auth = AuthServices();
  User? user;
  Future<User?> getuser() async {
    return user = await auth.user;
  }

  @override
  void initState() {
    // TODO: implement initState
    (FirebaseAuth.instance.currentUser!.displayName == null ||
            FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
        ? null
        : GetUsersConnected();
    getuser().then((user) {
      setState(() {
        this.user = user;
      });
    });
    super.initState();
  }

  @override
  bool loading = false;
  List<UserInfoView> users = [];
  GetUsersConnected() {
    try {
      setState(() {
        loading = true;
      });
      final db = FirebaseFirestore.instance;
      db.collection("users").get().then((value) {
        value.docs.forEach((element) {
          print(element.data());
          print(element.id);
          UserInfoView.fromDocumentSnapshot(element, element.id).then((value) {
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

// late Stream<DocumentSnapshot<Map<String, dynamic>>> personnalData =
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                          "Messagerie",
                          style: bodyBoldStyle(Colors.black),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 23),
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
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('contacts')
                      .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                      .collection("me")
                      // .doc("ZQgE7nhtDVf0qCaYLWHU8WZ0kWg2")
                      // .collection("messages")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: LoadingComponent());
                    }

                    return Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Profil connecte",
                                  style: Theme.of(context).textTheme.bodyLarge),
                              GestureDetector(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  "assets/icons/info.svg",
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: users.length,
                              itemBuilder: (context, index) =>
                                  (users[index].image.isEmpty ||
                                          users[index].uid.contains(FirebaseAuth
                                              .instance.currentUser!.uid))
                                      ? SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen(
                                                          user: users[index],
                                                        )));
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: CircleAvatar(
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      NetworkImageWithLoader(
                                                        users[index].image,
                                                        radius: 60,
                                                      ),
                                                      const Positioned(
                                                        right: -4,
                                                        top: -4,
                                                        child: ChatActiveDot(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                users[index].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            ],
                                          ),
                                        ),
                            ),
                          ),
                          SizedBox(
                            height: defaultPadding,
                          ),
                          Expanded(
                            child: SizedBox(
                              child: ListView(
                                children: [
                                  Text(
                                    "Mes messages",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(
                                    height: defaultPadding / 2,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: const SupportPersonInfo(
                                      image: "https://i.imgur.com/IXnwbLk.png",
                                      name: "Support Adna",
                                      isConnected: true,
                                      isActive: true,
                                      // isTyping: true,
                                    ),
                                  ),
                                  snapshot.data!.docs.isEmpty
                                      ? Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.message_rounded,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color!
                                                    .withOpacity(.5),
                                                size: 50,
                                              ),
                                              Text(
                                                "Aucune discussion pour l'instand...",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: List.generate(
                                          snapshot.data!.docs.length,
                                          (index) => InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => ChatPage(
                                                          userName: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['name'],
                                                          image: snapshot.data!
                                                                  .docs[index]
                                                              ['image'],
                                                          receiver: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['receiver'])));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: SupportPersonInfo(
                                                image: snapshot
                                                    .data!.docs[index]['image'],
                                                name: snapshot.data!.docs[index]
                                                    ['name'],
                                                isConnected: false,
                                                isActive: true,
                                                // isTyping: true,
                                              ),
                                            ),
                                          ),
                                        ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
          floatingActionButton:
              (FirebaseAuth.instance.currentUser!.displayName == null ||
                      FirebaseAuth.instance.currentUser!.displayName!.isEmpty)
                  ? null
                  : FloatingActionButton.extended(
                      label: Text("Nouveau message"),
                      icon: Icon(Icons.contacts_rounded),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => NewChat()));
                      }),
        ),
        if (loading) LoadingComponent()
      ],
    );
  }
}
