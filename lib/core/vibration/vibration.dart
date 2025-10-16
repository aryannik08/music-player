import 'package:vibration/vibration.dart';

class AppVibration {

  Future<void> vibrationAction(int vibValue) async {
    if (vibValue > 0) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(pattern: [0, 50, 0, 0], intensities: [0, vibValue, 0, 0],);
      }
    }
  }
}
