import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/states.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/services.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitialState());

  static WeatherCubit get(context) => BlocProvider.of(context);
  String region = "Cairo";

  Future<WeatherModel> getWeather(region) async {
    WeatherModel whether = await Weather().getWeather(region);
    emit(WeatherLoadedState());
    return whether;
  }
}
