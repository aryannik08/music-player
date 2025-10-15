import 'package:get_storage/get_storage.dart';

class StorageService {
  static const String _boxName = 'app_storage';
  static const String keyCity = 'city_name';
  static const String keyIsDark = 'is_dark';
  static const String keyIsFirst = 'is_first';
  static const String keyVibValue = 'vib_value';
  static const String keyThemeMode = 'theme_mode';

  final GetStorage _box = GetStorage(_boxName);

  Future<void> writeString(String key, String value) async {
    await _box.write(key, value);
  }

  String? readString(String key) {
    return _box.read<String>(key);
  }

  Future<void> saveCity(String city) async {
    await writeString(keyCity, city);
  }

  String? getCity() {
    return readString(keyCity);
  }

  bool get isDark => _box.read<bool>(keyIsDark) ?? false;

  set isDark(bool value) => _box.write(keyIsDark, value);

  bool get isFirst => _box.read<bool>(keyIsFirst) ?? true;

  set isFirst(bool value) => _box.write(keyIsFirst, value);

  int get vibValue => _box.read<int>(keyVibValue) ?? 150;

  set vibValue(int value) => _box.write(keyVibValue, value);

  String get themeMode => _box.read<String>(keyThemeMode) ?? 'system';

  set themeMode(String value) => _box.write(keyThemeMode, value);
}
