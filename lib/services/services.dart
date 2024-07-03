import 'package:dio/dio.dart';
import 'package:weather_app/models/search_country_model.dart';
import 'package:weather_app/models/weather_model.dart';

class Weather {
  final dio = Dio();
  final String apiKey = "ed1f9f2df0d1452b8ed203621240603";
  final String baseURL = "https://api.weatherapi.com/v1";

  Future<List<SearchCountryModel>> searchCountryModel(String country) async {
    final List<SearchCountryModel> searchList = [];

    try {
      final response =
          await dio.get('$baseURL/search.json?key=$apiKey&q=$country');
      for (var element in response.data) {
        SearchCountryModel searchCountryModel =
            SearchCountryModel.fromjson(element);
        searchList.add(searchCountryModel);
      }
      return searchList;
    } on DioException catch (e) {
      final errorMessage = e.response?.data["error"]["message"] ??
          "opps there was an error, try later";
      throw (errorMessage);
    } catch (e) {
      throw ("opps there was an error, try later");
    }
  }

  Future<WeatherModel> getWeather(String country) async {
    try {
      final Response response =
          await dio.get("$baseURL/forecast.json?key=$apiKey&q=$country&days=3");

      WeatherModel weatherModel = WeatherModel.fromjson(response.data);
      return weatherModel;
    } on DioException catch (e) {
      final errorMessage = e.response?.data["error"]["message"] ??
          "opps there was an error, try later";
      throw (errorMessage);
    } catch (e) {
      throw ("opps there was an error , try later");
    }
  }

  // Future<WeatherModel> getWeatherOfCurrentLocation(
  //     {required String long, required String lati}) async {
  //   try {
  //     final Response response = await dio
  //         .get("$baseURL/forecast.json?key=$apiKey&q=$lati,$long&days=3");
  //     WeatherModel weatherModel = WeatherModel.fromjson(response);
  //     return weatherModel;
  //   } on DioException catch (e) {
  //     final errorMessage = e.response?.data["error"]["message"] ??
  //         "opps there was an error, try later";
  //     throw (errorMessage);
  //   } catch (e) {
  //     throw ("opps there was an error , try later");
  //   }
  // }
}
