// screens/user_info/views/account-pro.dart
import 'package:adna/components/product/product_card.dart';
import 'package:adna/models/user_model.dart';
import 'package:adna/screens/user_info/views/post_gallery_screen_pro.dart';
import 'package:adna/widgets/profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
class ProfileBaseScreen extends StatefulWidget {
  ProfileBaseScreen({required this.userInfo, required this.postUserPro});
  final UserInfoView userInfo;
  final List postUserPro;
  @override
  _ProfileBaseScreenState createState() => _ProfileBaseScreenState();
}
 void launchWhatsApp(
    {required int phone,
    required String message,
    }) async {
  String url() {
    if (Platform.isAndroid) {
      return "whatsapp://wa.me/$phone:03452121308:/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?   phone=$phone&text=${Uri.parse(message)}";
    }
  }

  if (await canLaunch(url())) {
    await launch(url());
  } else {
    throw 'Could not launch ${url()}';
  }
}

class _ProfileBaseScreenState extends State<ProfileBaseScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.postUserPro.length);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              widget.userInfo.name,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            centerTitle: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.black,
                ),
                onPressed: () => print("Add"),
              ),
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () => print("Add"),
              )
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    profileHeaderWidget(
                      context,
                      widget.userInfo,
                      widget.userInfo.image,
                      widget.userInfo.uid.toString(),
                      widget.userInfo.name,
                      widget.userInfo.country,
                      widget.userInfo.secteur,
                      widget.postUserPro.length,
                      widget.userInfo.followers,
                      widget.userInfo.share.toString(),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorWeight: 1,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.grid_on_sharp,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Gallery(
                      postUser: widget.postUserPro,
                      Username: widget.userInfo.name,
                      photoUrl: widget.userInfo.image,
                    ),
                    Scaffold(
                      body: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ButtonCard1(label: "Me contacter", isOutline: true,
                             onTap: (){
                            //  launchWhatsApp(phone: widget.postUserPro, message: message)
                            }),
                            SizedBox(height: 16,),
                            ButtonCard1(label: "Ne plus suivre", isOutline: false,
                             onTap: (){
                              //  launchWhatsApp(phone: widget.postUserPro, message: message)
                              }),
                          ],
                        ),
                      ),
                    ),
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
// class Highlight {
//   String thumbnail;
//   String title;
//   Highlight({required this.thumbnail,required this.title});
// }

// List<Highlight> highlightItems = [
//   Highlight(thumbnail: 'assets/images/bike.jpg', title: "My Bike 🏍"),
//   Highlight(thumbnail: 'assets/images/cooking.jpg', title: "Cooking 🔪"),
//   Highlight(thumbnail: 'assets/images/nature.jpg', title: "Nature 🏞"),
//   Highlight(thumbnail: 'assets/images/pet.jpg', title: "Pet ❤️"),
//   Highlight(thumbnail: 'assets/images/swimming.jpg', title: "Pool 🌊"),
//   Highlight(thumbnail: 'assets/images/yoga.jpg', title: "Yoga 💪🏻"),
// ];