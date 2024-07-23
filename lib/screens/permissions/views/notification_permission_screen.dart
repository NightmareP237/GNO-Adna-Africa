// screens/permissions/views/notification_permission_screen.dart
import 'package:flutter/cupertino.dart';import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:adna/constants.dart';
import 'package:adna/route/route_constants.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() => _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState extends State<NotificationPermissionScreen> {
  bool _swicth =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/notification.png",
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 0,
                    child: SafeArea(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, preferredLanuageScreenRoute);
                        },
                        child: Text(
                          "Ignorer",
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  children: [
                    Text(
                      "Notification et offre de service",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: defaultPadding),
                    const Text(
                      "Acceptez de recevoir des notifications pour chaque posts et des differents offre de services !",
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.05),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultBorderRadious)),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Notification.svg",
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: defaultPadding),
                          Text(
                            "Notifications",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          CupertinoSwitch(
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState((){
                                _swicth=! _swicth;
                              });
                            },
                            value: _swicth,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, preferredLanuageScreenRoute);
                      },
                      child: const Text("Suivant"),
                    ),
                    const SizedBox(height: defaultPadding),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
