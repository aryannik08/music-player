// bottom_nav_widget.dart
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomNavWidget extends StatefulWidget {
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
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _playPauseAnimationController;

  @override
  void initState() {
    super.initState();
    _playPauseAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    if (widget.isPlay.value) {
      _playPauseAnimationController.forward();
    }
    widget.isPlay.listen((isPlaying) {
      if (isPlaying) {
        _playPauseAnimationController.forward();
      } else {
        _playPauseAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _playPauseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onContainerTap,
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
                child: widget.song != null
                    ? QueryArtworkWidget(
                        id: widget.song!.id,
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
                        onTap: widget.onContainerTap,
                        key: ValueKey(widget.song?.title ?? 'No song playing'),
                        animatedTexts: [
                          TypewriterAnimatedText(
                            widget.song?.title ?? 'No song playing',
                            textAlign: TextAlign.start,
                            textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
                        onTap: widget.onContainerTap,
                        key: ValueKey(widget.song?.artist ?? 'Unknown artist'),
                        animatedTexts: [
                          TypewriterAnimatedText(
                            textAlign: TextAlign.start,
                            widget.song?.artist ?? 'Unknown artist',
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
              child: IconButton(onPressed: widget.onPreviousTap, icon: const Icon(Icons.skip_previous)),
            ),
            Hero(
              tag: "pause_play_icon",
              child: IconButton(
                onPressed: widget.onPlayTap,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _playPauseAnimationController,
                  color: Theme.of(context).colorScheme.onSurface,

                ),
              ),
            ),
            Hero(
              tag: "next_icon",
              child: IconButton(onPressed: widget.onNextTap, icon: const Icon(Icons.skip_next)),
            ),
          ],
        ),
      ),
    );
  }
}
