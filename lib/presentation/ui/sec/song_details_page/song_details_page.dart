// song_details_page.dart
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:untitled1/presentation/ui/sec/song_details_page/song_details_controller.dart';

import '../../../../core/vibration/vibration.dart';

class SongDetailsPage extends StatelessWidget {
  const SongDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GetBuilder<SongDetailsController>(
      init: SongDetailsController(),
      builder: (controller) {
        // Listen to the audio player's position stream to update the slider
        controller.homeController.audioPlayer.positionStream.listen((position) {
          if (controller.homeController.audioPlayer.duration != null) {
            controller.currentValue.value =
                (position.inMilliseconds.toDouble() /
                        controller.homeController.audioPlayer.duration!.inMilliseconds.toDouble())
                    .clamp(0.0, 1.0);
          }
        });

        // Listen to current index changes to update song details
        // This ensures the songModel in SongDetailsController is always up-to-date
        // with the currently playing song from HomeController.
        controller.homeController.currentIndex.listen((index) {
          if (index != -1 && index < controller.homeController.songs.length) {
            controller.songModel = controller.homeController.songs[index];
            // You might want to force an update for GetBuilder here if needed
            // controller.update();
          }
        });

        return SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  AppVibration().vibrationAction(controller.homeController.storage.vibValue);
                  Get.back();
                },
                icon: Icon(Icons.keyboard_arrow_down),
              ),
              title: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Song Details',
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
              actions: [
                // IconButton(icon: const Icon(Icons.refresh), onPressed: () => controller.loadSongs()),
              ],
            ),
            body: AnimationLimiter(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: Get.height * 0.15),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                            // shadowColor: Colors.transparent,
                            child: controller.songModel != null
                                ? Hero(
                                    tag: "song_artwork",
                                    child: Obx(() {
                                      return QueryArtworkWidget(
                                        id: controller
                                            .homeController
                                            .songs[controller.homeController.currentIndex.value]
                                            .id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Icon(Icons.music_note),
                                      );
                                    }),
                                  )
                                : const Icon(Icons.music_note),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Hero(
                      tag: "song_name",
                      child: Material(
                        type: MaterialType.transparency,
                        child: Obx(() {
                          final title =
                              controller.homeController.songs[controller.homeController.currentIndex.value].title;

                          return AnimatedTextKit(
                            key: ValueKey(title),
                            animatedTexts: [
                              TypewriterAnimatedText(
                                textAlign: TextAlign.center,
                                title,
                                textStyle: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                                speed: const Duration(milliseconds: 70),
                              ),
                            ],
                            totalRepeatCount: 1,
                            displayFullTextOnTap: true,
                            stopPauseOnTap: true,
                          );
                        }),
                      ),
                    ),

                    Hero(
                      tag: "artist_name",
                      child: Material(
                        type: MaterialType.transparency,
                        child: Obx(() {
                          final artist =
                              controller.homeController.songs[controller.homeController.currentIndex.value].artist ??
                              '';

                          return AnimatedTextKit(
                            key: ValueKey(artist),

                            animatedTexts: [
                              TypewriterAnimatedText(
                                textAlign: TextAlign.center,
                                artist.isEmpty ? 'Unknown Artist' : artist,
                                textStyle: theme.textTheme.titleSmall,
                                speed: const Duration(milliseconds: 80),
                              ),
                            ],
                            totalRepeatCount: 1,
                            pause: const Duration(milliseconds: 300),
                            displayFullTextOnTap: true,
                            stopPauseOnTap: true,
                          );
                        }),
                      ),
                    ),

                    Obx(() {
                      final position = controller.homeController.audioPlayer.position;
                      final duration = controller.homeController.audioPlayer.duration;

                      if (controller.showTimeText.value == false) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          controller.showTimeText.value = true;
                        });
                      }

                      return AnimationConfiguration.synchronized(
                        child: SlideAnimation(
                          horizontalOffset: -(Get.width * 0.99),
                          duration: const Duration(milliseconds: 1500),
                          child: FadeInAnimation(
                            child: Column(
                              children: [
                                Slider(
                                  inactiveColor: theme.colorScheme.onSurface,
                                  value: controller.currentValue.value,
                                  min: 0,
                                  max: 1,
                                  label: controller.currentValue.value.toStringAsFixed(1),
                                  onChanged: (value) async {
                                    controller.currentValue.value = value;
                                    final duration = controller.homeController.audioPlayer.duration;
                                    if (duration != null) {
                                      final seekPosition = duration * value;
                                      await controller.homeController.audioPlayer.seek(seekPosition);
                                    }
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      AnimatedOpacity(
                                        opacity: controller.showTimeText.value ? 1.0 : 0.0,
                                        duration: const Duration(milliseconds: 500),
                                        child: Text(
                                          "${position.inMinutes.remainder(60).toString().padLeft(2, '0')}:${position.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                                        ),
                                      ),

                                      AnimatedOpacity(
                                        opacity: controller.showTimeText.value ? 1.0 : 0.0,
                                        duration: const Duration(milliseconds: 500),
                                        child: Text(
                                          duration != null
                                              ? "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}"
                                              : "0:00",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(
                          () => AnimationConfiguration.synchronized(
                            child: SlideAnimation(
                              duration: Duration(milliseconds: 1000),

                              horizontalOffset: -50,
                              child: FadeInAnimation(
                                child: IconButton(
                                  onPressed: () {
                                    AppVibration().vibrationAction(controller.homeController.storage.vibValue);
                                    controller.homeController.toggleRepeat();
                                  },
                                  icon: Icon(
                                    Icons.repeat,
                                    color: controller.homeController.isRepeating.value
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Obx(() {
                          return Hero(
                            tag: "pre_icon",
                            child: AnimatedRotation(
                              turns: controller.preRotation.value,
                              duration: Duration(milliseconds: 500),
                              child: IconButton(
                                onPressed: () {
                                  AppVibration().vibrationAction(controller.homeController.storage.vibValue);
                                  controller.preRotation.value -= 1;
                                  controller.homeController.previous();
                                },
                                icon: Icon(
                                  Icons.skip_previous,
                                  color: controller.homeController.currentIndex.value == 0
                                      ? theme.colorScheme.onSurface.withOpacity(0.5)
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
                        Hero(
                          tag: "pause_play_icon",
                          child: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            radius: 30,
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                AppVibration().vibrationAction(controller.homeController.storage.vibValue);
                                if (controller.homeController.isPlaying.value) {
                                  controller.homeController.pause();
                                } else {
                                  controller.homeController.resume();
                                }
                              },
                              icon: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: controller.playPauseAnimationController,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),

                        Obx(() {
                          return AnimatedRotation(
                            turns: controller.nextRotation.value,
                            duration: Duration(milliseconds: 500),
                            child: Hero(
                              tag: "next_icon",
                              child: IconButton(
                                onPressed: () {
                                  AppVibration().vibrationAction(controller.homeController.storage.vibValue);
                                  controller.nextRotation.value += 1;
                                  controller.homeController.next();
                                },
                                icon: Icon(
                                  Icons.skip_next,
                                  color:
                                      controller.homeController.songs.length ==
                                          controller.homeController.currentIndex.value + 1
                                      ? theme.colorScheme.onSurface.withOpacity(0.5)
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
                        Obx(
                          () => AnimationConfiguration.synchronized(
                            child: SlideAnimation(
                              duration: Duration(milliseconds: 1000),
                              horizontalOffset: 50,
                              child: FadeInAnimation(
                                child: IconButton(
                                  onPressed: () {
                                    AppVibration().vibrationAction(controller.homeController.storage.vibValue);
                                    controller.homeController.toggleShuffle();
                                  },
                                  icon: Icon(
                                    Icons.shuffle,
                                    color: controller.homeController.isShuffling.value
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.05),
                    TextButton(
                      onPressed: () {
                        AppVibration().vibrationAction(controller.homeController.storage.vibValue);
                        Get.bottomSheet(
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, (1 - value) * Get.height * 0.7), // slide from bottom
                                child: Opacity(
                                  opacity: value, // fade in
                                  child: child,
                                ),
                              );
                            },
                            child: FractionallySizedBox(
                              heightFactor: 0.7,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(35),
                                    topRight: Radius.circular(35),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            'Songs List',
                                            textAlign: TextAlign.center,
                                            cursor: "",
                                            textStyle: theme.textTheme.titleLarge,
                                            speed: const Duration(milliseconds: 70),
                                          ),
                                        ],
                                        totalRepeatCount: 1,
                                        displayFullTextOnTap: true,
                                        stopPauseOnTap: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: Obx(
                                        () => ReorderableListView.builder(
                                          itemCount: controller.homeController.songs.length,
                                          itemBuilder: (context, index) {
                                            final song = controller.homeController.songs[index];
                                            return Container(
                                              key: ValueKey(song.id),
                                              decoration: BoxDecoration(
                                                border: index == controller.homeController.songs.length - 1
                                                    ? null
                                                    : const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                                              ),
                                              child: ListTile(
                                                trailing: const Icon(Icons.drag_handle),
                                                title: Text(song.title),
                                                subtitle: Text(song.artist ?? 'Unknown Artist'),
                                                onTap: () {
                                                  AppVibration().vibrationAction(controller.homeController.storage.vibValue);
                                                  controller.homeController.playAt(index);
                                                  Get.back();
                                                },
                                              ),
                                            );
                                          },
                                          onReorder: (oldIndex, newIndex) {
                                            if (oldIndex < newIndex) newIndex -= 1;
                                            final item = controller.homeController.songs.removeAt(oldIndex);
                                            controller.homeController.songs.insert(newIndex, item);
                                          },
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: Get.height * 0.07),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          isScrollControlled: true,
                          ignoreSafeArea: true,
                          backgroundColor: Colors.transparent, // برای اینکه borderRadius درست نمایش داده شود
                        );
                      },
                      child: Text("Songs List"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
