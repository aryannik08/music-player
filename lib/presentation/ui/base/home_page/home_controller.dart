// song_details_controller.dart
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled1/presentation/routes/app_routes.dart';

class HomeController extends GetxController {
  final RxList<SongModel> songs = <SongModel>[].obs;
  final RxBool loading = false.obs;
  final RxInt currentIndex = (-1).obs;
  final RxBool isPlaying = false.obs;
  final RxBool isExpanded = false.obs;
  final RxBool isRepeating = false.obs; // Add this line
  final RxBool isShuffling = false.obs; // Add this line

  late final OnAudioQuery audioQuery;
  late final AudioPlayer audioPlayer;
  ConcatenatingAudioSource? _playlist;

  @override
  void onInit() {
    super.onInit();
    audioQuery = OnAudioQuery();
    audioPlayer = AudioPlayer();

    // همگام‌سازی وضعیت پخش
    audioPlayer.playingStream.listen((playing) {
      isPlaying.value = playing;
    });

    // همگام‌سازی ایندکس جاری
    audioPlayer.currentIndexStream.listen((idx) {
      currentIndex.value = idx ?? -1;
    });

    audioPlayer.setShuffleModeEnabled(isShuffling.value);
    audioPlayer.setLoopMode(isRepeating.value ? LoopMode.one : LoopMode.off);

    // رسیدگی به اتمام پخش برای رفتن به آهنگ بعدی یا توقف
    audioPlayer.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        if (isRepeating.value) {
          await audioPlayer.seek(Duration.zero, index: currentIndex.value);
          await audioPlayer.play();
        } else if (audioPlayer.hasNext) {
          await audioPlayer.seekToNext();
          await audioPlayer.play();
        } else {
          // اگر انتهای لیست رسیدیم، پخش را متوقف کن
          isPlaying.value = false;
        }
      }
    });

    loadSongs();
  }

  Future<void> loadSongs() async {
    loading.value = true;

    // درخواست دسترسی (on_audio_query یک متد helper دارد)
    bool perm = await audioQuery.permissionsRequest();
    if (!perm) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        loading.value = false;
        return;
      }
    }

    final List<SongModel> q = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    songs.assignAll(q);

    // ساخت playlist برای just_audio
    if (songs.isNotEmpty) {
      final sources = songs
          .map(
            (s) => AudioSource.uri(
              Uri.file(s.data),
              tag: {'title': s.title, 'artist': s.artist ?? '', 'id': s.id},
            ),
          )
          .toList();

      _playlist = ConcatenatingAudioSource(children: sources);

      try {
        // اگر قبلاً ست نشده یا می‌خواهیم دوباره بروزرسانی کنیم
        await audioPlayer.setAudioSource(_playlist!);
        if (isShuffling.value) {
          await audioPlayer.shuffle();
        }
      } catch (e) {
        // ممکنه بعضی uri ها مشکل داشته باشن — برای کاربر نوتیف بده
        Get.snackbar('خطا', 'بارگذاری لیست پخش ممکن نیست');
      }
    }

    loading.value = false;
  }

  Future<void> playAt(int index) async {
    if (index < 0 || index >= songs.length) return;

    try {
      // اگر playlist هنوز ساخته نشده، بسازش
      if (_playlist == null) {
        final sources = songs
            .map((s) => AudioSource.uri(Uri.file(s.data)))
            .toList();
        _playlist = ConcatenatingAudioSource(children: sources);
        await audioPlayer.setAudioSource(_playlist!, initialIndex: index);
      } else {
        // seek to index and start from beginning of that item
        await audioPlayer.seek(Duration.zero, index: index);
      }
      if (isShuffling.value) {
        await audioPlayer.shuffle();
      }

      await audioPlayer.play();
    } catch (e) {
      Get.snackbar('خطا', 'پخش فایل ممکن نیست');
    }
  }

  Future<void> resume() async {
    // اگر منبع ست نشده و آهنگ داریم، منبع را ست کن
    if (audioPlayer.audioSource == null && _playlist != null) {
      await audioPlayer.setAudioSource(
        _playlist!,
        initialIndex: currentIndex.value == -1 ? 0 : currentIndex.value,
      );
    } else if (audioPlayer.audioSource != null &&
        audioPlayer.playerState.processingState == ProcessingState.completed) {
      // اگر آهنگ قبلاً تمام شده و منبع ست شده بود، آهنگ را از ابتدا پخش کن.
      await audioPlayer.seek(
        Duration.zero,
        index: currentIndex.value == -1 ? 0 : currentIndex.value,
      );
    }
    await audioPlayer.play();
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    currentIndex.value = -1;
    isPlaying.value = false;
  }

  Future<void> next() async {
    if (audioPlayer.hasNext) {
      await audioPlayer.seekToNext();
      await audioPlayer.play();
    }
  }

  Future<void> previous() async {
    if (audioPlayer.hasPrevious) {
      await audioPlayer.seekToPrevious();
      await audioPlayer.play();
    } else {
      // اگر قبلی وجود نداشت، به ابتدای همین آهنگ برو
      await audioPlayer.seek(Duration.zero);
    }
  }

  void toggleRepeat() {
    isRepeating.value = !isRepeating.value;
    audioPlayer.setLoopMode(isRepeating.value ? LoopMode.one : LoopMode.off);
  }

  void toggleShuffle() {
    isShuffling.value = !isShuffling.value;
    audioPlayer.setShuffleModeEnabled(isShuffling.value);
    if (isShuffling.value) {
      audioPlayer.shuffle();
    }
  }

  nextPage() {
    Get.toNamed(AppRoutes.songDetails, arguments: [songs[currentIndex.value]]);
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
