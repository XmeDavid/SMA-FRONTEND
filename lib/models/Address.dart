import 'package:sma_frontend/models/Country.dart';

class Address{
  final int id;
  final String street;
  final String door;
  final String floor;
  final String room;
  final String zipCode;
  final String local;
  final String district;
  final Country country;

  const Address({
    required this.id,
    required this.street,
    required this.door,
    required this.floor,
    required this.room,
    required this.zipCode,
    required this.local,
    required this.district,
    required this.country
  });

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      id: json['id'],
      street: json['street_name'],
      door: json['door'],
      floor: json['floor'],
      room: json['room'],
      zipCode: json['zip_code'],
      local: json['local'],
      district: json['district'],
      country: Country.fromJson(json['country'])
    );
  }
}