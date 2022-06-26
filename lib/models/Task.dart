import 'dart:convert';

import 'package:get/get.dart';
import 'package:sma_frontend/models/TicketCategory.dart';

import '../api_interactions/api_functions.dart';

import 'Ticket.dart';
import 'User.dart';
import 'Entity.dart';

class Task {
  int id;
  String title;
  String description;
  int? userId;
  User? user;
  int? entityId;
  Entity? entity;
  int? ticketId;
  Ticket? ticketAssociated;
  String startDate;
  String? endDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.userId,
    this.user,
    required this.entityId,
    this.entity,
    this.ticketId,
    this.ticketAssociated,
    required this.startDate,
    this.endDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id : json['id'],
        title : json['title'],
        description : json['body_description'],
        userId : json['users_id'],
        entityId : json['entities_id'],
        ticketId : json['tickets_id'],
        startDate : json['start_date'],
        endDate : json['end_date'],
    );
  }

  factory Task.fromJsonDetailed(Map<String, dynamic> json) {
    return Task(
        id : json['id'],
        title : json['title'],
        description : json['body_description'],
        userId : json['user'] != null ? json['user']['id'] : null,
        user: json['user'] != null ? User.fromJsonDetailed(json['user']) : null,
        entityId : json['entity'] != null ? json['entity']['id'] : null,
        entity: json['entity'] != null ? Entity.fromJsonDetailed(json['entity']) : null,
        ticketId : json['ticket'] != null ? json['ticket']['id'] : null,
        ticketAssociated: json['ticket'] != null ? Ticket.fromJson(json['ticket']) : null,
        startDate : json['start_date'],
        endDate : json['end_date'],
    );
  }


  static Future<Task?> get(int id, bool detailed) async{
    try{
      var res = await ClientApi.get("tickets/tasks/$id${detailed ? '?format=detailed' : ''}");
      if(res.statusCode != 200){
        switch(res.statusCode){
          case 401:
            throw Exception("Unauthenticated");
          case 500:
            throw Exception("Internal Server Error");
        }
      }
      return detailed ? Task.fromJsonDetailed(jsonDecode(res.body)) : Task.fromJson(jsonDecode(res.body));
    }on Exception catch(e){
      return null;
    }
  }

  static Future<List<Task>?> getAll(bool detailed) async{
    var url = "tickets/tasks${detailed ? '?format=detailed' : ''}";
    var res = await ClientApi.get(url);
    if(res.statusCode == 401){
      Get.toNamed('login');
      return null;
    }
    List<Task> data = <Task>[];
    for(var taskJson in jsonDecode(res.body)['data']){
      Task task = detailed ? Task.fromJsonDetailed(taskJson) : Task.fromJson(taskJson);
      data.add(task);
    }

    return data;
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, userId: $userId, user: $user, entityId: $entityId, entity: $entity, ticketId: $ticketId, ticketAssociated: $ticketAssociated, startDate: $startDate, endDate: $endDate}';
  }

  static Future<dynamic> create(int userId, int ticketId, String title, String description) async{
    var res = await ClientApi.create('tickets/tasks', jsonEncode(<String, dynamic>{
      'users_id' : userId,
      'tickets_id' : ticketId,
      'title' : title,
      'body_description' : description,
    }));
    String? message;
    if(res.statusCode == 401){
      message = "Unauthenticated";
    }
    if(res.statusCode == 500){
      message = "Internal Server Error: ${res.body}";
    }
    if(res.statusCode == 422){
      message = "Unprocessable Content (Something in the request is wrong, wrong user, expired contract, etc...): ${res.body}";
    }
    return {'data' : userId, 'message' : message, 'code' : res.statusCode, 'test' : 'hey'};//Task.fromJsonDetailed(jsonDecode(res.body))};
  }

/*static Future<Task?> create(Entity entity, String title, String description, TicketCategory category, Contract contract) async{
    var res = await ClientApi.create('tickets', jsonEncode(<String, dynamic>{
      //'entities_id' : entity.id,
      'contracts_id' : contract.id,
      'title' : title,
      'body_description' : description,
      'start_date':'2000-09-14',
      'categories_id':category.id
    }));
    if(res.statusCode == 401){
      throw Exception("Unauthenticated");
      return null;
    }
    if(res.statusCode == 500){
      print(res.body);
      throw Exception("Internal Server Error: ${res.body}");
    }
    if(res.statusCode == 422){
      print(res.body);
      throw Exception("Unprocessable Content (Something in the request is wrong, wrong user, expired contract, etc...): ${res.body}");
    }
    //TODO if everything is alright parse the res.body into a Ticket and return it
    return null;
  }*/



}
