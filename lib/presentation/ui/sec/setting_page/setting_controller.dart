// song_details_dart
import 'package:get/get.dart';
import 'package:untitled1/core/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/presentation/style/theme_controller.dart';

class SettingController extends GetxController {
  final StorageService storage = StorageService();
  final ThemeController themeController = Get.find<ThemeController>();

  late RxDouble currentValue = storage.vibValue.toDouble().obs;
  late RxBool vibrationMode = storage.vibValue == 0 ? false.obs : true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  changeVibrationMode(RxBool value) {
    vibrationMode.value = value.value;
  }

  backAction() {
    storage.vibValue = currentValue.value.toInt();
    Get.back();
  }
}
