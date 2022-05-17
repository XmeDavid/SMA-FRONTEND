import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;


class ApiClient{

  String API_URL = dotenv.env['API_URL'] ?? "";

  Future<http.Response> sendLoginRequest(String email, String password) async{
    return http.post(
        Uri.parse(API_URL + "login"),
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
        headers: <String, String>{
          //'Authorization' : 'Bearer ' + GetStorage().read('token')
        }
    ));
  }
  
  Future<http.Response> createTicket(int clientId, int assistantId, int contractId, int categoryId, String startDate) async{
    return http.post(
      Uri.parse(API_URL + "tickets/"),
      headers: <String,String>{
        //'Authorization' : 'Bearer ' + GetStorage().read('token')
      },
      body: jsonEncode(<String, String>{
        'entities_id': clientId.toString(),
        'assistant_id': assistantId.toString(),
        'contracts_id' : contractId.toString(),
        'categories_id' : categoryId.toString(),
        'start_date' : startDate,
      })
    );
  }

  Future<http.Response> create(String path,String json) async{
    return http.post(
        Uri.parse(API_URL + path),
        headers: <String,String>{
          //'Authorization' : 'Bearer ' + GetStorage().read('token')
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json
    );
  }

  Future<http.Response> remove(String s) async{
    return await (http.delete(
        Uri.parse(API_URL + s),
        headers: <String, String>{
          //'Authorization' : 'Bearer ' + GetStorage().read('token')
        }
    ));
  }
}

