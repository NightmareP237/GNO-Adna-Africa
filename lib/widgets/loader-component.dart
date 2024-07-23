// widgets/loader-component.dart
import 'package:adna/constants.dart';
import 'package:flutter/material.dart';
class LoadingComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).textTheme.labelSmall!.color!.withOpacity(.25),
      child: Center(
          child: Container(
        height: MediaQuery.of(context).size.height / 7,
        width:  MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultBorderRadious),
            color:  Theme.of(context).canvasColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: CircularProgressIndicator(color: primaryColor,strokeWidth: 2.5,),
             ),
             Text("Chargement...",style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).textTheme.labelSmall!.color,
              fontSize: 12
             ),)
            ],
          ),
        ),
      )),
    );
  }
}
