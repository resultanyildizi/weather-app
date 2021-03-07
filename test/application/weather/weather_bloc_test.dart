import 'dart:convert';
import 'dart:math';

import 'package:bloc_example_weather_repository/application/weather/weather_bloc.dart';
import 'package:bloc_example_weather_repository/domain/weather/weather.dart';
import 'package:bloc_example_weather_repository/domain/weather/weather_failure.dart';
import 'package:bloc_example_weather_repository/helpers/random_temperature_generator/random_tempearture_generator.dart';
import 'package:bloc_example_weather_repository/infrastructure/weather/fake_weather_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/fixture_reader.dart';
import '../../infrastructure/weather/fake_weather_repository_test.dart';

class MockFakeWeatherRepository extends Mock implements FakeWeatherRepository {}

main() {
  MockFakeWeatherRepository mockFakeWeatherRepository;
  List<Weather> tWeathers = (jsonDecode(readFixture("weathers.json")) as List)
      .map(
          (tWeatherMap) => Weather.fromMap(tWeatherMap as Map<String, dynamic>))
      .toList();

  List<Weather> tDetailedWeathers =
      (jsonDecode(readFixture("weathers-detailed.json")) as List)
          .map((tWeatherMap) =>
              Weather.fromMap(tWeatherMap as Map<String, dynamic>))
          .toList();

  setUpAll(() {
    mockFakeWeatherRepository = MockFakeWeatherRepository();
  });
  group('WeatherBloc', () {
    blocTest(
      'should emit [] when nothing is added and the state should be WeatherInitial',
      build: () => WeatherBloc(mockFakeWeatherRepository),
      expect: [],
      verify: (bloc) {
        expect(bloc.state, equals(WeatherInitial()));
      },
    );

    group('when WeatherFetched added', () {
      blocTest('should call mockFakeWeatherRepository.fetchWeather() method',
          build: () => WeatherBloc(mockFakeWeatherRepository),
          act: (bloc) => bloc.add(WeatherFetched(
              tWeathers[Random().nextInt((tWeathers.length))].city)),
          verify: (bloc) {
            verify(mockFakeWeatherRepository.fetchWeather(any));
          });

      group('when fetching is successfull', () {
        for (final tWeather in tWeathers) {
          blocTest(
            'should emit [WeatherLoading(), WeatherLoaded($tWeather)] ',
            build: () {
              when(mockFakeWeatherRepository.fetchWeather(any)).thenAnswer(
                  (_) async => Right<WeatherFailure, Weather>(tWeather));
              return WeatherBloc(mockFakeWeatherRepository);
            },
            act: (bloc) => bloc.add(
              WeatherFetched(tWeather.city),
            ),
            expect: [
              WeatherLoading(),
              WeatherLoaded(weather: tWeather),
            ],
          );
        }
      });

      group('when an error occurs', () {
        for (final tWeather in tWeathers) {
          blocTest(
            'should emit [WeatherLoading(), WeatherError()] ',
            build: () {
              when(mockFakeWeatherRepository.fetchWeather(any)).thenAnswer(
                  (_) async => Left<WeatherFailure, Weather>(WeatherFailure()));

              return WeatherBloc(mockFakeWeatherRepository);
            },
            act: (bloc) => bloc.add(
              WeatherFetched(tWeather.city),
            ),
            expect: [WeatherLoading(), WeatherError()],
          );
        }
      });
    });

    group('when WeatherDetailedFetched added', () {
      blocTest(
        'should call mockFakeWeatherRepository.fetchDetailedWeather() method',
        build: () => WeatherBloc(mockFakeWeatherRepository),
        act: (bloc) => bloc.add(WeatherDetailedFetched(tWeathers[0].city)),
        verify: (bloc) {
          verify(mockFakeWeatherRepository
              .fetchDetailedWeather(tWeathers[0].city));
        },
      );

      group('when fetching successfull', () {
        for (final tWeather in tDetailedWeathers) {
          blocTest(
            'should emit [WeatherLoading(), WeatherLoaded($tWeather)',
            build: () {
              when(mockFakeWeatherRepository.fetchDetailedWeather(any))
                  .thenAnswer(
                      (_) async => Right<WeatherFailure, Weather>(tWeather));
              return WeatherBloc(mockFakeWeatherRepository);
            },
            act: (bloc) => bloc.add(WeatherDetailedFetched(tWeathers[0].city)),
            expect: [WeatherLoading(), WeatherLoaded(weather: tWeather)],
            verify: (bloc) {
              verify(mockFakeWeatherRepository
                  .fetchDetailedWeather(tWeathers[0].city));
            },
          );
        }
      });

      group('when an error occurs', () {
        for (final tWeather in tDetailedWeathers) {
          blocTest(
            'should emit [WeatherLoading(), WeatherError()',
            build: () {
              when(mockFakeWeatherRepository.fetchDetailedWeather(any))
                  .thenAnswer((_) async =>
                      Left<WeatherFailure, Weather>(WeatherFailure()));
              return WeatherBloc(mockFakeWeatherRepository);
            },
            act: (bloc) => bloc.add(WeatherDetailedFetched(tWeathers[0].city)),
            expect: [WeatherLoading(), WeatherError()],
            verify: (bloc) {
              verify(mockFakeWeatherRepository
                  .fetchDetailedWeather(tWeathers[0].city));
            },
          );
        }
      });
    });
  });
}
