import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather_states.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/services.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitialState()) {
    getWeather("cairo");
  }

  static WeatherCubit get(context) => BlocProvider.of(context);

  String region = "Cairo";

  Future<WeatherModel?> getWeather(region) async {
    emit(WeatherLoadingState());
    try {
      this.region = region;
      WeatherModel weather = await Weather().getWeather(region);
      emit(WeatherLoadedState(weatherModel: weather));
      return weather;
    } catch (e) {
      emit(WeatherFaildState());
      return null;
    }
  }

  void kkk() {
    emit(state);
  }
}
