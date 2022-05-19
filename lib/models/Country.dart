import 'dart:convert';

import 'package:sma_frontend/api_interactions/api_functions.dart';

class Country{
  final int id;
  final String countryName;
  final String iso;
  final String iso3;

  const Country({
  required this.id,
  required this.countryName,
  required this.iso,
  required this.iso3
  });

  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
        id: json['id'],
        countryName: json['country_name'],
        iso: json['iso'],
        iso3: json['iso3'],
    );
  }

  static Future<List<Country>> getAll() async{
    List<Country> tempCountry = <Country>[];
    var res = await ClientApi.get("countries");
    for(var countryJson in jsonDecode(res.body)){
      Country country = Country.fromJson(countryJson);
      tempCountry.add(country);
    }
    return tempCountry;
  }

  @override
  String toString() {
    return iso.toString() + " - " + countryName;
  }
}