import 'dart:convert';

import 'package:sma_frontend/api_interactions/api_functions.dart';

class EntityType{
  final int id;
  final String name;
  final String description;

  const EntityType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory EntityType.fromJson(Map<String, dynamic> json){
    return EntityType(id: json['id'], name: json['name'], description: json['description']);
  }

  static Future<List<EntityType>> getAll() async{
    List<EntityType> tempEntityType = <EntityType>[];
    var res = await ClientApi.get("entities/types");
    dynamic json = jsonDecode(res.body);
    for(var entityTypeJson in json['data']){
      EntityType entityType = EntityType.fromJson(entityTypeJson);
      tempEntityType.add(entityType);
    }
    return tempEntityType;
  }

  @override
  String toString() {
    return "#" + id.toString() + " - " + name;
  }
}