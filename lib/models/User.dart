import 'package:sma_frontend/models/Entity.dart';

class User{

  final int id;
  final String full_name;
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
    required this.full_name,
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
        full_name: json['full_name'],
        last_name: json['last_name'],
        email: json['email'],
        entityId: json['entities_id'],
        phoneNumber: json['phone_number'],
        imagePath: json['image_path'],
        perHour: json['per_hour'],
        mfaEnabled: json['mfa']
    );
  }

}