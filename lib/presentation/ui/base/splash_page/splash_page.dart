import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/base/splash_page/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder(
      init: SplashController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
          bottom: true,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Icon(Icons.flutter_dash, size: 100, color: Colors.blue),
                SizedBox(height: 20),
                Text('Welcome to GetX Flutter App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Your project structure is ready!', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Spacer(),
                CircularProgressIndicator(),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
