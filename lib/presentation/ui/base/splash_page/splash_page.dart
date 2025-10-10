import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/base/splash_page/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
                Hero(
                  tag: "app_logo",
                  child: SvgPicture.asset(
                    'assets/logo/logo.svg',
                    color: theme.colorScheme.onSurface,
                    width: 250,
                    height: 250,
                  ),
                ),
                SizedBox(height: Get.height * 0.1),
                Text('Welcome to MS Player App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                Spacer(),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Welcome to your ultimate music experience',
                      textAlign: TextAlign.center,

                      textStyle: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
                      speed: const Duration(milliseconds: 80),
                    ),
                  ],
                  onFinished: () {
                    controller.nextPage();
                  },
                  totalRepeatCount: 1,
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
