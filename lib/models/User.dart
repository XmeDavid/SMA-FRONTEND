import 'dart:convert';

import 'package:sma_frontend/models/Entity.dart';

import '../api_interactions/api_functions.dart';
import 'paginated_model/Meta.dart';
import 'paginated_model/PaginatedModel.dart';

class User{

  final int id;
  final String first_name;
  final String last_name;
  final String birthDate;
  final String? phoneNumber;
  final String imagePath;
  final int entityId;
  final Entity? entity;
  final String email;
  final double perHour;
  final bool? mfaEnabled;

  const User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.birthDate,
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
        birthDate: json['birth_date'],
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
        birthDate: json['birth_date'],
        email: json['email'],
        entityId: json['entities_id']['id'],
        entity: Entity.fromJsonDetailed(json['entities_id']),
        phoneNumber: json['phone_number'],
        imagePath: json['image_path'],
        perHour: json['per_hour'],
        mfaEnabled: json['mfa']
    );
  }

  static void create(String firstName, String lastName, String birthDate, String email, String phoneNumber, double perHour, int entityId, bool mfa) async{
    var res = await ClientApi.create("register",jsonEncode(<String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'birth_date' : birthDate,
      'email' : email,
      'phone_number' : phoneNumber,
      'per_hour' : perHour,
      'entities_id' : entityId,
    }));
    if(res.statusCode != 200){
      throw Error();
    }
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
  
  static void changePassword(String email, String password, String confirmationPassword, String token) async {
    await ClientApi.post('password/reset', jsonEncode(<String, dynamic>{
      'email' : email,
      'password' : password,
      'password-validation' : confirmationPassword,
      'token' : token
    }));
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