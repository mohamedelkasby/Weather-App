import 'package:weather_app/cubits/cubit.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/services.dart';

abstract class WeatherState {}

class WeatherInitialState extends WeatherState {}

// class GetSearchCountry extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  late WeatherModel weather;
  Future<void> getWeather() async {
    weather = await Weather().getWeather(WeatherCubit().region);
  }
}

class NoWeatherState extends WeatherState {}
