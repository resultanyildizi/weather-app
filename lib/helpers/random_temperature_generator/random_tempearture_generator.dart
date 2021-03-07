import 'dart:math';

import '../../infrastructure/weather/fake_weather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RandomTemperatureGenerator {
  final Random _random;

  static RandomTemperatureGenerator _instance;

  factory RandomTemperatureGenerator.instance({@required Random random}) {
    if (_instance != null) {
      return _instance;
    } else {
      return RandomTemperatureGenerator._(random);
    }
  }

  RandomTemperatureGenerator._(this._random);

  /// Throws [GeneratorException]
  double generate() {
    if (_random.nextDouble() <= 0.7) {
      return 20 +
          _random.nextInt(15) +
          double.parse(_random.nextDouble().toStringAsFixed(2));
    } else {
      throw GeneratorException();
    }
  }
}

class GeneratorException extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}
