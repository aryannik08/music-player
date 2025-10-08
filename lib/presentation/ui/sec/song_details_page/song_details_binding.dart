import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/base/home_page/home_controller.dart';
import 'package:untitled1/presentation/ui/sec/song_details_page/song_details_controller.dart';

class SongDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SongDetailsController>(() => SongDetailsController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
