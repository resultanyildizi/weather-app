part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherFetched extends WeatherEvent {
  final String cityName;

  WeatherFetched(this.cityName);
}

class WeatherDetailedFetched extends WeatherEvent {
  final String cityName;

  WeatherDetailedFetched(this.cityName);
}
