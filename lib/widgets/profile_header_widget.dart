// widgets/profile_header_widget.dart
import 'package:adna/constants.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/screens/chat/views/chat_page.dart';
import 'package:adna/screens/user_info/views/account-pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

IncrementWalletPending(String Uid) {
  final DocumentReference docRef =
      FirebaseFirestore.instance.collection("users").doc(Uid);
  docRef.update({"walletPending": FieldValue.increment(1000)});
}

DecrementWalletPending(String Uid) {
  final DocumentReference docRef =
      FirebaseFirestore.instance.collection("users").doc(Uid);
  docRef.update({"walletPending": FieldValue.increment(-1000)});
}

Widget profileHeaderWidget(BuildContext context, UserInfoView user, String img,
    DocId, name, country, List hoby, int postNumber,List followers,String sharing,
    ) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xff74EDED),
                backgroundImage: NetworkImage(img.isEmpty
                    ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                    : img),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        postNumber.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Posts",
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0.4,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        followers.length.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        sharing,
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Partages",
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.4,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2,
                    vertical: defaultPadding / 8),
                height: 25,
                decoration: const BoxDecoration(
                  color: successColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(defaultBorderRadious)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Certifie",
                      style: TextStyle(letterSpacing: 0.4, color: Colors.white),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                country,
                style: TextStyle(
                  letterSpacing: 0.4,
                ),
              ),
              Text(
                "Compte professionel",
                style: TextStyle(
                    letterSpacing: 0.2,
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                         !followers.contains(FirebaseAuth.instance.currentUser!.uid)
                              ? Icons.add_circle_outline_rounded
                              : Icons.check,
                          size: 20,
                          color:  !followers.contains(FirebaseAuth.instance.currentUser!.uid) ? primaryColor : greyColor,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text( !followers.contains(FirebaseAuth.instance.currentUser!.uid) ? "Suivre" : "Suivi(e)",
                            style: TextStyle(
                                color:  !followers.contains(FirebaseAuth.instance.currentUser!.uid) ? primaryColor : greyColor)),
                      ],
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(0, 30),
                      side: BorderSide(
                        color:  !followers.contains(FirebaseAuth.instance.currentUser!.uid) ? primaryColor : greyColor,
                      )),
                  onPressed: followers.contains(FirebaseAuth.instance.currentUser!.uid)?null: () {
                  print(DocId);
                        final DocumentReference docRef = FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(DocId);
                        docRef.update({
                          "followers": FieldValue.arrayUnion([
                            FirebaseAuth.instance.currentUser!.uid.toString()
                          ])
                        });
                         docRef.update({"share": FieldValue.increment(1)});
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Compte suivi",
                                style: TextStyle(
                                    color: Theme.of(context).indicatorColor),
                              ),
                            ));
                            print("User Added");
                          })
              ),
              Expanded(
                child: OutlinedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Message", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: primaryColor,
                    minimumSize: Size(0, 30),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChatPage(user: user)));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Centres d'interets",
            style: TextStyle(
                letterSpacing: 0.2,
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 85,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: hoby.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Column(
                      children: [
                        OutlinedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  size: 20,
                                  color: Colors.grey[800]!,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(hoby[index],
                                    style: TextStyle(color: Colors.grey[800]!)),
                              ],
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size(0, 30),
                              side: BorderSide(
                                color: Colors.grey[400]!,
                              )),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    ),
  );
}
