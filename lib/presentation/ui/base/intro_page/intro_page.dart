import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'intro_controller.dart';

class IntroPage extends GetView<IntroController> {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<IntroController>(
      init: IntroController(),
      builder: (controller) => Scaffold(
        body: Column(
          children: [
            SizedBox(height: Get.height * 0.3),
            Center(
              child: Hero(
                tag: "app_logo",
                child: SvgPicture.asset(
                  'assets/logo/logo.svg',
                  color: theme.colorScheme.onSurface,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            SizedBox(height: 50),
            Text('Music Player', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Feel the rhythm. Live the music.',
                  textStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                  speed: const Duration(milliseconds: 80),
                ),
                FadeAnimatedText(
                  'Your world, your sound.',
                  textStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                  duration: const Duration(seconds: 3),
                ),
              ],
              onFinished: () {
                controller.nextPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
