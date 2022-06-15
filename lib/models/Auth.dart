import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/api_interactions/api_functions.dart';

import 'User.dart';

class Auth{
  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String refreshToken;
  final bool? needsMfa;
  final String? mfaCode;

  const Auth({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
    this.needsMfa,
    this.mfaCode
  });

  factory Auth.fromJson(Map<String, dynamic> json){
    return Auth(
      tokenType: json['tokens']['token_type'],
      expiresIn: json['tokens']['expires_in'],
      accessToken: json['tokens']['access_token'],
      refreshToken: json['tokens']['refresh_token'],
      needsMfa: json['mfa'] == 1
    );
  }

  static Future<Auth> login(String email, String password) async{
    var res = await ClientApi.post('login',
        jsonEncode(<String, String>{
          'email': email,
          'password': password
        })
    );
    return Auth.fromJson(jsonDecode(res.body));
  }

  static Future<Auth> mfa(String mfaCode) async{
    var res = await ClientApi.create('mfa/verification',
        jsonEncode(<String, String>{
          'mfaCode': mfaCode,
          'refresh_token' : GetStorage().read('refreshToken'),
        })
    );
    return Auth.fromJson(jsonDecode(res.body));
  }

  static Future<void> sendRecovery(String email) async {
    await ClientApi.post('password/reset/send',jsonEncode(<String,String>{
      'email' : email
    }));
  }

  static Future<User> user() async {
    var res = await ClientApi.get('users/me');
    return User.fromJson(jsonDecode(res.body));
  }
}