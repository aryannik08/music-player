// song_details_controller.dart
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/core/storage/storage_service.dart';
import 'package:untitled1/presentation/routes/app_routes.dart';
import 'dart:io';

class SettingController extends GetxController {
  final StorageService storage = StorageService();

  RxDouble currentValue = 0.0.obs;
  RxBool vibrationMode = true.obs;

  changeVibrationMode(RxBool value) {
    vibrationMode.value = value.value;
  }
}
