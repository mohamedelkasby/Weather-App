class SearchCountryModel {
  final String region;
  final String city;
  final String country;

  SearchCountryModel(
      {required this.region, required this.city, required this.country});

  factory SearchCountryModel.fromjson(json) {
    return SearchCountryModel(
        region: json["name"], city: json["region"], country: json["country"]);
  }
}
