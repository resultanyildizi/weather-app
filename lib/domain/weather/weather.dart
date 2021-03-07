import 'dart:convert';

import 'package:meta/meta.dart';

class Weather {
  final String city;
  final double temperatureCelsius;
  final double temperatureFahrenheit;

  Weather({
    @required this.city,
    @required this.temperatureCelsius,
    this.temperatureFahrenheit,
  });

  Weather copyWith({
    String city,
    double temperatureCelsius,
    double temperatureFarenheit,
  }) {
    return Weather(
      city: city ?? this.city,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      temperatureFahrenheit: temperatureFarenheit ?? this.temperatureFahrenheit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'temperatureCelsius': temperatureCelsius,
      'temperatureFarenheit': temperatureFahrenheit,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Weather(
      city: map['city'],
      temperatureCelsius: map['temperatureCelsius'],
      temperatureFahrenheit: map['temperatureFahrenheit'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source));

  @override
  String toString() =>
      'Weather(city: $city, temperatureCelsius: $temperatureCelsius, temperatureFarenheit: $temperatureFahrenheit)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Weather &&
        o.city == city &&
        o.temperatureCelsius == temperatureCelsius &&
        o.temperatureFahrenheit == temperatureFahrenheit;
  }

  @override
  int get hashCode =>
      city.hashCode ^
      temperatureCelsius.hashCode ^
      temperatureFahrenheit.hashCode;
}
