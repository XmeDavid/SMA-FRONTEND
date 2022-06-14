import 'dart:convert';

import 'package:sma_frontend/api_interactions/api_functions.dart';
import 'package:sma_frontend/models/Address.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/paginated_model/PaginatedModel.dart';

import 'paginated_model/Meta.dart';

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

  static Future<Entity> create(int entityTypeId, String fullName, String email, String phoneNumber, String taxNumber, String defaultLanguage, String streetName, String door, int floor, String room, String local, String district, String zipCode, int countryId) async{
    var res = await ClientApi.create("entities",jsonEncode(<String, dynamic>{
      'entities_types_id': entityTypeId,
      'full_name': fullName,
      'email' : email,
      'phone_numbers' : phoneNumber,
      'taxpayer_number' : taxNumber,
      'default_language' : defaultLanguage,
      'street_name' : streetName,
      'door' : door,
      'floor' : floor,
      'room' : room,
      'local' : local,
      'district' : district,
      'zip_code' : zipCode,
      'countries_id' : countryId,
    }));
    return Entity.fromJsonDetailed(jsonDecode(res.body));
  }

  static Future<Entity> get(int id, bool detailed) async{
    var res = await ClientApi.get("entities/$id${(detailed ? "?format=detailed" : "")}");
    return detailed ? Entity.fromJsonDetailed(jsonDecode(res.body)) : Entity.fromJson(jsonDecode(res.body));
  }

  static Future<List<Entity>> getAll() async{
    var res = await ClientApi.get("entities");
    dynamic json = jsonDecode(res.body);
    List<Entity> data = <Entity>[];
    for(var entityJson in json['data']){
      Entity entity = Entity.fromJson(entityJson);
      data.add(entity);
    }
    return data;
  }

  static Future<PaginatedModel<Entity>> getPaginated(bool detailed, int paginate, int page,int filterEntityType, String search) async{
    var res = await ClientApi.get("entities?${(detailed ? "format=detailed&" : "")}paginate=$paginate&page=$page${(filterEntityType != -1 ? "&entities_types_id=$filterEntityType" : "")}${(search != "" ? "&search=$search" : "")}");
    dynamic json = jsonDecode(res.body);
    List<Entity> data = <Entity>[];
    for(var entityJson in json['data']){
      Entity entity = detailed ? Entity.fromJsonDetailed(entityJson) : Entity.fromJson(entityJson);
      data.add(entity);
    }
    return PaginatedModel(
      data: data,
      meta: Meta.fromJson(json['meta']),
    );
  }

  static Future<Entity> update(int entityTypeId, String fullName, String email, String phoneNumber, String taxNumber, String defaultLanguage) async{
    var res = await ClientApi.update("entities",jsonEncode(<String, dynamic>{
      'entities_types_id': entityTypeId,
      'full_name': fullName,
      'email' : email,
      'phone_numbers' : phoneNumber,
      'taxpayer_number' : taxNumber,
      'default_language' : defaultLanguage,
    }));
    return Entity.fromJsonDetailed(jsonDecode(res.body));
  }

  static void remove(int entityId) async{
    await ClientApi.remove('entities/' + entityId.toString());
  }

  @override
  String toString() {
    return "#" + id.toString() + " - " + name;
  }
}