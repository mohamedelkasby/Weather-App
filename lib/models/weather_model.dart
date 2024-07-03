class WeatherModel {
  final String region;
  final String country;
  final String lastUpdated;
  final double temp;
  final double tempFeelslike;
  final int isDay;
  final String condition;
  final String icon;
  final String nextDayDate;
  final double nextDayTemp;
  final String nextDayicon;
  final String dayAfterTomorrowDate;
  final double dayAfterTomorrowTemp;
  final String dayAfterTomorrowicon;

  WeatherModel({
    required this.region,
    required this.country,
    required this.lastUpdated,
    required this.temp,
    required this.tempFeelslike,
    required this.isDay,
    required this.condition,
    required this.icon,
    required this.nextDayDate,
    required this.nextDayTemp,
    required this.nextDayicon,
    required this.dayAfterTomorrowDate,
    required this.dayAfterTomorrowTemp,
    required this.dayAfterTomorrowicon,
  });

  factory WeatherModel.fromjson(json) {
    return WeatherModel(
      region: json["location"]["region"],
      country: json["location"]["country"],
      lastUpdated: json["current"]["last_updated"],
      temp: json["current"]["temp_c"],
      tempFeelslike: json["current"]["feelslike_c"],
      isDay: json["current"]["is_day"],
      condition: json["current"]["condition"]["text"],
      icon: json["current"]["condition"]["icon"],
      nextDayDate: json["forecast"]["forecastday"][1]["date"],
      nextDayTemp: json["forecast"]["forecastday"][1]["day"]["avgtemp_c"],
      nextDayicon: json["forecast"]["forecastday"][1]["day"]["condition"]
          ["icon"],
      dayAfterTomorrowDate: json["forecast"]["forecastday"][2]["date"],
      dayAfterTomorrowTemp: json["forecast"]["forecastday"][2]["day"]
          ["avgtemp_c"],
      dayAfterTomorrowicon: json["forecast"]["forecastday"][2]["day"]
          ["condition"]["icon"],
    );
  }
}
