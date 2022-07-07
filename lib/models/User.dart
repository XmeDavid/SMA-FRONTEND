import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:sma_frontend/models/Entity.dart';

import '../api_interactions/api_functions.dart';
import 'paginated_model/Meta.dart';
import 'paginated_model/PaginatedModel.dart';

class User{

  final int id;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String? phoneNumber;
  final String? imagePath;
  final int entityId;
  final Entity? entity;
  final String email;
  final double perHour;
  final bool? mfaEnabled;
  final String? blockedAt;
  final String? lastLoginAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.email,
    required this.entityId,
    this.entity,
    required this.phoneNumber,
    this.imagePath,
    required this.perHour,
    required this.mfaEnabled,
    this.blockedAt,
    this.lastLoginAt
});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        birthDate: json['birth_date'],
        email: json['email'],
        entityId: json['entities_id'],
        phoneNumber: json['phone_number'],
        imagePath: json['image_path'],
        perHour: json['per_hour'],
        mfaEnabled: json['mfa'],
    );
  }

  factory User.fromJsonDetailed(Map<String, dynamic> json){
    return User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        birthDate: json['birth_date'],
        email: json['email'],
        entityId: json['entities_id']['id'],
        entity: Entity.fromJsonDetailed(json['entities_id']),
        phoneNumber: json['phone_number'],
        imagePath: json['image_path'],
        perHour: json['per_hour'],
        mfaEnabled: json['mfa'],
        blockedAt: json['blocked_at'],
        lastLoginAt: json['last_login_at']
    );
  }

  static void create(String firstName, String lastName, String birthDate, String email, String phoneNumber, double perHour, int entityId, bool mfa) async{
    var res = await ClientApi.post("register",jsonEncode(<String, dynamic>{
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

  static Future<User> get(int id, bool detailed) async{
    var res = await ClientApi.get("users/$id${(detailed ? "?format=detailed" : "")}");
    return detailed ? User.fromJsonDetailed(jsonDecode(res.body)) : User.fromJson(jsonDecode(res.body));
  }

  static Future<List<User>> getAll(bool detailed) async{
    var res = await ClientApi.get("users${detailed ? '?format=detailed' : ''}");
    dynamic json = jsonDecode(res.body);
    List<User> data = <User>[];
    for(var userJson in json['data']){
      User user = detailed ? User.fromJsonDetailed(userJson) : User.fromJson(userJson);
      data.add(user);
    }
    return data;
  }

  static Future<PaginatedModel<User>> getPaginated(bool detailed, int paginate, int page, String search) async{
    var res = await ClientApi.get("users?${(detailed ? "format=detailed&" : "")}paginate=$paginate&page=$page${(search != "" ? "&search=$search" : "")}");
    dynamic json = jsonDecode(res.body);
    List<User> data = <User>[];
    for(var userJson in json['data']){
      User user = detailed ? User.fromJsonDetailed(userJson) : User.fromJson(userJson);
      data.add(user);
    }
    return PaginatedModel(
      data: data,
      meta: Meta.fromJson(json['meta']),
    );
  }

  static void remove(int userId) async{
    await ClientApi.remove('users/' + userId.toString());
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
    return "$firstName $lastName";
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }

}