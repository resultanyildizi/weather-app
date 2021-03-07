import '../../domain/weather/i_weather_repository.dart';
import '../../domain/weather/weather.dart';
import '../../domain/weather/weather_failure.dart';
import '../../helpers/random_temperature_generator/random_tempearture_generator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class FakeWeatherRepository implements IWeatherRepository {
  static FakeWeatherRepository _instance;

  final RandomTemperatureGenerator _randTempGen;
  double _cachedCelsius;

  factory FakeWeatherRepository.instance({
    @required RandomTemperatureGenerator randomTemperatureGenerator,
  }) {
    if (_instance != null)
      return _instance;
    else {
      return FakeWeatherRepository._(randomTemperatureGenerator);
    }
  }

  FakeWeatherRepository._(this._randTempGen);

  @visibleForTesting
  double get cachedCelsius => _cachedCelsius;

  @override
  Future<Either<WeatherFailure, Weather>> fetchWeather(String cityName) async {
    try {
      _cachedCelsius = _randTempGen.generate();
      final weather =
          Weather(city: cityName, temperatureCelsius: _cachedCelsius);
      return Right<WeatherFailure, Weather>(weather);
    } on GeneratorException catch (_) {
      return Left<WeatherFailure, Weather>(WeatherFailure());
    }
  }

  @override
  Future<Either<WeatherFailure, Weather>> fetchDetailedWeather(
    String cityName,
  ) async {
    try {
      assert(_cachedCelsius != null);
      final weather = Weather(
        city: cityName,
        temperatureCelsius: _cachedCelsius,
        temperatureFahrenheit:
            double.parse((_cachedCelsius * 1.8 + 32).toStringAsFixed(2)),
      );
      return Right<WeatherFailure, Weather>(weather);
    } on AssertionError catch (_) {
      return Left<WeatherFailure, Weather>(WeatherFailure());
    }
  }
}
