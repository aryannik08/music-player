import 'package:get_storage/get_storage.dart';

class StorageService {
  static const String _boxName = 'app_storage';
  static const String keyCity = 'city_name';
  static const String keyIsDark = 'is_dark';

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





}


