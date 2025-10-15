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
      builder: (controller) =>
          Scaffold(
            appBar: AppBar(
              title: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Settings',
                    textAlign: TextAlign.center,
                    cursor: "",
                    textStyle: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary),
                    speed: const Duration(milliseconds: 80),
                  ),
                ],
                totalRepeatCount: 1,
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Text("Vibration mode: ${controller.vibrationMode}"),
                    Obx(() {
                      return Switch(value: controller.vibrationMode.value, onChanged: (value) {
                        controller.changeVibrationMode(value.obs);
                      },);
                    })
                  ],
                ),
                ExpansionTile(
                  title: const Text('Vibration', style: TextStyle(fontWeight: FontWeight.bold)),
                  children: [SliderWidget(currentValue: controller.currentValue)],
                ),

              ],
            ),
          ),
    );
  }
}
