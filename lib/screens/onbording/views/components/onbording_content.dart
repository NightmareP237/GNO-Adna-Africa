// screens/onbording/views/components/onbording_content.dart
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class OnbordingContent extends StatelessWidget {
  const OnbordingContent({
    super.key,
    this.isTextOnTop = false,
    this.istack = false,
    required this.title,
    required this.description,
    required this.image,
  });

  final bool isTextOnTop, istack;
  final String title, description, image;

  @override
  Widget build(BuildContext context) {
    return istack
        ? Stack(
            children: [
              Image.asset(
                image,
                height: MediaQuery.of(context).size.height / 1.6,
                width: double.infinity,
              ),
              // if (!isTextOnTop) const Spacer(),
              if (!isTextOnTop)
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.3),
                  child: const OnbordTitleDescription(
                    title: "La plateforme de mise en relation",
                    description:
                        "Bienvenue sur ADNAFRICA une solution rapide et fiable de mise en relation ici et ailleurs.",
                  ),
                ),
            ],
          )
        : Column(
            children: [
              const Spacer(),

              /// if you are using SVG then replace [Image.asset] with [SvgPicture.asset]

              // if (!isTextOnTop) const Spacer(),
              // if (!isTextOnTop)
              //   const OnbordTitleDescription(
              //     title: "La plateforme de mise en relation",
              //     description:
              //         "Bienvenue sur ADNAFRICA une solution rapide et fiable de mise en relation ici et ailleurs.",
              //   ),
              Image.asset(
                image,
                height: 250,
              ),
              if (isTextOnTop)
                OnbordTitleDescription(
                  title: title,
                  description: description,
                ),
              if (isTextOnTop) const Spacer(),

              const Spacer(),
            ],
          );
  }
}

class OnbordTitleDescription extends StatelessWidget {
  const OnbordTitleDescription({
    super.key,
    required this.title,
    required this.description,
  });

  final String title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: defaultPadding),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
