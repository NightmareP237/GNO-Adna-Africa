// screens/chat/views/chat_screen.dart
import 'package:adna/components/chat_active_dot.dart';
import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:adna/constants.dart';
import 'package:adna/theme/input_decoration_theme.dart';

import 'components/support_person_info.dart';
import 'components/text_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final UserInfoView user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final ScrollController _scrollController = ScrollController();

class _ChatScreenState extends State<ChatScreen> {
  final editcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {});
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/info.svg",
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .collection("discussions")
            .doc(widget.user.uid.toString())
            .collection("messages")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LoadingComponent(),
            );
          }
          return snapshot.data!.docs.isEmpty
              ? SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                NetworkImageWithLoader(
                                  widget.user.image.isEmpty
                                      ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                      : widget.user.image,
                                  radius: 50,
                                ),
                                const Positioned(
                                  right: -4,
                                  top: -4,
                                  child: ChatActiveDot(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Aucun message pour l'instand...",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("Envoyer un message et commencer a discuter !",
                              style: Theme.of(context).textTheme.bodySmall)
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          SendNotification(
                              FirebaseAuth.instance.currentUser!.displayName
                                  .toString(),
                              'Nouveau message',
                              widget.user.fcmToken.toString(),
                              (FirebaseAuth.instance.currentUser!.photoURL ==
                                          null ||
                                      FirebaseAuth.instance.currentUser!
                                          .photoURL!.isEmpty)
                                  ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                  : FirebaseAuth
                                      .instance.currentUser!.photoURL!);
                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .collection("discussions")
                              .doc(widget.user.uid.toString())
                              .collection("messages")
                              .add({
                            "message": editcontroller.text.trim(),
                            "sender": FirebaseAuth.instance.currentUser!.uid
                                .toString(),
                            "receiver": widget.user.uid.toString(),
                            "time": DateTime.now().millisecondsSinceEpoch,
                            "seen": false,
                            "type": "text",
                          });
                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(widget.user.uid.toString())
                              .collection("discussions")
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .collection("messages")
                              .add({
                            "message": editcontroller.text.trim(),
                            "sender": FirebaseAuth.instance.currentUser!.uid
                                .toString(),
                            "receiver": widget.user.uid.toString(),
                            "time": DateTime.now().millisecondsSinceEpoch,
                            "seen": false,
                            "type": "text",
                          });
                          // FirebaseFirestore.instance
                          //     .collection('chats')
                          //     .doc(FirebaseAuth.instance.currentUser!.uid
                          //         .toString())
                          //     .collection("discussions")
                          //     .doc(widget.user.uid.toString())
                          //     .collection("messages")
                          //     .add({
                          //   "sender": FirebaseAuth.instance.currentUser!.uid
                          //       .toString(),
                          //   "receiver": widget.user.uid.toString(),
                          //   "message": "Bonjour",
                          //   "time": DateTime.now().millisecondsSinceEpoch,
                          //   "seen": false,
                          //   "type": "text",
                          // });
                          FirebaseFirestore.instance
                              .collection('contacts')
                              .doc(widget.user.uid.toString())
                              .collection("me")
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .set({
                            "name":
                                FirebaseAuth.instance.currentUser!.displayName,
                            "sender": widget.user.uid.toString(),
                            "receiver": FirebaseAuth.instance.currentUser!.uid
                                .toString(),
                            "time": DateTime.now().millisecondsSinceEpoch,
                            "seen": false,
                            "image": (FirebaseAuth
                                            .instance.currentUser!.photoURL ==
                                        null ||
                                    FirebaseAuth.instance.currentUser!.photoURL!
                                        .isEmpty)
                                ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                : FirebaseAuth.instance.currentUser!.photoURL!
                          }).then((value) {
                            FirebaseFirestore.instance
                                .collection('contacts')
                                .doc(FirebaseAuth.instance.currentUser!.uid
                                    .toString())
                                .collection("me")
                                .doc(widget.user.uid.toString())
                                .set({
                              "name": widget.user.name,
                              "sender": FirebaseAuth.instance.currentUser!.uid
                                  .toString(),
                              "receiver": widget.user.uid.toString(),
                              "time": DateTime.now().millisecondsSinceEpoch,
                              "seen": false,
                              "image": widget.user.image
                            });
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(defaultBorderRadious)),
                            border: Border.all(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.15),
                            ),
                          ),
                          child: const Center(
                            child: Text("Envoyer un message",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .iconTheme
                            .color!
                            .withOpacity(0.05),
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                      ),
                      child: ListTile(
                          trailing: SvgPicture.asset('assets/icons/Lock.svg'),
                          title: Row(
                            children: [
                              Text(
                                "Vos messages sont securises de bout en bout.",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        color: primaryColor, fontSize: 10),
                              ),
                            ],
                          ),
                          minLeadingWidth: 24,
                          leading: SvgPicture.asset('assets/icons/Lock.svg')),
                    ),
                    // For Better perfromance use [ListView.builder]

                    snapshot.data!.docs.length <= 1
                        ? Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.message,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Aucun message pour l'instand...",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Envoyer un message et commencer a discuter !",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(color: primaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding,
                                  vertical: defaultPadding),
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs[0]
                                        .get('sender')
                                        .toString()
                                        .contains(FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString())
                                    ? snapshot.data!.docs.length - 1
                                    : snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var listData = snapshot.data!.docs;
                                  listData.sort(
                                    (a, b) => DateTime
                                            .fromMillisecondsSinceEpoch(
                                                a.get('time'))
                                        .compareTo(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                b.get('time'))),
                                  );
                                  // snapshot.data!.docs[0]
                                  //         .get('sender')
                                  //         .toString()
                                  //         .contains(FirebaseAuth
                                  //             .instance.currentUser!.uid
                                  //             .toString())
                                  //     ? listData.remove(listData[0])
                                  //     : null;
                                  listData.remove(listData[0]);
                                  return TextMessage(
                                    message: listData[index].get('message'),
                                    time: "${DateTime.fromMillisecondsSinceEpoch(
                                                listData[index].get('time'))
                                            .toString()
                                            .split(" ")[1]
                                            .split(":")[0]}:${DateTime.fromMillisecondsSinceEpoch(
                                                listData[index].get('time'))
                                            .toString()
                                            .split(" ")[1]
                                            .split(":")[1]}",
                                    isSender: listData[index]
                                            .get('sender')
                                            .toString()
                                            .contains(FirebaseAuth
                                                .instance.currentUser!.uid
                                                .toString())
                                        ? true
                                        : false,
                                    isSent: listData[index]
                                        .get('sender')
                                        .toString()
                                        .contains(FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString()),
                                    isRead: true,
                                  );
                                  //  MessageTile(
                                  //   message: snapshot.data!.docs[index].get('message'),
                                  //   isMe: snapshot.data!.docs[index].get('isMe'),
                                  //   time: snapshot.data!.docs[index].get('time'),
                                  //   );
                                },
                                // children: const [

                                // TextMessage(
                                //   message:
                                //       "Howdy, is there something we can help you with today?",
                                //   time: "15:38",
                                //   isSender: false,
                                //   isSent: false,
                                // ),
                                // TextMessage(
                                //   message: "I need some assistance.",
                                //   time: "15:43",
                                //   isSender: true,
                                //   isSent: true,
                                //   isRead: true,
                                //   isShowTime: false,
                                // ),
                                // TextMessage(
                                //   message: "Help me choose the best plan.",
                                //   time: "15:43",
                                //   isSender: true,
                                //   isSent: true,
                                //   isRead: true,
                                // ),
                                // ],
                              ),
                            ),
                          ),
                    // Text Field
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: defaultPadding / 2),
                        child: Form(
                          child: TextFormField(
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
                                    FirebaseFirestore.instance
                                        .collection('chats')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString())
                                        .collection("discussions")
                                        .doc(widget.user.uid.toString())
                                        .collection("messages")
                                        .add({
                                      "message": editcontroller.text.trim(),
                                      "sender": FirebaseAuth
                                          .instance.currentUser!.uid
                                          .toString(),
                                      "receiver": widget.user.uid.toString(),
                                      "time":
                                          DateTime.now().millisecondsSinceEpoch,
                                      "seen": false,
                                      "type": "text",
                                    });
                                    FirebaseFirestore.instance
                                        .collection('chats')
                                        .doc(widget.user.uid.toString())
                                        .collection("discussions")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString())
                                        .collection("messages")
                                        .add({
                                      "message": editcontroller.text.trim(),
                                      "sender": FirebaseAuth
                                          .instance.currentUser!.uid
                                          .toString(),
                                      "receiver": widget.user.uid.toString(),
                                      "time":
                                          DateTime.now().millisecondsSinceEpoch,
                                      "seen": false,
                                      "type": "text",
                                    });
                                    SendNotification(
                                        FirebaseAuth
                                            .instance.currentUser!.displayName
                                            .toString(),
                                        editcontroller.text.trim(),
                                        widget.user.fcmToken.toString(),
                                        (FirebaseAuth.instance.currentUser!
                                                        .photoURL ==
                                                    null ||
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .photoURL!
                                                    .isEmpty)
                                            ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                            : FirebaseAuth.instance.currentUser!
                                                .photoURL!);
                                    setState(() {
                                      editcontroller.text = "";
                                    });
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
                              hintText: "Envoyer un message...",
                              border: secodaryOutlineInputBorder(context),
                              enabledBorder:
                                  secodaryOutlineInputBorder(context),
                              focusedBorder: focusedOutlineInputBorder,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      // floatingActionButton: (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) ?SizedBox():Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 80),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       FloatingActionButton(
      //         onPressed: () {
      //           _scrollController.animateTo(
      //               curve: Curves.easeIn,
      //               duration: Duration(microseconds: 700),
      //               _scrollController.position.maxScrollExtent);
      //         },
      //         child: const Icon(Icons.arrow_downward),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  static Future<bool> SendNotification(
      String title, String body, String token, String image) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'sendNotification',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 5),
      ),
    );
    try {
      final response = await callable.call(<String, dynamic>{
        'title': title,
        'body': body,
        'image': image,
        'token': token,
      });
      print('result is ${response.data ?? 'No data came back'}');
      if (response.data == null) return false;
      return true;
    } on FirebaseFunctionsException catch (e) {
      print("this is the error $e");
      return false;
    }
  }
}
