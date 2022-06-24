import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;


class ClientApi{

  static final String API_URL = dotenv.env['API_URL'] ?? "";

  static Future<http.Response> post(String path, String body) async{
    return http.post(
        Uri.parse(API_URL + path),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept' : 'application/json'
        },
        body: body
    );
  }

  static Future<http.Response> get(String s) async{
    String? authToken = GetStorage().read('token');
    return await (http.get(
        Uri.parse(API_URL + s),
        headers: <String, String>{
          'Authorization' : authToken != null ? 'Bearer $authToken' : '',
          'Accept' : 'application/json'
        }
    ));
  }


  static Future<http.Response> create(String path,String json) async{
    return http.post(
        Uri.parse(API_URL + path),
        headers: <String,String>{
          'Authorization' : 'Bearer ' + GetStorage().read('token'),
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept' : 'application/json'
        },
        body: json
    );
  }

  static Future<http.Response> remove(String s) async{
    return await (http.delete(
        Uri.parse(API_URL + s),
        headers: <String, String>{
          //'Authorization' : 'Bearer ' + GetStorage().read('token')
        }
    ));
  }

  static Future<http.Response> update(String s, String json) async{
    return await (http.put(
        Uri.parse(API_URL + s),
        headers: <String, String>{
          //'Authorization' : 'Bearer ' + GetStorage().read('token')
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept' : 'application/json'
        },
      body: json
    ));
  }

}

