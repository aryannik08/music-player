import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  nextPage() async {
    await Future.delayed(Duration(seconds: 3));
    Get.offNamed(AppRoutes.home);
  }


  @override
  void onInit() async {
    super.onInit();
    await nextPage();
  }
}
