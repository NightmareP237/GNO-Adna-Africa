// screens/discover/views/discover_with_image_screen.dart
import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:adna/constants.dart';
import 'package:adna/models/category_model.dart';
import 'package:adna/route/screen_export.dart';
import 'package:adna/screens/search/views/components/search_form.dart';

import 'components/category_with_image.dart';

class DiscoverWithImageScreen extends StatelessWidget {
  const DiscoverWithImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(child: SearchForm()),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Categories",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding / 8),
                    child: CategoryWithImage(
                      title: demoCategoriesWithImage[index].title,
                      image: demoCategoriesWithImage[index].image!,
                      press: () {
                        Navigator.pushNamed(context, subDiscoverScreenRoute);
                      },
                    ),
                  ),
                  childCount: demoCategoriesWithImage.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}