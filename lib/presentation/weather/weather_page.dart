import 'dart:math';

import 'package:bloc_example_weather_repository/application/weather/weather_bloc.dart';
import 'package:bloc_example_weather_repository/helpers/random_temperature_generator/random_tempearture_generator.dart';
import 'package:bloc_example_weather_repository/infrastructure/weather/fake_weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(
        FakeWeatherRepository.instance(
          randomTemperatureGenerator: RandomTemperatureGenerator.instance(
            random: Random(),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('Weather App')),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: BlocConsumer<WeatherBloc, WeatherState>(
            listener: (context, state) {
              if (state is WeatherError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error occured while fetching the weather information. Please try again.',
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is WeatherInitial) {
                return _buildInitial(context);
              } else if (state is WeatherLoading) {
                return _buildLoading();
              } else if (state is WeatherLoaded) {
                return _buildLoaded(state, context);
              } else {
                return _buildInitial(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Column _buildLoaded(WeatherLoaded state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state.weather.city,
          style: Theme.of(context).textTheme.headline2,
        ),
        SizedBox(height: 16.0),
        Text(
          '${state.weather.temperatureCelsius.toString()} °C',
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: 16.0),
        if (state.weather.temperatureFahrenheit == null) ...[
          ElevatedButton.icon(
            onPressed: () {
              context
                  .read<WeatherBloc>()
                  .add(WeatherDetailedFetched(state.weather.city));
            },
            icon: Icon(Icons.details_rounded),
            label: Text('Details'),
          )
        ] else ...[
          Text(
            '${state.weather.temperatureFahrenheit.toString()} °F',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
        SizedBox(height: 16.0),
        SearchField(),
      ],
    );
  }

  Column _buildLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Column _buildInitial(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Search for city 🏙',
          style: Theme.of(context).textTheme.headline4,
        ),
        Form(
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              SearchField(),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isDense: true,
      ),
      onFieldSubmitted: (value) {
        context.read<WeatherBloc>().add(WeatherFetched(value));
      },
    );
  }
}
