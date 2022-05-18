import 'package:sma_frontend/models/Address.dart';
import 'package:sma_frontend/models/EntityType.dart';

class Entity{
  final int id;
  final int entityTypeId;
  final EntityType? entityType;
  final String name;
  final String email;
  final String? phoneNumber;
  final int addressId;
  final Address? address;
  final String taxNumber;
  final String defaultLanguage;

  const Entity({
    required this.id,
    required this.entityTypeId,
    this.entityType,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.addressId,
    this.address,
    required this.taxNumber,
    required this.defaultLanguage,
  });


  factory Entity.dummy(){
    return const Entity(id: -1, entityTypeId: -1, email: '', name: '', addressId: -1, taxNumber: '', defaultLanguage: '');
}

  factory Entity.fromJson(Map<String, dynamic> json){
    return Entity(
      id: json['id'],
      entityTypeId: json['entities_types_id'],
      name: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      addressId:  json['adresses_id'],
      taxNumber: json['taxpayer_number'],
      defaultLanguage: json['default_language'],
    );
  }

  factory Entity.fromJsonDetailed(Map<String, dynamic> json){
    return Entity(
      id: json['id'],
      entityTypeId: json['entities_type']['id'],
      entityType: EntityType.fromJson(json['entities_type']),
      name: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      addressId:  json['address']['id'],
      address: Address.fromJsonDetailed(json['address']),
      taxNumber: json['taxpayer_number'],
      defaultLanguage: json['default_language'],
    );
  }

  @override
  String toString() {
    return "#" + id.toString() + " - " + name;
  }
}