import 'dart:convert';

import 'package:get/get.dart';

import '../api_interactions/api_functions.dart';

import 'Contract.dart';
import 'User.dart';
import 'Entity.dart';

class Ticket {
  int id;
  String title;
  String description;
  int? assistantId;
  User? assistant;
  int entityId;
  Entity? entity;
  int contractId;
  Contract? contract;
  int categoryId;
  String status;
  String startDate;
  String estimatedTime;
  bool? isSolved;
  String filesPath;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    this.assistantId,
    this.assistant,
    required this.entityId,
    this.entity,
    required this.contractId,
    this.contract,
    required this.categoryId,
    required this.status,
    required this.startDate,
    required this.estimatedTime,
    this.isSolved,
    required this.filesPath
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
        entityId : json['entity']['id'],
        entity: Entity.fromJsonDetailed(json['entity']),
        contractId : json['contract']['id'],
        contract: Contract.fromJson(json['contract']),
        categoryId : json['categories_id'],
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

  static Future<List<Ticket>?> getAll(bool detailed) async{
    var res = await ClientApi.get("tickets${detailed ? '?format=detailed' : ''}");
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
}
