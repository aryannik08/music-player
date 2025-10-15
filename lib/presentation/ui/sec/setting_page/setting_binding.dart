import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/sec/setting_page/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(() => SettingController());
  }
}
