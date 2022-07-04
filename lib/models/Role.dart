import 'dart:convert';

import 'package:get/get.dart';

import '../api_interactions/api_functions.dart';


class Role{
  final int id;
  final String name;
  final bool secondaryEntity;
  final int usersInRole;

  const Role({
    required this.id,
    required this.name,
    required this.secondaryEntity,
    required this.usersInRole,
  });

  factory Role.fromJson(Map<String, dynamic> json){
    return Role(
      id: json['id'],
      name: json['name'],
      secondaryEntity: json['secondary_entity'] == 0 ? false : true,
      usersInRole: json['users_count'],
    );
  }

  static Future<Role> create(String name, String secondaryEntity) async{
    var res = await ClientApi.post("roles",jsonEncode(<String, dynamic>{
      'name' : name,
      'secondary_entity' : secondaryEntity,
    }));
    return Role.fromJson(jsonDecode(res.body));
  }

  static Future<Role> get(int id) async{
    var res = await ClientApi.get('roles/$id');
    return Role.fromJson(jsonDecode(res.body));
  }

  static Future<List<Role>> all() async{
    var res = await ClientApi.get("roles");
    dynamic json = jsonDecode(res.body);
    List<Role> data = <Role>[];
    for(var _jsonRole in json['data']){
      Role _role = Role.fromJson(_jsonRole);
      data.add(_role);
    }
    return data;
  }

  static void remove(int interventionId) async{
    await ClientApi.remove('tickets/tasks/interventions/$interventionId');
  }
}