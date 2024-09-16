// entry_point.dart
import 'package:adna/screens/chat/views/home_chat.dart';
import 'package:animations/animations.dart';
import 'package:adna/market-place.dart';
import 'package:adna/post-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:adna/screens/checkout/views/empty_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/screen_export.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final List _pages = const [
    HomeScreen(),
    FavoriteScreen(),
    PostPageScreen(),
    // EmptyCartScreen(), // if Cart is empty
    HomeChat(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
            color ??
                Theme.of(context).iconTheme.color!.withOpacity(
                    Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
            BlendMode.srcIn),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // pinned: true,
        // floating: true,
        // snap: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 26),
          child: Image.asset(
            'assets/images/adn.png',
            height: MediaQuery.of(context).size.height / 3,
            colorBlendMode: BlendMode.clear,
          ),
        ),
        //  SvgPicture.asset(
        //   "assets/logo/Shoplon.svg",
        //   colorFilter: ColorFilter.mode(
        //       Theme.of(context).iconTheme.color!, BlendMode.srcIn),
        //   height: 20,
        //   width: 100,
        // ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, notificationsScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Notification.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
        ],
      ),
      // body: _pages[_currentIndex],
      body: PageTransitionSwitcher(
        duration: defaultDuration,
        transitionBuilder: (child, animation, secondAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF101015),
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: TextStyle(color: primaryColor),
          selectedFontSize: 12,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
              activeIcon: Icon(Icons.home, color: primaryColor),
              label: "Accueil",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
              activeIcon: Icon(Icons.store, color: primaryColor),
              label: "Market Place",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
              activeIcon: Icon(Icons.add_box_outlined, color: primaryColor),
              label: "Publication",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_rounded,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
              activeIcon: Icon(Icons.message_rounded, color: primaryColor),
              label: "Message",
            ),
            BottomNavigationBarItem(
              icon: (FirebaseAuth.instance.currentUser!.isAnonymous)
                  ? Icon(Icons.person,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white)
                  : Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.2, color: primaryColor),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage((FirebaseAuth
                                              .instance.currentUser!.photoURL ==
                                          null ||
                                      FirebaseAuth.instance.currentUser!
                                          .photoURL!.isEmpty)
                                  ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                  : FirebaseAuth
                                      .instance.currentUser!.photoURL!))),
                    ),
              activeIcon:(FirebaseAuth.instance.currentUser!.isAnonymous)
                  ? Icon(Icons.person,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white)
                  : Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.2, color: primaryColor),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                              image: NetworkImage((FirebaseAuth
                                              .instance.currentUser!.photoURL ==
                                          null ||
                                      FirebaseAuth.instance.currentUser!
                                          .photoURL!.isEmpty)
                                  ? "https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png"
                                  : FirebaseAuth
                                      .instance.currentUser!.photoURL!))),
                    ),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}
