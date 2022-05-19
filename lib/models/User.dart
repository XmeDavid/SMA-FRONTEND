import 'dart:convert';

import 'package:sma_frontend/models/Entity.dart';

import '../api_interactions/api_functions.dart';
import 'paginated_model/Meta.dart';
import 'paginated_model/PaginatedModel.dart';

class User{

  final int id;
  final String first_name;
  final String last_name;
  final String? phoneNumber;
  final String imagePath;
  final int entityId;
  final Entity? entity;
  final String email;
  final double perHour;
  final bool mfaEnabled;

  const User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.entityId,
    this.entity,
    required this.phoneNumber,
    required this.imagePath,
    required this.perHour,
    required this.mfaEnabled,
});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        email: json['email'],
        entityId: json['entities_id'],
        phoneNumber: json['phone_number'],
        imagePath: json['image_path'],
        perHour: json['per_hour'],
        mfaEnabled: json['mfa']
    );
  }

  factory User.fromJsonDetailed(Map<String, dynamic> json){
    return User(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        email: json['email'],
        entityId: json['entities_id'],
        phoneNumber: json['phone_number'],
        imagePath: json['image_path'],
        perHour: json['per_hour'],
        mfaEnabled: json['mfa']
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
    var res = await ClientApi.get("users/$id${(detailed ? "?format=detailed" : "")}");
    return detailed ? Entity.fromJsonDetailed(jsonDecode(res.body)) : Entity.fromJson(jsonDecode(res.body));
  }

  static Future<List<Entity>> getAll() async{
    var res = await ClientApi.get("users");
    dynamic json = jsonDecode(res.body);
    List<Entity> data = <Entity>[];
    for(var entityJson in json['data']){
      Entity entity = Entity.fromJson(entityJson);
      data.add(entity);
    }
    return data;
  }

  static Future<PaginatedModel<User>> getPaginated(bool detailed, int paginate, int page, String search) async{
    var res = await ClientApi.get("users?${(detailed ? "format=detailed&" : "")}paginate=$paginate&page=$page${(search != "" ? "&search=$search" : "")}");
    dynamic json = jsonDecode(res.body);
    List<User> data = <User>[];
    for(var entityJson in json['data']){
      User entity = detailed ? User.fromJsonDetailed(entityJson) : User.fromJson(entityJson);
      data.add(entity);
    }
    return PaginatedModel(
      data: data,
      meta: Meta.fromJson(json['meta']),
    );
  }

  static void remove(int entityId) async{
    await ClientApi.remove('users/' + entityId.toString());
  }

  String fullName(){
    return "$first_name $last_name";
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }

}