import 'dart:convert';
import 'package:bloc_example_weather_repository/domain/weather/weather.dart';
import 'package:bloc_example_weather_repository/domain/weather/weather_failure.dart';
import 'package:bloc_example_weather_repository/helpers/random_temperature_generator/random_tempearture_generator.dart';
import 'package:bloc_example_weather_repository/infrastructure/weather/fake_weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_example_weather_repository/domain/weather/i_weather_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/fixture_reader.dart';

class MockRandomTempratureGenerator extends Mock
    implements RandomTemperatureGenerator {}

main() {
  FakeWeatherRepository fakeWeatherRepository;
  MockRandomTempratureGenerator mockRandomTempratureGenerator;
  List<Weather> tWeathers;
  List<Weather> tDetailedWeathers;

  setUp(() {
    tWeathers = (jsonDecode(readFixture("weathers.json")) as List)
        .map((tWeatherMap) =>
            Weather.fromMap(tWeatherMap as Map<String, dynamic>))
        .toList();

    tDetailedWeathers =
        (jsonDecode(readFixture("weathers-detailed.json")) as List)
            .map((tWeatherMap) =>
                Weather.fromMap(tWeatherMap as Map<String, dynamic>))
            .toList();

    mockRandomTempratureGenerator = MockRandomTempratureGenerator();
    fakeWeatherRepository = FakeWeatherRepository.instance(
        randomTemperatureGenerator: mockRandomTempratureGenerator);
  });

  group('fakeWeatherRepository', () {
    test(
      'should implement IWeatherRepository',
      () async {
        // assert
        expect(fakeWeatherRepository, isA<IWeatherRepository>());
      },
    );

    group('fetchWeather', () {
      test(
        'should return a [Future<Either<WeatherFailure, Weather>>] when called',
        () async {
          // act
          final result = fakeWeatherRepository.fetchWeather('Istanbul');
          // assert
          expect(result, isA<Future<Either<WeatherFailure, Weather>>>());
        },
      );

      test(
        'should return a [Either<WeatherFailure, Weather>] when awaited',
        () async {
          // act
          final result = await fakeWeatherRepository.fetchWeather('Istanbul');
          // assert
          expect(result, isA<Either<WeatherFailure, Weather>>());
        },
      );

      group('when executed successfully', () {
        test('should return expected [Right<WeatherFailure, Weather>(weather)]',
            () async {
          tWeathers.forEach(
            (tWeather) async {
              // arrange
              when(mockRandomTempratureGenerator.generate())
                  .thenReturn(tWeather.temperatureCelsius);
              // act
              final result =
                  await fakeWeatherRepository.fetchWeather(tWeather.city);
              // assert
              expect(result, equals(Right<WeatherFailure, Weather>(tWeather)));
            },
          );
        });
        test(
          'should cache fetched weathers temperatureCelcius value',
          () async {
            for (final tWeather in tWeathers) {
              print(tWeather.temperatureCelsius);
              // arrange
              when(mockRandomTempratureGenerator.generate())
                  .thenReturn(tWeather.temperatureCelsius);
              // act
              await fakeWeatherRepository.fetchWeather(tWeather.city);

              expect(fakeWeatherRepository.cachedCelsius,
                  tWeather.temperatureCelsius);
            }
          },
        );
        group('when there is an exception', () {
          test(
            'should return [Left<WeatherFailure, Weather>()]',
            () async {
              // arrange
              when(mockRandomTempratureGenerator.generate())
                  .thenThrow(GeneratorException());
              // act
              final result =
                  await fakeWeatherRepository.fetchWeather("Istanbul");
              // assert
              expect(result,
                  equals(Left<WeatherFailure, Weather>(WeatherFailure())));
            },
          );
        });
      });
      group('fetchDetailedWeather', () {
        test(
          'should return a [Future<Either<WeatherFailure, Weather>>] when called',
          () async {
            // act
            when(mockRandomTempratureGenerator.generate()).thenReturn(10.0);
            await fakeWeatherRepository.fetchWeather("Istanbul");
            final result =
                fakeWeatherRepository.fetchDetailedWeather('Istanbul');
            // assert
            expect(result, isA<Future<Either<WeatherFailure, Weather>>>());
          },
        );

        test(
          'should return a [Either<WeatherFailure, Weather>] when awaited',
          () async {
            // act
            when(mockRandomTempratureGenerator.generate()).thenReturn(10.0);
            await fakeWeatherRepository.fetchWeather("Istanbul");
            final result =
                await fakeWeatherRepository.fetchDetailedWeather('Istanbul');
            // assert
            expect(result, isA<Either<WeatherFailure, Weather>>());
          },
        );

        group('when cachedCelsius is null', () {
          test(
            'should return expected [Left<WeatherFailure, Weather>(weather)]',
            () async {
              for (final tWeather in tDetailedWeathers) {
                // arrange
                when(mockRandomTempratureGenerator.generate())
                    .thenReturn(tWeather.temperatureCelsius);
                // act
                final result = await fakeWeatherRepository
                    .fetchDetailedWeather(tWeather.city);
                // assert
                expect(result,
                    equals(Left<WeatherFailure, Weather>(WeatherFailure())));
              }
            },
          );
        });

        group('when executed successfully', () {
          test(
            'should return expected [Right<WeatherFailure, Weather>(weather)]',
            () async {
              for (final tWeather in tDetailedWeathers) {
                // arrange
                when(mockRandomTempratureGenerator.generate())
                    .thenReturn(tWeather.temperatureCelsius);
                // act
                await fakeWeatherRepository.fetchWeather(tWeather.city);
                final result = await fakeWeatherRepository
                    .fetchDetailedWeather(tWeather.city);
                // assert
                expect(
                    result, equals(Right<WeatherFailure, Weather>(tWeather)));
              }
            },
          );
        });
      });
    });
  });
}
