import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/Contract.dart';


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

  Future<Contract> createContract(String title, String description, int entityId, String startDate, int duration, bool allow_surplus, bool auto_renovation, String totalHours, String totalKms, double budget) async{
    var cover = jsonEncode(<String, dynamic> {
      'hours_total' : int.parse(totalHours),
      'dislocation_km' : int.parse(totalKms),
    });
    final response = await http.post(
      Uri.parse(API_URL + "contracts"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'description': description,
        'entities_id': entityId,
        'start_date': startDate,
        'duration_months': duration,
        'allow_surplus': allow_surplus,
        'auto_renovation': auto_renovation,
        'cover': cover,
        'budget': budget,
      }),
    );
    if (response.statusCode == 200 ) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("ok");
      return Contract.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create.');
    }
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

