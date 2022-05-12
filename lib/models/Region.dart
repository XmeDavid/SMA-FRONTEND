import 'package:sma_frontend/models/Country.dart';

class Region{
  final int id;
  final String zipCode;
  final int country_id;
  final Country? country;
  final String local;
  final String district;

  const Region({
    required this.id,
    required this.zipCode,
    required this.country_id,
    this.country,
    required this.local,
    required this.district,
  });

  factory Region.fromJson(Map<String, dynamic> json){
    return Region(
        id: json['id'],
        zipCode: json['zip_code'],
        country_id: json['country_id'],
        local: json['local'],
        district: json['district']
    );
  }

  factory Region.fromJsonDetailed(Map<String, dynamic> json){
    return Region(
        id: json['id'],
        zipCode: json['zip_code'],
        country_id: json['country']['id'],
        local: json['local'],
        district: json['district'],
        country: Country.fromJson(json['country'])
    );
  }
}