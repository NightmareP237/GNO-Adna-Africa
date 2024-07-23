// screens/home/views/components/categories.dart
import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adna/route/screen_export.dart';

import '../../../../constants.dart';

// For preview
class CategoryModel {
  final String name;
  final String?  route;
  final Icon svgSrc;
  final Color? col;
  

  CategoryModel({
    required this.name,
    required this.svgSrc,
    this.route,
    this.col=Colors.white,
  });
}

// End For Preview

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
List<CategoryModel> demoCategories = [

  CategoryModel(
    svgSrc: Icon(Icons.abc,color:  Theme.of(context).iconTheme.color,size: 20,),
    name: "Toutes les categories",
    col: Colors.white,
    ),
  CategoryModel(
      name: "Emploi",
      svgSrc: Icon(Icons.work_rounded,color:  Theme.of(context).iconTheme.color,size: 20,),
    col: Colors.blue,

      route: ''),
       CategoryModel(
      name: "Livraison",
      svgSrc: Icon(Icons.delivery_dining_rounded,color:  Theme.of(context).iconTheme.color,size: 20,),
    col: Colors.teal,

      route: ''), CategoryModel(
      name: "Electricien",
      svgSrc: Icon(Icons.electric_bolt_rounded,color:  Theme.of(context).iconTheme.color,size: 20,),
    col: Colors.green,

      route: ''), CategoryModel(
    col: Colors.amber,

      name: "Vehicules",
      svgSrc: Icon(Icons.drive_eta_outlined,color:  Theme.of(context).iconTheme.color,size: 20,),
      route: ''),
       CategoryModel(
      name: "Autres",
    col: Colors.transparent,

      svgSrc: Icon(Icons.more_horiz_rounded,color:  Theme.of(context).iconTheme.color,size: 20,),
      route: ''),
 
];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            demoCategories.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? defaultPadding : defaultPadding / 2,
                  right:
                      index == demoCategories.length - 1 ? defaultPadding : 0),
              child: CategoryBtn(
                category: demoCategories[index].name,
                svgSrc: demoCategories[index].svgSrc,
                col: demoCategories[index].col!,
                isActive: index == 0,
                press: () {
                  // if (demoCategories[index].route != null) {
                  //   Navigator.pushNamed(context, demoCategories[index].route!);
                  // }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBtn extends StatelessWidget {
   CategoryBtn({
    super.key,
    required this.category,
   required this.svgSrc,
    required this.isActive,
    required this.press,
    required this.col
  });

  final String category;
   Icon svgSrc;
   final Color col;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            // if (svgSrc != null)
            
                // color:
                //     isActive ? Colors.white : Theme.of(context).iconTheme.color,
            svgSrc,
            // if (svgSrc != null) 
            const SizedBox(width: defaultPadding / 2),
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(width: 8,),
            Container(width: 20,height: 20,decoration: BoxDecoration(color: col,shape: BoxShape.circle),)
          ],
        ),
      ),
    );
  }
}
