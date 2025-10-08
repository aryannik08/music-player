import 'package:untitled1/domain/entities/weather_entity.dart';

class WeatherLocationModel extends WeatherLocationEntity {
  const WeatherLocationModel({
    required super.name,
    required super.region,
    required super.country,
    required super.lat,
    required super.lon,
    required super.tzId,
    required super.localtimeEpoch,
    required super.localtime,
  });

  factory WeatherLocationModel.fromJson(Map<String, dynamic> json) {
    return WeatherLocationModel(
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      tzId: json['tz_id'] as String,
      localtimeEpoch: (json['localtime_epoch'] as num).toInt(),
      localtime: json['localtime'] as String,
    );
  }
}

class WeatherConditionModel extends WeatherConditionEntity {
  const WeatherConditionModel({
    required super.text,
    required super.icon,
    required super.code,
  });

  factory WeatherConditionModel.fromJson(Map<String, dynamic> json) {
    return WeatherConditionModel(
      text: json['text'] as String,
      icon: json['icon'] as String,
      code: (json['code'] as num).toInt(),
    );
  }
}

class WeatherCurrentModel extends WeatherCurrentEntity {
  const WeatherCurrentModel({
    required super.lastUpdatedEpoch,
    required super.lastUpdated,
    required super.tempC,
    required super.tempF,
    required super.isDay,
    required WeatherConditionEntity super.condition,
    required super.windMph,
    required super.windKph,
    required super.windDegree,
    required super.windDir,
    required super.pressureMb,
    required super.pressureIn,
    required super.precipMm,
    required super.precipIn,
    required super.humidity,
    required super.cloud,
    required super.feelslikeC,
    required super.feelslikeF,
    required super.windchillC,
    required super.windchillF,
    required super.heatindexC,
    required super.heatindexF,
    required super.dewpointC,
    required super.dewpointF,
    required super.visKm,
    required super.visMiles,
    required super.uv,
    required super.gustMph,
    required super.gustKph,
    required super.shortRad,
    required super.diffRad,
    required super.dni,
    required super.gti,
  });

  factory WeatherCurrentModel.fromJson(Map<String, dynamic> json) {
    return WeatherCurrentModel(
      lastUpdatedEpoch: (json['last_updated_epoch'] as num).toInt(),
      lastUpdated: json['last_updated'] as String,
      tempC: (json['temp_c'] as num).toDouble(),
      tempF: (json['temp_f'] as num).toDouble(),
      isDay: (json['is_day'] as num).toInt(),
      condition: WeatherConditionModel.fromJson(json['condition'] as Map<String, dynamic>),
      windMph: (json['wind_mph'] as num).toDouble(),
      windKph: (json['wind_kph'] as num).toDouble(),
      windDegree: (json['wind_degree'] as num).toInt(),
      windDir: json['wind_dir'] as String,
      pressureMb: (json['pressure_mb'] as num).toDouble(),
      pressureIn: (json['pressure_in'] as num).toDouble(),
      precipMm: (json['precip_mm'] as num).toDouble(),
      precipIn: (json['precip_in'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      cloud: (json['cloud'] as num).toInt(),
      feelslikeC: (json['feelslike_c'] as num).toDouble(),
      feelslikeF: (json['feelslike_f'] as num).toDouble(),
      windchillC: (json['windchill_c'] as num).toDouble(),
      windchillF: (json['windchill_f'] as num).toDouble(),
      heatindexC: (json['heatindex_c'] as num).toDouble(),
      heatindexF: (json['heatindex_f'] as num).toDouble(),
      dewpointC: (json['dewpoint_c'] as num).toDouble(),
      dewpointF: (json['dewpoint_f'] as num).toDouble(),
      visKm: (json['vis_km'] as num).toDouble(),
      visMiles: (json['vis_miles'] as num).toDouble(),
      uv: (json['uv'] as num).toDouble(),
      gustMph: (json['gust_mph'] as num).toDouble(),
      gustKph: (json['gust_kph'] as num).toDouble(),
      shortRad: (json['short_rad'] as num).toDouble(),
      diffRad: (json['diff_rad'] as num).toDouble(),
      dni: (json['dni'] as num).toDouble(),
      gti: (json['gti'] as num).toDouble(),
    );
  }
}

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required WeatherLocationEntity super.location,
    required WeatherCurrentEntity super.current,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: WeatherLocationModel.fromJson(json['location'] as Map<String, dynamic>),
      current: WeatherCurrentModel.fromJson(json['current'] as Map<String, dynamic>),
    );
  }
}


