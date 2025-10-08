import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/storage/storage_service.dart';
import 'presentation/style/theme.dart';
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
    final StorageService storage = StorageService();
    return GetMaterialApp(
      title: 'GetX Flutter App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storage.isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}

Future<void> _initServices() async {
  await GetStorage.init('app_storage');
  Get.put(ThemeController());
  Get.put(StorageService(), permanent: true);
}
