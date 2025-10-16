import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/sec/setting_page/setting_controller.dart';
import 'package:untitled1/presentation/ui/sec/setting_page/widgets/slider_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<SettingController>(
      init: SettingController(),
      builder: (controller) => WillPopScope(
        onWillPop: () async {
          controller.backAction();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Settings',
                  textStyle: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary),
                  speed: const Duration(milliseconds: 80),
                ),
              ],
              totalRepeatCount: 1,
              displayFullTextOnTap: true,
            ),
            leading: IconButton(onPressed: () => controller.backAction(), icon: const Icon(Icons.arrow_back)),
            actions: [

              PopupMenuButton<ThemeMode>(
                tooltip: 'Theme',
                onSelected: (mode) {
                  controller.themeController.changeThemeMode(mode);
                },
                itemBuilder: (ctx) => const [
                  PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
                  PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                  PopupMenuItem(value: ThemeMode.system, child: Text('System')),
                ],
                child: Icon(Icons.color_lens_outlined),
              ),
              const SizedBox(width: 12),
            ],
          ),

          // gradient background
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary.withOpacity(0.12), theme.colorScheme.secondary.withOpacity(0.06)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // AppBar replacement with nicer layout
                  const SizedBox(height: 6),

                  // content area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // header card
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 36,
                                    backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                                    child: SvgPicture.asset(
                                      'assets/logo/logo.svg',
                                      height: 36,
                                      width: 36,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('MS Player', style: theme.textTheme.titleLarge),
                                      const SizedBox(height: 4),
                                      Text(
                                        'version 1.0.0',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      // نمونه: نمایش اطلاعات
                                      Get.snackbar('Info', 'MS Player v1.0.0', snackPosition: SnackPosition.BOTTOM);
                                    },
                                    icon: const Icon(Icons.info_outline),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Vibration setting card
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                    leading: const Icon(Icons.vibration),
                                    title: Text('Vibration', style: theme.textTheme.titleMedium),
                                    subtitle: Text(
                                      'Enable phone vibration for actions',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    trailing: Obx(() {
                                      return Switch.adaptive(
                                        value: controller.vibrationMode.value,
                                        onChanged: (value) {
                                          // send bool directly
                                          controller.changeVibrationMode(value.obs);
                                          // optional: demo notification
                                          controller.showNotification('New SMS', 'You have a new message from Aryan!');
                                        },
                                      );
                                    }),
                                  ),
                                  // sensitivity expansion (animated visibility)
                                  Obx(() {
                                    final enabled = controller.vibrationMode.value;
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      height: enabled ? null : 0,
                                      padding: enabled
                                          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                                          : EdgeInsets.zero,
                                      child: enabled
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Vibration Sensitivity', style: theme.textTheme.bodyMedium),
                                                const SizedBox(height: 6),
                                                // pass controller.currentValue (same as before)
                                                SliderWidget(currentValue: controller.currentValue),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Theme Mode card (more visual)
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                              child: ListTile(
                                leading: const Icon(Icons.brightness_6_outlined),
                                title: Text('Theme Mode', style: theme.textTheme.titleMedium),
                                subtitle: Text('Choose app appearance', style: theme.textTheme.bodySmall),
                                trailing: Obx(() {
                                  final current = controller.themeController.themeMode.value;
                                  return DropdownButton<ThemeMode>(
                                    value: current,
                                    onChanged: (ThemeMode? newValue) {
                                      if (newValue != null) {
                                        controller.themeController.changeThemeMode(newValue);
                                      }
                                    },
                                    items: const [
                                      DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                                      DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Extra: about & actions
                          Card(
                            elevation: 0,
                            color: theme.cardColor.withOpacity(0.9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.lock_outline),
                                  title: Text('Privacy', style: theme.textTheme.bodyLarge),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    // navigate to privacy
                                    Get.snackbar('Nav', 'Open Privacy (not implemented)');
                                  },
                                ),
                                Divider(height: 1),
                                ListTile(
                                  leading: const Icon(Icons.help_outline),
                                  title: Text('Help & Feedback', style: theme.textTheme.bodyLarge),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Feedback'),
                                        content: const Text('Send feedback to the dev team.'),
                                        actions: [TextButton(onPressed: () => Get.back(), child: const Text('Close'))],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
