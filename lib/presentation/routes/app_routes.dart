import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/base/splash_page/splash_binding.dart';
import 'package:untitled1/presentation/ui/base/splash_page/splash_page.dart';
import 'package:untitled1/presentation/ui/sec/song_details_page/song_details_binding.dart';
import 'package:untitled1/presentation/ui/sec/song_details_page/song_details_page.dart';
import '../ui/base/home_page/home_binding.dart';
import '../ui/base/home_page/home_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String splash = '/splash';
  static const String songDetails = '/songDetails';

  static List<GetPage> routes = [

    GetPage(
      name: splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),

    ),
    GetPage(
      name: home,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn
    ),
    GetPage(
      name: songDetails,
      page: () => SongDetailsPage(),
      binding: SongDetailsBinding(),
      transition: Transition.downToUp,
      transitionDuration: Duration(
        milliseconds: 500
      )
    ),

    // Item page removed
  ];
}
