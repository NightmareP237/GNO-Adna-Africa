// screens/user_info/views/post_gallery_screen_pro.dart
import 'package:adna/components/product/product_card.dart';
import 'package:adna/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class Gallery extends StatefulWidget {
  const Gallery(
      {super.key, required this.postUser, required this.Username, required this.photoUrl});
  final List postUser;
  final String Username, photoUrl;
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late OverlayEntry _popupDialog;
  List<String> imageUrls = [];
  @override
  void initState() {
    // TODO: implement initState
    for (var post in widget.postUser) {
      imageUrls.add(post['image']);
    }
    super.initState();
  }

  @override
  Widget _createActionBar(BuildContext context, int index) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                             _popupDialog.remove();
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Publication enregister avec sucess !",
                                style: TextStyle(
                                    color: Theme.of(context).indicatorColor),
                              ),
                            ));
              },
              child: const Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width / 2.78,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: Text(
                  "${widget.postUser[index]['location'].toString().split(' ')[0]} Postuler a l'offre",
                  style: footboldStyle(lightGreyColor),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                _onShareXFileFromAssets(context, widget.postUser[index]['description'],  widget.Username);
              },
              child: const Icon(
                Icons.ios_share_outlined,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
void _onShareXFileFromAssets(
    BuildContext context, var description, name) async {
  final box = context.findRenderObject() as RenderBox?;
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final data = await rootBundle.load('assets/adna-hd.png');
  final buffer = data.buffer;
  final shareResult = await Share.shareXFiles(
    subject: 'Adnafrica',
    text:
        "$name $description cette offre est disponible sur Adnafrica télécharger l'application et postuler a l'offre avec le lien : https://www.google.com/PlayStore/Cloud/Apk/adnafrica/home/hs6772njdj883 ",
    [
      XFile.fromData(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        name: 'order-share.png',
        mimeType: 'image/png',
      ),
    ],
    sharePositionOrigin: box!.localToGlobal(Offset.zero) / 2 & box.size / 2,
  );

  scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
}

SnackBar getResultSnackBar(ShareResult result) {
  return SnackBar(
    backgroundColor: Colors.green.shade500,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (result.status == ShareResultStatus.success)
         Text("Partage de l'offre sur ${result.raw} effectue avec sucess !",
            style:footboldStyle (Colors.white)),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    print(widget.photoUrl);

    print(imageUrls);
    return Scaffold(
      body: imageUrls.isEmpty
          ? SizedBox(
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.now_widgets_sharp,
                      size: 80,
                      color: primaryColor.withOpacity(.5),
                    ),
                    Text(
                      "Aucun post pour le moment !",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ]),
            )
          : GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              children: List.generate(imageUrls.length,
                  (index) => _createGridTileWidget(imageUrls[index], index)),
            ),
    );
  }

  Widget _createGridTileWidget(String url, int index) => Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            _popupDialog = _createPopupDialog(url, index);
            Overlay.of(context).insert(_popupDialog);
          },
          child: Container(
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(16.0),
              child: IntrinsicHeight(
                child: Container(
                  // color: Colors.grey,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: .5,
                          color:
                              Theme.of(context).textTheme.bodyLarge!.color!)),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // _createPhotoTitle(),
                      Stack(
                        children: [
                          SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 10,
                              child: Image.network(
                                  widget.postUser[index]['image'].toString(),
                                  fit: BoxFit.fitWidth)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          widget.postUser[index]['description'],
                          style: footnoteStyle(
                            Theme.of(context).textTheme.labelLarge!.color!,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  OverlayEntry _createPopupDialog(String url, int index) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url, index),
      ),
    );
  }

  Widget _createPhotoTitle() => Container(
      width: double.infinity,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.photoUrl),
        ),
        title: Text(
          widget.Username,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        trailing: GestureDetector(
          onTap: () {
            _popupDialog.remove();
          },
          child: Container(
              width: 25,
              height: 25,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: errorColor),
              child: const Center(
                  child: Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ))),
        ),
      ));

  Widget _createPopupContent(String url, int index) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _createPhotoTitle(),
                Image.network(url, fit: BoxFit.fitWidth),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding / 2.5),
                  child: Text(
                    widget.postUser[index]['description'],
                    style: footboldStyle(
                        Theme.of(context).textTheme.labelMedium!.color!),
                  ),
                ),
                _createActionBar(context, index),
              ],
            ),
          ),
        ),
      );
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
