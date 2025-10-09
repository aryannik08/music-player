
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class IntroController extends GetxController {

  nextPage() {
    Get.offNamed(AppRoutes.home);
  }
}
