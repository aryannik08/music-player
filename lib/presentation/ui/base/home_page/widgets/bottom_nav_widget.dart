// bottom_nav_widget.dart
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomNavWidget extends StatelessWidget {
  final RxBool isPlay;
  final VoidCallback onContainerTap;
  final VoidCallback onPlayTap;
  final VoidCallback onNextTap;
  final VoidCallback onPreviousTap;
  final SongModel? song;

  const BottomNavWidget({
    super.key,
    required this.isPlay,
    required this.onPlayTap,
    this.song,
    required this.onNextTap,
    required this.onPreviousTap,
    required this.onContainerTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onContainerTap,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: Get.width,
        height: 70,
        color: theme.colorScheme.primaryContainer,
        child: Row(
          children: [
            Hero(
              tag: "song_artwork",
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(shape: BoxShape.circle),
                // shadowColor: Colors.transparent,
                child: song != null
                    ? QueryArtworkWidget(
                        id: song!.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(Icons.music_note),
                      )
                    : const Icon(Icons.music_note),
              ),
            ),

            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "song_name",
                    child: Material(
                      type: MaterialType.transparency,
                      child: AnimatedTextKit(
                        onTap: onContainerTap,
                        key: ValueKey(song?.title ?? 'No song playing'),
                        animatedTexts: [
                          TypewriterAnimatedText(
                            song?.title ?? 'No song playing',
                            textAlign: TextAlign.start,
                            textStyle: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            speed: const Duration(milliseconds: 70),
                          ),
                        ],
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                    ),
                  ),

                  Hero(
                    tag: "artist_name",
                    child: Material(
                      type: MaterialType.transparency,
                      child: AnimatedTextKit(
                        onTap: onContainerTap,
                        key: ValueKey(song?.artist ?? 'Unknown artist'),
                        animatedTexts: [
                          TypewriterAnimatedText(
                            textAlign: TextAlign.start,
                            song?.artist ?? 'Unknown artist',
                            textStyle: const TextStyle(fontSize: 12),
                            speed: const Duration(milliseconds: 70),
                          ),
                        ],
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Hero(
              tag: "pre_icon",
              child: IconButton(onPressed: onPreviousTap, icon: const Icon(Icons.skip_previous)),
            ),
            Obx(() {
              return Hero(
                tag: "pause_play_icon",
                child: IconButton(
                  onPressed: onPlayTap,
                  icon: isPlay.value ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                ),
              );
            }),
            Hero(
              tag: "next_icon",
              child: IconButton(onPressed: onNextTap, icon: const Icon(Icons.skip_next)),
            ),
          ],
        ),
      ),
    );
  }
}
