// song_details_page.dart
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:untitled1/presentation/ui/base/home_page/widgets/bottom_nav_widget.dart';
import 'package:untitled1/presentation/ui/base/home_page/widgets/song_item_widget.dart';
import 'package:untitled1/presentation/ui/base/home_page/home_controller.dart';
import '../../../style/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    ThemeData theme = Theme.of(context);
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            title:  AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'آهنگ‌های من',
                  textAlign: TextAlign.center,
                  cursor: "",
                  textStyle: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary
                  ),
                  speed: const Duration(milliseconds: 70),
                ),
              ],
              totalRepeatCount: 1,
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            actions: [
              Obx(
                () => IconButton(
                  icon: Icon(
                    themeController.isDarkMode.value
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () => themeController.toggleTheme(),
                ),
              ),
              // IconButton(icon: const Icon(Icons.refresh), onPressed: () => controller.loadSongs()),
            ],
          ),
          body: Obx(() {
            if (controller.loading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.songs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('هیچ فایلی پیدا نشد'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => controller.loadSongs(),
                      child: const Text('درخواست دسترسی دوباره'),
                    ),
                  ],
                ),
              );
            }

            return AnimationLimiter(
              child: ListView.builder(
                itemCount: controller.songs.length,
                itemBuilder: (_, i) {
                  final isLast = i == controller.songs.length - 1;
                  return Dismissible(
                    key: Key(controller.songs[i].id.toString()),
                    // Unique key for Dismissible
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await Get.defaultDialog<
                        bool // Explicitly declare the return type for clarity
                      >(
                        title: 'حذف آهنگ',
                        middleText:
                            'آیا مطمئن هستید که می‌خواهید این آهنگ را حذف کنید؟',
                        textConfirm: 'بله',
                        textCancel: 'خیر',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          Get.back(result: true);
                        },
                        onCancel: () {
                          Get.back(result: false);
                        },
                      );
                    },
                    onDismissed: (direction) async {
                      await controller.deleteSong(controller.songs[i]);
                    },
                    child: AnimationConfiguration.staggeredList(
                      position: i,
                      duration: Duration(milliseconds: 300),
                      child: SlideAnimation(
                        horizontalOffset: -50,
                        child: FadeInAnimation(
                          child: Obx(
                            () => SongItemWidget(
                              index: i,
                              isLast: isLast,
                              onTap: () {
                                // اگر همان آهنگ در حال پخش است => toggle pause/resume
                                if (controller.currentIndex.value == i) {
                                  if (controller.isPlaying.value) {
                                    controller.pause();
                                  } else {
                                    controller.resume();
                                  }
                                } else {
                                  controller.playAt(i);
                                }
                              },
                              isPlaying:
                                  (controller.currentIndex.value == i &&
                                  controller.isPlaying.value),
                              song: controller.songs[i],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          bottomNavigationBar: Obx(() {
            final currentSong = controller.currentIndex.value == -1
                ? null
                : controller.songs[controller.currentIndex.value];

            return BottomNavWidget(
              onContainerTap: () => controller.nextPage(),
              isPlay: controller.isPlaying,
              onPlayTap: () {
                if (controller.isPlaying.value) {
                  controller.pause();
                } else {
                  if (controller.currentIndex.value == -1) {
                    controller.playAt(0);
                  } else {
                    controller.resume();
                  }
                }
              },
              song: currentSong,
              onNextTap: controller.next,
              onPreviousTap: controller.previous,
            );
          }),
        ),
      ),
    );
  }
}
