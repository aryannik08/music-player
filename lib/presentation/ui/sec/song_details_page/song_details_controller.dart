// song_details_controller.dart
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../../base/home_page/home_controller.dart';

class SongDetailsController extends GetxController with GetSingleTickerProviderStateMixin {
  SongModel? songModel;
  RxDouble currentValue = 0.0.obs;
  final homeController = Get.find<HomeController>();
  RxBool showTimeText = false.obs;
  RxDouble nextRotation = 0.0.obs;
  RxDouble preRotation = 0.0.obs;

  late final AnimationController playPauseAnimationController;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is List) {
      final args = Get.arguments;
      songModel = args[0] as SongModel;
    }

    playPauseAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    if (homeController.isPlaying.value) {
      playPauseAnimationController.forward();
    }

    homeController.isPlaying.listen((isPlaying) {
      if (isPlaying) {
        playPauseAnimationController.forward();
      } else {
        playPauseAnimationController.reverse();
      }
    });
  }
}
