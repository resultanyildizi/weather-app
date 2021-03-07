import 'dart:math';

import 'package:bloc_example_weather_repository/helpers/random_temperature_generator/random_tempearture_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRandom extends Mock implements Random {}

main() {
  RandomTemperatureGenerator randomTemperatureGenerator;
  MockRandom mockRandom;
  Random random;

  setUp(() {
    mockRandom = MockRandom();
    random = Random();
    randomTemperatureGenerator =
        RandomTemperatureGenerator.instance(random: mockRandom);
  });
  group("RandomTemperatureGenerator", () {
    group("generate", () {
      group('if chance is below 0.7', () {
        test(
          'should return a [double] between 20.0 and 36.0',
          () async {
            when(mockRandom.nextDouble()).thenReturn(0.5);
            when(mockRandom.nextInt(15)).thenReturn(random.nextInt(15));
            for (int i = 0; i < 50; i++) {
              final result = randomTemperatureGenerator.generate();
              // assert
              expect(result is double && result > 20 && result <= 36.0, true);
            }
          },
        );
        test(
          'should return a [double] has 2 fractional digits',
          () async {
            double fraction = random.nextDouble();
            if (fraction >= 0.7) fraction = 0.6987654;

            when(mockRandom.nextDouble()).thenReturn(fraction);
            when(mockRandom.nextInt(15)).thenReturn(random.nextInt(15));
            for (int i = 0; i < 50; i++) {
              final result = randomTemperatureGenerator.generate();
              // assert
              final expected = result - double.parse(result.toStringAsFixed(2));
              expect(expected, 0.0);
            }
          },
        );
      });
      group('if chance is above 0.7', () {
        test(
          'should throw a [GenerateException]',
          () async {
            when(mockRandom.nextDouble()).thenReturn(0.8);
            for (int i = 0; i < 50; i++) {
              final call = randomTemperatureGenerator.generate;
              // assert
              expect(
                () => call(),
                throwsA(equals(GeneratorException())),
              );
            }
          },
        );
      });
    });
  });
}
