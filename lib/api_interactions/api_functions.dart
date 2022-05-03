import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class ApiClient{

  String API_URL = dotenv.env['API_URL'] ?? "";

  Future<http.Response> sendLoginRequest(String email, String password) async{
    return http.post(
        Uri.parse('httpSomethingsomething'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        })
    );
  }

  Future<http.Response> getAll(String s) async{
    return await (http.get(
        Uri.parse(API_URL + s),
        headers: <String, String>{}
    ));
  }
}

