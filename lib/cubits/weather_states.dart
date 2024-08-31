import 'package:weather_app/models/weather_model.dart';

abstract class WeatherState {}

class WeatherInitialState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  WeatherLoadedState({
    required this.weatherModel,
  });
  final WeatherModel weatherModel;
}

class WeatherLoadingState extends WeatherState {}

class WeatherFaildState extends WeatherState {}

class NoWeatherState extends WeatherState {}

class SearchCountryState extends WeatherState {}
