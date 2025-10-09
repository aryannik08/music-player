import 'package:get/get.dart';

import '../../../../core/storage/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {

  final StorageService storage = StorageService();

  nextPage() {
    if (storage.isFirst == true) {
      Get.offNamed(AppRoutes.intro);
    } else {
      Get.offNamed(AppRoutes.home);
    }
  }
}