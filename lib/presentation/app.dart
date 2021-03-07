import 'package:bloc_example_weather_repository/presentation/weather/weather_page.dart';
import 'package:flutter/material.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Weather App',
      home: WeatherPage(),
    );
  }
}
