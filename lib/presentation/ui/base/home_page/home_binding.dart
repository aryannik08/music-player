import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/base/home_page/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
