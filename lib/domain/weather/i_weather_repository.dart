import 'weather.dart';
import 'weather_failure.dart';
import 'package:dartz/dartz.dart';

abstract class IWeatherRepository {
  Future<Either<WeatherFailure, Weather>> fetchWeather(String cityName);
  Future<Either<WeatherFailure, Weather>> fetchDetailedWeather(String cityName);
}
