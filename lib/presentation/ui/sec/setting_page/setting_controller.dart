// song_details_dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/core/storage/storage_service.dart';
import 'package:untitled1/presentation/style/theme_controller.dart';

class SettingController extends GetxController {
  final StorageService storage = StorageService();
  final ThemeController themeController = Get.find<ThemeController>();

  late RxDouble currentValue = storage.vibValue.toDouble().obs;
  late RxBool vibrationMode = storage.vibValue == 0 ? false.obs : true.obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  @override
  void onInit() {
    super.onInit();
    _initNotification();
    requestNotificationPermission();
  }

  Future<void> _initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  changeVibrationMode(RxBool value) {
    vibrationMode.value = value.value;
  }

  backAction() {
    storage.vibValue = currentValue.value.toInt();
    Get.back();
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'sms_channel_id',
      'SMS Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }


}
