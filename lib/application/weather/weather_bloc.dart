import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../domain/weather/weather.dart';
import '../../infrastructure/weather/fake_weather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final FakeWeatherRepository _fakeWeatherRepository;
  WeatherBloc(this._fakeWeatherRepository) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is WeatherFetched) {
      yield WeatherLoading();
      await Future.delayed(Duration(seconds: 1));

      final failureOrWeather =
          await _fakeWeatherRepository.fetchWeather(event.cityName);

      yield* failureOrWeather.fold(
        (f) async* {
          yield WeatherError();
        },
        (weather) async* {
          yield WeatherLoaded(weather: weather);
        },
      );
    } else if (event is WeatherDetailedFetched) {
      yield WeatherLoading();

      final failureOrWeather =
          await _fakeWeatherRepository.fetchDetailedWeather(event.cityName);

      yield* failureOrWeather.fold(
        (f) async* {
          yield WeatherError();
        },
        (weatherDetailed) async* {
          yield WeatherLoaded(weather: weatherDetailed);
        },
      );
    }
  }
}
