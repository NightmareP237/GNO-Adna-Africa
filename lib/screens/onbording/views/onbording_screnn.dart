// screens/onbording/views/onbording_screnn.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:adna/components/dot_indicators.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/route_constants.dart';

import 'components/onbording_content.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
 
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      List<Onbord> _onbordData = [
   Onbord(
      image: "assets/images/adna-hd.png",
      imageDarkTheme: "assets/images/adna-hd.png",
      title: "La plateforme de mise en relation",
      description:
          "Bienvenue sur ADNAFRICA une solution rapide et fiable de mise en relation ici et ailleurs.",
    ),
    Onbord(
      image: "assets/images/protect.png",
      imageDarkTheme: "assets/Illustration/Illustration_darkTheme_1.png",
      title: "Protection des donnees",
      description:
          "Nous vous garantissons une protection de vos donnees ainsi qu'une communaute de confiance ! ",
    ),
    // Onbord(
    //   image: "assets/Illustration/Illustration-2.png",
    //   imageDarkTheme: "assets/Illustration/Illustration_darkTheme_2.png",
    //   title: "Fast & secure \npayment",
    //   description: "There are many payment options available for your ease.",
    // ),
    // Onbord(
    //   image: "assets/Illustration/Illustration-3.png",
    //   imageDarkTheme: "assets/Illustration/Illustration_darkTheme_3.png",
    //   title: "Package tracking",
    //   description:
    //       "In particular, adnalon can pack your orders, and help you seamlessly manage your shipments.",
    // ),
    // Onbord(
    //   image: "assets/Illustration/Illustration-4.png",
    //   imageDarkTheme: "assets/Illustration/Illustration_darkTheme_4.png",
    //   title: "Nearby stores",
    //   description:
    //       "Easily track nearby adnas, browse through their items and get information about their prodcuts.",
    // ),
  ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, notificationPermissionScreenRoute);
                },
                child: Text(
                  "Ignorer",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color
                      ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onbordData.length,
                    onPageChanged: (value) {
                      setState(() {
                        _pageIndex = value;
                      });
                    },
                    itemBuilder: (context, index) => OnbordingContent(
                      istack:index==0? true:false,
                      title: _onbordData[index].title,
                      description: _onbordData[index].description,
                      image: (Theme.of(context).brightness == Brightness.dark &&
                              _onbordData[index].imageDarkTheme != null)
                          ? _onbordData[index].imageDarkTheme!
                          : _onbordData[index].image,
                      isTextOnTop: index.isOdd,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    _onbordData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: defaultPadding / 4),
                      child: DotIndicator(isActive: index == _pageIndex),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageIndex < _onbordData.length - 1) {
                          _pageController.nextPage(
                              curve: Curves.ease, duration: defaultDuration);
                        } else {
                          Navigator.pushNamed(
                              context, notificationPermissionScreenRoute);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        
                        shape: const CircleBorder(),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Arrow - Right.svg",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}

class Onbord {
  final String image, title, description;
  final String? imageDarkTheme;

  Onbord({
    required this.image,
    required this.title,
    this.description = "",
    this.imageDarkTheme,
  });
}
