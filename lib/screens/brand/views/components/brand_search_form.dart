// screens/brand/views/components/brand_search_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adna/theme/input_decoration_theme.dart';

class BrandSearchForm extends StatelessWidget {
  const BrandSearchForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        onSaved: (newValue) {},
        validator: (value) {
          return null;
        },
        decoration: InputDecoration(
          hintText: "Recherchez tout ce que vous souhaiter...",
          filled: false,
          border: secodaryOutlineInputBorder(context),
          enabledBorder: secodaryOutlineInputBorder(context),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
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
    );
  }
}
