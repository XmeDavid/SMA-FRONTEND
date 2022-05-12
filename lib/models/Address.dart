import 'package:sma_frontend/models/Region.dart';

class Address{
  final int id;
  final String street;
  final String door;
  final String floor;
  final String room;
  final int regionId;
  final Region? region;

  const Address({
    required this.id,
    required this.street,
    required this.door,
    required this.floor,
    required this.room,
    required this.regionId,
    this.region
  });

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
        id: json['id'],
        street: json['street_name'],
        door: json['door'],
        floor: json['floor'],
        room: json['room'],
        regionId: json['region_id']
    );
  }

  factory Address.fromJsonDetailed(Map<String, dynamic> json){
    return Address(
        id: json['id'],
        street: json['street_name'],
        door: json['door'],
        floor: json['floor'],
        room: json['room'],
        regionId: json['region']['id'],
        region: Region.fromJsonDetailed(json['region'])
    );
  }
}