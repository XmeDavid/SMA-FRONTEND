import 'dart:convert';

import 'package:get/get.dart';
import 'package:sma_frontend/models/TicketCategory.dart';

import '../api_interactions/api_functions.dart';

import 'Asset.dart';
import 'Contract.dart';
import 'User.dart';
import 'Entity.dart';

class Ticket {
  int id;
  String title;
  String description;
  int? assistantId;
  User? assistant;
  int? entityId;
  Entity? entity;
  int? contractId;
  Contract? contract;
  int categoryId;
  TicketCategory? category;
  String status;
  String startDate;
  String? estimatedTime;
  bool? isSolved;
  String? filesPath;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    this.assistantId,
    this.assistant,
    required this.entityId,
    this.entity,
    this.contractId,
    this.contract,
    required this.categoryId,
    this.category,
    required this.status,
    required this.startDate,
    this.estimatedTime,
    this.isSolved,
    this.filesPath
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id : json['id'],
      title : json['title'],
      description : json['body_description'],
      assistantId : json['assistant_id'],
      entityId : json['entities_id'],
      contractId : json['contracts_id'],
      categoryId : json['categories_id'],
      status : json['status'],
      startDate : json['start_date'],
      estimatedTime : json['estimated_time'],
      isSolved : json['is_solved'],
      filesPath : json['files_path']
    );
  }

  factory Ticket.fromJsonDetailed(Map<String, dynamic> json) {
    return Ticket(
        id : json['id'],
        title : json['title'],
        description : json['body_description'],
        assistantId : json['assistant'] != null ? json['assistant']['id'] : null,
        assistant: json['assistant'] != null ? User.fromJsonDetailed(json['assistant']) : null,
        entityId : json['entity'] != null ? json['entity']['id'] : null,
        entity: json['entity'] != null ? Entity.fromJsonDetailed(json['entity']) : null,
        contractId : json['contract'] != null ? json['contract']['id'] : null,
        contract: json['contract'] != null ? Contract.fromJson(json['contract']) : null,
        categoryId : json['category']['id'],
        category: TicketCategory.fromJson(json['category']),
        status : json['status'],
        startDate : json['start_date'],
        estimatedTime : json['estimated_time'],
        isSolved : json['is_solved'],
        filesPath : json['files_path']
    );
  }


  static Future<Ticket?> get(int id, bool detailed) async{
    try{
      var res = await ClientApi.get("tickets/$id${detailed ? '?format=detailed' : ''}");
      if(res.statusCode != 200){
        switch(res.statusCode){
          case 401:
            throw Exception("Unauthenticated");
          case 500:
            throw Exception("Internal Server Error");
        }
      }
      return detailed ? Ticket.fromJsonDetailed(jsonDecode(res.body)) : Ticket.fromJson(jsonDecode(res.body));
    }on Exception catch(e){
      return null;
    }
  }

  static Future<List<Ticket>?> getAll(bool detailed, String status, String search, int categoryId) async{
    var url = "tickets${detailed ? '?format=detailed' : ''}${status != "" ? "&status=$status" : ""}${categoryId != -1 ? "&categories_id=$categoryId" : ""}";
    if(search != ''){
      url = "tickets${detailed ? '?format=detailed' : ''}${(search != null && search != "") ? "&search=$search" : ""}${categoryId != -1 ? "&categories_id=$categoryId" : ""}";
    }
     var res = await ClientApi.get(url);
    if(res.statusCode == 401){
      Get.toNamed('login');
      return null;
    }
    List<Ticket> data = <Ticket>[];
    for(var ticketJson in jsonDecode(res.body)['data']){
      Ticket ticket = detailed ? Ticket.fromJsonDetailed(ticketJson) : Ticket.fromJson(ticketJson);
      data.add(ticket);
    }

    return data;
  }

  static Future<Ticket?> create(String title, String description, TicketCategory category, Contract contract, List<Asset>? assets) async{
    if(assets != null){
      for(var asset in assets){
        print(asset.toString());
      }
    }
    var res = await ClientApi.post('tickets', jsonEncode(<String, dynamic>{
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
  }

  static update(Ticket ticket) {}

  static void assignUser(Ticket ticket, User user) async {
    var res = await ClientApi.post('tickets/assign/${ticket.id}?_method=PATCH', jsonEncode(<String, dynamic>{
      'assistant_id' : user.id
    }));
  }

  static delete(Ticket ticket) async {
    var res = await ClientApi.remove('tickets/${ticket.id}');
  }
}
