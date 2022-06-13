import 'dart:convert';

import '../api_interactions/api_functions.dart';

import 'Contract.dart';
import 'User.dart';
import 'Entity.dart';

class Ticket {
  int id;
  int entitiesId;
  Entity? entity;
  int assistantId;
  User? assistant;
  int contractsId;
  Contract? contract;
  String title;
  String bodyDescription;
  int categoriesId;
  String status;
  String startDate;
  String estimatedTime;
  bool? isSolved;
  String filesPath;

  Ticket({
    required this.id,
    required this.entitiesId,
    this.entity,
    required this.assistantId,
    this.assistant,
    required this.contractsId,
    this.contract,
    required this.title,
    required this.bodyDescription,
    required this.categoriesId,
    required this.status,
    required this.startDate,
    required this.estimatedTime,
    this.isSolved,
    required this.filesPath
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id : json['id'],
      entitiesId : json['entities_id'],
      assistantId : json['assistant_id'],
      contractsId : json['contracts_id'],
      title : json['title'],
      bodyDescription : json['body_description'],
      categoriesId : json['categories_id'],
      status : json['status'],
      startDate : json['start_date'],
      estimatedTime : json['estimated_time'],
      //isSolved : json['is_solved'],
      filesPath : json['files_path']
    );
  }

  factory Ticket.fromJsonDetailed(Map<String, dynamic> json) {
    return Ticket(
        id : json['id'],
        entitiesId : json['entity']['id'],
        entity: Entity.fromJsonDetailed(json['entity']),
        assistantId : json['assistant_id'],
        contractsId : json['contracts_id'],
        title : json['title'],
        bodyDescription : json['body_description'],
        categoriesId : json['categories_id'],
        status : json['status'],
        startDate : json['start_date'],
        estimatedTime : json['estimated_time'],
        //isSolved : json['is_solved'],
        filesPath : json['files_path']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entities_id'] = this.entitiesId;
    data['assistant_id'] = this.assistantId;
    data['contracts_id'] = this.contractsId;
    data['title'] = this.title;
    data['body_description'] = this.bodyDescription;
    data['categories_id'] = this.categoriesId;
    data['status'] = this.status;
    data['start_date'] = this.startDate;
    data['estimated_time'] = this.estimatedTime;
    data['is_solved'] = this.isSolved;
    data['files_path'] = this.filesPath;
    return data;
  }

  static Future<Ticket> get(int id) async{
    var res = await ClientApi.get("/tickets/$id?format=detailed");
    return Ticket.fromJson(jsonDecode(res.body));
  }

  static Future<List<Ticket>> getAll() async{
    var res = await ClientApi.get("tickets");
    print(res.body);
    List<Ticket> data = <Ticket>[];
    for(var ticketJson in jsonDecode(res.body)){
      Ticket ticket = Ticket.fromJson(ticketJson);
      data.add(ticket);
    }
    return data;
  }
}
