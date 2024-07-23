// historique.dart
import 'package:adna/components/product/product_card.dart';
import 'package:adna/constants.dart';
import 'package:adna/database/Auth.dart';
import 'package:adna/edit-post.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  bool loading = false;
  List<Map<String, dynamic>> posts = [], historique = [];
  AuthServices auth = AuthServices();
  User? user;
  Future<User?> getuser() async {
    return user = await auth.user;
  }

  GetUserPostsData() {
    try {
      setState(() {
        loading = true;
      });
      final db = FirebaseFirestore.instance;
      db
          .collection("historique")
          .where("uid", isEqualTo: user?.uid.toString())
          .orderBy('timestamp', descending: true)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          print(element.id.toString());
          Map<String, dynamic> allData = element.data();
          print(allData);
          allData.addAll({"docId": element.id.toString()});
          historique.add(allData);
            print("historique :" +historique.toString());
        });
        db
            .collection("posts")
            .where("uid", isEqualTo: user?.uid.toString())
            .orderBy('timestamp', descending: true)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            print(element.id.toString());
            Map<String, dynamic> allData = element.data();
            print(allData);
            allData.addAll({"docId": element.id.toString()});
            posts.add(allData);
            print("posts :"+posts.toString());
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
      if (user != null) GetUserPostsData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 16,),
                      //  const SizedBox(height: defaultPadding / 2),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: SvgPicture.asset(
                                  'assets/icons/Arrow - Left.svg'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Text(
                              "Mes Publications",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
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
                  historique.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                          height: MediaQuery.of(context).size.height / 1.2,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Order.svg",
                                height: 50,
                                width: 50,
                                color: primaryColor,
                              ),
                              Text(
                                "Aucune publication",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor),
                              )
                            ],
                          ),
                        ))
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              mainAxisSpacing: defaultPadding,
                              crossAxisSpacing: defaultPadding,
                              childAspectRatio: .9,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ProductCard(
                                  press1: () {
                                    showAlertDialog3(
                                        methodYes: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            loading = true;
                                          });
                                          FirebaseFirestore.instance
                                              .collection("historique")
                                              .doc(historique[index]['docId']
                                                  .toString())
                                              .delete()
                                              .then((value) {
                                            FirebaseFirestore.instance
                                                .collection('posts')
                                                .doc(posts[index]['docId']
                                                    .toString())
                                                .delete()
                                                .then((value) {
                                              setState(() {
                                                historique
                                                  .remove(historique[index]);
                                                loading = false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                  "Suppression effectue avec success !",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .indicatorColor),
                                                ),
                                              ));
                                            });
                                          });
                                        },
                                        context: context,
                                        title: "Attention",
                                        body:
                                            "Voullez supprimez cette publication ?",
                                        methodNo: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            loading = true;
                                          });
                                          FirebaseFirestore.instance
                                              .collection("historique")
                                              .doc(historique[index]['docId']
                                                  .toString())
                                              .delete()
                                              .then((value) {
                                            setState(() {
                                              historique
                                                  .remove(historique[index]);
                                              loading = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                "Suppression effectue avec success !",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .indicatorColor),
                                              ),
                                            ));
                                          });
                                        });
                                  },
                                  press2: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => EditPostScreen(
                                              docPostId:  posts[index]
                                                          ['docId']
                                                      .toString(),
                                                  docHistoryId: historique[index]
                                                          ['docId']
                                                      .toString(),
                                                  activity: historique[index]
                                                          ['secteur']
                                                      .toString(),
                                                  annonce: historique[index]
                                                          ['location']
                                                      .toString(),
                                                  imageUrl: historique[index]
                                                          ['image']
                                                      .toString(),
                                                  postName: historique[index]
                                                          ['description']
                                                      .toString(),
                                                )));
                                  },
                                  asset: false,
                                  delete: true,
                                  price: 100,
                                  docid: historique[index]['docId'].toString(),
                                  image: historique[index]['image'].toString(),
                                  brandName: historique[index]['location']
                                          .toString()
                                          .split(' ')[0] +
                                      " " +
                                      historique[index]['secteur'].toString(),
                                  title: "Aucun",
                                  date: "1min , " +
                                      historique[index]['location']
                                          .toString()
                                          .split(' ')[1],
                                  // priceAfetDiscount:
                                  //     demoPopularProducts[index].priceAfetDiscount,
                                  // dicountpercent: demoPopularProducts[index].dicountpercent,
                                  press: () {
                                    // user == null?  NoAccount(context):
                                    //     Navigator.pushNamed(context, productDetailsScreenRoute);
                                  },
                                );
                              },
                              childCount: historique.length,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          if (loading) LoadingComponent()
        ],
      ),
    );
  }
}
