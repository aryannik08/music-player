import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/storage/storage_service.dart';
import 'presentation/style/theme.dart' hide ThemeController;
import 'presentation/style/theme_controller.dart';
import 'presentation/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initServices().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Obx(() {
      return AnimatedTheme(
        curve: Curves.bounceIn,
        data: themeController.themeMode.value == ThemeMode.dark
            ? AppTheme.darkTheme
            : themeController.themeMode.value == ThemeMode.light
            ? AppTheme.lightTheme
            : (MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? AppTheme.darkTheme
                  : AppTheme.lightTheme), // Handle system theme
        duration: const Duration(
          milliseconds: 500,
        ), // Adjust duration as needed
        child: GetMaterialApp(
          title: 'GetX Flutter App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme, // Provide a base light theme
          darkTheme: AppTheme.darkTheme, // Provide a base dark theme
          themeMode: themeController
              .themeMode
              .value, // This is still necessary for GetX to manage internal theme
          initialRoute: AppRoutes.splash,
          getPages: AppRoutes.routes,
        ),
      );
    });
  }
}

Future<void> _initServices() async {
  await GetStorage.init('app_storage');
  Get.put(StorageService(), permanent: true);
  Get.put(ThemeController());
}
