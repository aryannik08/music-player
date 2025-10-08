import 'dart:async';
import 'package:flutter/cupertino.dart';

enum Direction {
  vertical,
  horizontal
}

class SlideFadeTransition extends StatefulWidget {
  final Widget child;
  final Curve curve;
  final Direction direction;
  final Duration delayStart;
  final Duration animationDuration;

  const SlideFadeTransition(
      {Key? key, required this.child, this.curve = Curves
          .easeIn, this.direction = Direction
          .vertical, this.delayStart = const Duration(seconds: 0),
        this.animationDuration = const Duration(milliseconds: 800)
      }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SlideFadeTransitionState();
}

class SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  // final LocalStorageService pref = Get.find<LocalStorageService>();


  late Animation<Offset> animationSlide;
  late AnimationController animationController;
  late Animation<double> animationFade;

  @override
  void initState() {
    // offset  = pref.isPersianMode   ? 5 : -5; // todo fix pref

    super.initState();
    animationController =
        AnimationController(vsync: this, duration: widget.animationDuration);
    if (widget.direction == Direction.vertical) {
      animationSlide =
          Tween<Offset>(begin: const Offset(0, 5), end: const Offset(0, 0))
              .animate(CurvedAnimation(
              parent: animationController, curve: widget.curve));
    } else {
      animationSlide =
          Tween<Offset>(begin: Offset(offset, 0), end: const Offset(0, 0))
              .animate(CurvedAnimation(
              parent: animationController, curve: widget.curve));
    }
    animationFade = Tween<double>(begin: -1.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: widget.curve));
    Timer(widget.delayStart,(){
      animationController.forward();
    }) ;
  }

  double offset = 1.0;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animationFade,

      child: SlideTransition(
        position: animationSlide,
        child: widget.child,

      ),
    );
  }

}