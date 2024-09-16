// screens/chat/views/new_chat.dart
import 'package:adna/components/chat_active_dot.dart';
import 'package:adna/components/network_image_with_loader.dart';
import 'package:adna/constants.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/screens/chat/views/chat_screen.dart';
import 'package:adna/theme/input_decoration_theme.dart';
import 'package:adna/widgets/loader-component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewChat extends StatefulWidget {
  const NewChat({super.key});

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  late FocusNode _focusNode;
  bool _isFocused = false, loading = false;
  final searchcontroller = TextEditingController();
  List<UserInfoView> users = [], searchUsers = [];
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
         var value= UserInfoView.fromDocumentSnapshot(element, element.id);
            setState(() {
              print(value.email);
              users.add(value);
              print(users);
            });
          users.shuffle();
          searchUsers = users;
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
    GetUsersConnected();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Nouveau message'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  child: TextFormField(
                    controller: searchcontroller,
                    autofocus: _isFocused,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        searchUsers = users
                            .where(
                              (element) =>
                                  element.name.toLowerCase().trim().contains(
                                        value.toLowerCase().trim(),
                                      ),
                            )
                            .toList();
                        print(searchUsers.length);
                      });
                    },
                    onFieldSubmitted: (value) {},
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Recherchez un profil...",
                      filled: false,
                      border: secodaryOutlineInputBorder(context),
                      enabledBorder: secodaryOutlineInputBorder(context),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SvgPicture.asset(
                          "assets/icons/Search.svg",
                          height: 24,
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(0.3),
                        ),
                      ),
                      suffixIcon: SizedBox(
                        width: 40,
                        child: Row(
                          children: [
                            const SizedBox(
                              height: 24,
                              child: VerticalDivider(width: 1),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  "assets/icons/Filter.svg",
                                  height: 24,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
                    itemBuilder: (context, index) => users[index].image.isEmpty
                        ? SizedBox()
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            user: users[index],
                                          )));
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
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
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              ],
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Text("Nouveau profil",
                    style: Theme.of(context).textTheme.bodyLarge),
                Expanded(
                    child: SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: searchUsers.length,
                    // itemExtent: 4,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .iconTheme
                            .color!
                            .withOpacity(0.05),
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                      ),
                      child: ListTile(
                        trailing: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          user: searchUsers[index],
                                        )));
                          },
                          label: Text("Disussion"),
                        ),
                        title: Row(
                          children: [
                            Text(searchUsers[index].name),
                            // if (isConnected && !isTyping) const Text("connected",style: TextStyle(color: successColor),),
                            // if (isConnected && isTyping) const Text("typing..."),
                          ],
                        ),
                        minLeadingWidth: 24,
                        leading: CircleAvatar(
                          radius: 12,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              NetworkImageWithLoader(
                                searchUsers[index].image.isEmpty
                                    ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                    : searchUsers[index].image,
                                radius: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
        if (loading) LoadingComponent()
      ],
    );
  }
}
