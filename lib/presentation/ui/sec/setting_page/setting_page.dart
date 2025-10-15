import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/sec/setting_page/setting_controller.dart';
import 'package:untitled1/presentation/ui/sec/setting_page/widgets/slider_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<SettingController>(
      init: SettingController(),
      builder: (controller) => WillPopScope(
        onWillPop: () async {
          controller.backAction();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => controller.backAction(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Settings',
                  textAlign: TextAlign.center,
                  cursor: "",
                  textStyle: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  speed: const Duration(milliseconds: 80),
                ),
              ],
              totalRepeatCount: 1,
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Vibration", style: theme.textTheme.titleMedium),
                    Spacer(),
                    Obx(() {
                      return Switch(
                        value: controller.vibrationMode.value,
                        onChanged: (value) {
                          controller.changeVibrationMode(value.obs);
                        },
                      );
                    }),
                  ],
                ),
                Obx(() {
                  return ExpansionTile(
                    enabled: controller.vibrationMode.value == true,
                    tilePadding: EdgeInsets.all(0),
                    title: const Text('Vibration Sensitivity'),
                    children: [
                      SliderWidget(currentValue: controller.currentValue),
                    ],
                  );
                }),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text("Theme Mode", style: theme.textTheme.titleMedium),
                    Spacer(),
                    Obx(() {
                      return DropdownButton<ThemeMode>(
                        value: controller.themeController.themeMode.value,
                        onChanged: (ThemeMode? newValue) {
                          if (newValue != null) {
                            controller.themeController.changeThemeMode(
                              newValue,
                            );
                          }
                        },
                        items: const <DropdownMenuItem<ThemeMode>>[
                          DropdownMenuItem<ThemeMode>(
                            value: ThemeMode.light,
                            child: Text("Light"),
                          ),
                          DropdownMenuItem<ThemeMode>(
                            value: ThemeMode.dark,
                            child: Text("Dark"),
                          ),
                          DropdownMenuItem<ThemeMode>(
                            value: ThemeMode.system,
                            child: Text("System"),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
