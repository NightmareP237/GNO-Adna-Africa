// components/product/product_card.dart
import 'dart:math';

import 'package:adna/edit-post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.date,
    this.asset = false,
    this.delete = false,
    this.priceAfetDiscount,
    this.dicountpercent,
    required this.press,
    required this.press1,
    required this.press2,
    this.docid = '',
  });
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final String? date;
  final String docid;
  bool asset, delete;
  final VoidCallback press, press1, press2;
//  late String uid=FirebaseAuth.instance.currentUser!.uid.toString();
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
        // fixedSize: const Size(140, 150),
        padding: const EdgeInsets.all(8),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              asset
                  ? Image.asset(image)
                  : NetworkImageWithLoader(image, radius: defaultBorderRadious),
              // if (dicountpercent != null)
              Positioned(
                right: defaultPadding / 2,
                top: defaultPadding / 2,
                child: InkWell(
                  onTap: press1,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color:
                          delete ? Colors.red.shade100 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Icon(
                        delete
                            ? Icons.delete_forever_rounded
                            : Icons.favorite_border_rounded,
                        color: delete ? Colors.black : primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: defaultPadding / 2,
                top: defaultPadding / 2,
                child: GestureDetector(
                  onTap: press2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Icon(
                        color: delete
                            ? Theme.of(context).iconTheme.color
                            : primaryColor,
                        delete ? Icons.edit : Icons.ios_share_rounded,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              )
            ],
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

                  Text(
                    (brandName.toUpperCase()).length >= 25
                        ? "${(brandName.toUpperCase()).substring(0, 18)}..."
                        : (brandName.toUpperCase()),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 10),
                  ),
                  // const SizedBox(height: defaultPadding / 4),
                  // Text(
                  //   title,
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .titleSmall!
                  //       .copyWith(fontSize: 12),
                  // ),
                  // const Spacer(),
                  // priceAfetDiscount != null
                  //     ? Row(
                  //         children: [
                  //           Text(
                  //             "\$$priceAfetDiscount",
                  //             style: const TextStyle(
                  //               color: Color(0xFF31B0D8),
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 12,
                  //             ),
                  //           ),
                  //           const SizedBox(width: defaultPadding / 4),
                  //           Text(
                  //             "\$$price",
                  //             style: TextStyle(
                  //               color: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyMedium!
                  //                   .color,
                  //               fontSize: 10,
                  //               decoration: TextDecoration.lineThrough,
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     :
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "  $date",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding / 2.5,
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  // Container(
                  //   width:30,
                  //   height: 30,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey.shade300,
                  //     borderRadius: BorderRadius.circular(30),
                  //   ),
                  //   child: Center(
                  //     child: Icon(
                  //       Icons.check_circle_outline_rounded,
                  //       size: 18,
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: (){
                  //  NoAccount(context);

                  //   },
                  //   child: Container(
                  //     width: 30,
                  //     height: 30,
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.shade300,
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     child: Center(
                  //       child: Icon(
                  //         Icons.chat_bubble,
                  //         size: 18,
                  //         color: primaryColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  //   ],
                  // ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //      NoAccount(context);

                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 25,
                  //     decoration: BoxDecoration(
                  //       color: primaryColor,
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         'En savoir plus',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.w700,
                  //           fontSize: 12,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  //  const
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonCard extends StatelessWidget {
  ButtonCard(
      {super.key,
      required this.label,
      required this.isOutline,
      required this.onTap,
      this.isDisabled = false});
  final String label;
  final bool isOutline;
  final bool isDisabled;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: (!isOutline)
            ? BoxDecoration(
                color: isDisabled ? Colors.black26 : primaryColor,
                borderRadius: BorderRadius.circular(4.0),
              )
            : BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: isDisabled ? Colors.black26 : primaryColor),
                borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Text(
            label,
            style: buttonStyle((!isOutline)
                ? Colors.white
                : isDisabled
                    ? Colors.black
                    : primaryColor),
          ),
        ),
      ),
    );
  }
}

class ButtonCard1 extends StatelessWidget {
  ButtonCard1(
      {super.key,
      required this.label,
      required this.isOutline,
      required this.onTap,
      this.isDisabled = false});
  final String label;
  final bool isOutline;
  final bool isDisabled;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: (!isOutline)
            ? BoxDecoration(
                color: isDisabled ? Colors.black26 : primaryColor,
                borderRadius: BorderRadius.circular(4.0),
              )
            : BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: isDisabled ? Colors.black26 : primaryColor),
                borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Text(
            label,
            style: buttonStyle((!isOutline)
                ? Colors.white
                : isDisabled
                    ? Colors.black26
                    : primaryColor),
          ),
        ),
      ),
    );
  }
}

TextStyle onBoardTextStyle(Color c) => TextStyle(
      color: c,
      fontFamily: 'DMSans',
      fontWeight: FontWeight.w700,
      // height: 0.8,
      fontSize: 53,
    );
TextStyle titleStyle(Color c) => TextStyle(
      color: c,
      fontFamily: 'DMSans',
      fontWeight: FontWeight.w700,
      // height: 0.64,
      fontSize: 24,
    );
TextStyle supertitleStyle(Color c) => TextStyle(
      color: c,
      fontFamily: 'DMSans',
      fontWeight: FontWeight.w700,
      // height: 0.8,
      fontSize: 32,
    );
TextStyle subtitleStyle(Color c) => TextStyle(
      color: c,
      fontFamily: 'DMSans',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      // height: 0.56,
    );
TextStyle bodyBoldStyle(Color c) => TextStyle(
      color: c,
      fontFamily: 'DMSans',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      // height: 0.48,
    );
TextStyle bodyStyle(Color c) => TextStyle(
    color: c,
    fontFamily: 'DMSans',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    // height: 0.48,
    inherit: false);
TextStyle bodyFieldStyle(Color c) => TextStyle(
      color: c,
      fontFamily: 'DMSans',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      // textBaseline: TextBaseline.alphabetic
      // height: 15.0
    );
TextStyle bodyLightStyle(Color c) => TextStyle(
    fontFamily: 'DMSans',
    fontWeight: FontWeight.w300,
    fontSize: 16,
    // height: 0.48,
    color: c);
TextStyle footnoteStyle(Color c) => TextStyle(
    fontFamily: 'DMSans',
    fontWeight: FontWeight.w700,
    fontSize: 12,
    // height: 0.32,
    color: c);
TextStyle footfilterStyle(Color c) => TextStyle(
    fontFamily: 'DMSans',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    // height: 0.32,
    color: c);
TextStyle footboldStyle(Color c) => TextStyle(
    fontFamily: 'DMSans',
    fontWeight: FontWeight.w800,
    fontSize: 12,
    // height: 0.32,
    color: c);
TextStyle SeetingStyle(Color c) => TextStyle(
    fontFamily: 'DMSans',
    fontWeight: FontWeight.w300,
    fontSize: 16,
    height: 0,
    color: c);
TextStyle overlineStyle(Color c) => TextStyle(
      fontFamily: 'DMSans',
      fontWeight: FontWeight.w600,
      fontSize: 10,
      // height: 0.32,
      color: c,
    );
TextStyle buttonStyle(Color c) => TextStyle(
    fontFamily: 'DMSans',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    // height: 0.48,
    letterSpacing: 1,
    color: c);
TextStyle linkStyle(Color c) => TextStyle(
    fontFamily: 'DMSans', fontWeight: FontWeight.w300, fontSize: 12, color: c);
TextStyle linkFootnoteStyle(Color c) {
  return TextStyle(
      fontFamily: 'DMSans',
      fontWeight: FontWeight.w700,
      fontSize: 12,
      // height: 0.32,
      color: c);
}

TextStyle failedStyle(Color c) => TextStyle(
    fontFamily: 'SignikaNegative',
    fontWeight: FontWeight.w500,
    fontSize: 10,
    color: c);

class PopularAccount extends StatelessWidget {
  const PopularAccount(
      {super.key,
      required this.image,
      this.rate = 1,
      required this.brandName,
      // required this.title,
      // required this.location,
      this.priceAfetDiscount,
      this.dicountpercent,
      required this.press,
      this.isAsset = false});
  final String image, brandName;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final int rate;
  final VoidCallback press;
  final bool isAsset;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(140, 150),
          maximumSize: const Size(140, 150),
          padding: const EdgeInsets.all(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: defaultPadding / 4,
          ),
          //  if (dicountpercent != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            // width: 0,
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(
                Radius.circular(defaultBorderRadious),
              ),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...List.generate(
                rate == 0 ? 2 : rate,
                (index) => SvgPicture.asset(
                  "assets/icons/Star_filled.svg",
                  width: 10,
                  height: 10,
                ),
              ),
              ...List.generate(
                  rate == 0 ? 3 : 4,
                  (index) => Icon(
                        Icons.star_border_outlined,
                        size: 12,
                        color: Theme.of(context).textTheme.titleSmall!.color,
                      ))
            ]),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isAsset
                  ? Image.asset(image)
                  : image.isEmpty
                      ? Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset('assets/images/user-flat.png'),
                        )
                      : NetworkImageWithLoader(
                          image,
                          radius: 120,
                          isprofil: true,
                        ),
            ],
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  height: 20,
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
                        "Pro ",
                        style: footnoteStyle(
                            Theme.of(context).textTheme.headlineSmall!.color!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  brandName.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 12),
                ),
                const SizedBox(height: defaultPadding / 2),
                // Text(
                //   title,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: Theme.of(context)
                //       .textTheme
                //       .titleSmall!
                //       .copyWith(fontSize: 12),
                // ),
                // const Spacer(),
                // priceAfetDiscount != null
                //     ? Row(
                //         children: [
                //           Text(
                //             "\$$priceAfetDiscount",
                //             style: const TextStyle(
                //               color: Color(0xFF31B0D8),
                //               fontWeight: FontWeight.w500,
                //               fontSize: 12,
                //             ),
                //           ),
                //           const SizedBox(width: defaultPadding / 4),
                //           Text(
                //             "\$$price",
                //             style: TextStyle(
                //               color: Theme.of(context)
                //                   .textTheme
                //                   .bodyMedium!
                //                   .color,
                //               fontSize: 10,
                //               decoration: TextDecoration.lineThrough,
                //             ),
                //           ),
                //         ],
                //       )
                //     :
                // SizedBox(
                //   height: defaultPadding / 2,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     const Text('🇨🇲'),
                //     const SizedBox(
                //       width: defaultPadding / 4,
                //     ),
                //     Text(
                //       "$location",
                //       style: const TextStyle(
                //         color: Color(0xFF31B0D8),
                //         fontWeight: FontWeight.w500,
                //         fontSize: 12,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
