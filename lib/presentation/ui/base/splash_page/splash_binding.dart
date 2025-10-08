import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/base/splash_page/splash_controller.dart';


class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
