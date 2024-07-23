// screens/chat/views/components/support_person_info.dart
import 'package:adna/constants.dart';
import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:adna/components/chat_active_dot.dart';
import 'package:adna/components/network_image_with_loader.dart';

class SupportPersonInfo extends StatelessWidget {
  const SupportPersonInfo({
    super.key,
    required this.image,
    required this.name,
    required this.isActive,
    required this.isConnected,
    this.isTyping = false,
  });

  final String image, name;
  final bool isActive, isConnected, isTyping;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      color: Theme.of(context).iconTheme.color!.withOpacity(0.05),
      borderRadius: BorderRadius.circular(defaultBorderRadious),
      ),
      child: ListTile(
        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Theme.of(context).iconTheme.color,),
        title: Row(
          
          children: [
            Text("$name"),
            if (isConnected && !isTyping) const Text(" is connected",style: TextStyle(color: successColor),),
            if (isConnected && isTyping) const Text("typing..."),
          ],
        ),
        minLeadingWidth: 24,
        leading: CircleAvatar(
          radius: 12,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              NetworkImageWithLoader(
                image,
                radius: 40,
              ),
              if (isActive)
                const Positioned(
                  right: -4,
                  top: -4,
                  child: ChatActiveDot(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
