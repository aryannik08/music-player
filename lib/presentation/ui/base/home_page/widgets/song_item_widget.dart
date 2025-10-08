// song_item_widget.dart
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongItemWidget extends StatelessWidget {
  final bool isLast;
  final int index;
  final VoidCallback onTap;
  final bool isPlaying;
  final SongModel song;

  const SongItemWidget({
    super.key,
    required this.isLast,
    required this.index,
    required this.onTap,
    required this.isPlaying,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: index != 0 ? 10 : 0,
        bottom: isLast == false ? 10 : 0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        splashColor: Colors.transparent,
        onTap: onTap,
        leading: QueryArtworkWidget(
          id: song.id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: const Icon(Icons.music_note),
        ),
        title: Text(song.title),
        subtitle: Text(song.artist ?? ''),
        trailing: isPlaying ? const Icon(Icons.equalizer) : null,
      ),
    );
  }
}
