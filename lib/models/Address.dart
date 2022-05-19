import 'dart:convert';

import 'package:sma_frontend/models/Country.dart';

import '../api_interactions/api_functions.dart';

class Address{
  final int id;
  final String street;
  final String door;
  final String floor;
  final String room;
  final String zipCode;
  final String local;
  final String district;
  final int? countryId;
  final Country? country;

  const Address({
    required this.id,
    required this.street,
    required this.door,
    required this.floor,
    required this.room,
    required this.zipCode,
    required this.local,
    required this.district,
    this.country,
    this.countryId
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
      countryId: json['country_id']
    );
  }

  factory Address.fromJsonDetailed(Map<String, dynamic> json){
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
  static Future<Address> update(int addressId, String street, String door, String floor, String room, String zipCode, String local, String district, int countryId) async{
    var res = await ClientApi.update("addresses/$addressId",jsonEncode(<String, dynamic> {
      "street_name": street,
      "door": door,
      "floor": floor,
      "room": room,
      "zip_code": zipCode,
      "local": local,
      "district": district,
      "country_id": countryId
    }));
    return Address.fromJson(jsonDecode(res.body));
  }



}