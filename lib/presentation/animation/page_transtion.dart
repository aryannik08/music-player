
import 'package:flutter/material.dart';

class ScaleTranstion extends PageRouteBuilder{
  final Widget page;
  final Alignment alignment;

  ScaleTranstion(this.page,this.alignment) : super(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;

    },
    transitionDuration: const Duration(milliseconds: 2000),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      animation=CurvedAnimation(parent: animation, curve: Curves.fastLinearToSlowEaseIn,reverseCurve: Curves.fastOutSlowIn);
      return ScaleTransition(scale: animation,
        child: child,
        alignment: alignment,

      );
    },
  );

}
