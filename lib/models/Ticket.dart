import 'dart:convert';

import '../api_interactions/api_functions.dart';

class Ticket {
  int? id;
  int? entitiesId;
  Null? assistantId;
  int? contractsId;
  String? title;
  String? bodyDescription;
  int? categoriesId;
  String? status;
  String? startDate;
  String? estimatedTime;
  Null? isSolved;
  String? filesPath;

  Ticket(
      {this.id,
        this.entitiesId,
        this.assistantId,
        this.contractsId,
        this.title,
        this.bodyDescription,
        this.categoriesId,
        this.status,
        this.startDate,
        this.estimatedTime,
        this.isSolved,
        this.filesPath});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entitiesId = json['entities_id'];
    assistantId = json['assistant_id'];
    contractsId = json['contracts_id'];
    title = json['title'];
    bodyDescription = json['body_description'];
    categoriesId = json['categories_id'];
    status = json['status'];
    startDate = json['start_date'];
    estimatedTime = json['estimated_time'];
    isSolved = json['is_solved'];
    filesPath = json['files_path'];
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

  static Future<List<Ticket>> getAll() async{
    var res = await ClientApi.get("tickets");
    List<Ticket> data = <Ticket>[];
    for(var ticketJson in jsonDecode(res.body)){
      Ticket ticket = Ticket.fromJson(ticketJson);
      data.add(ticket);
    }
    return data;
  }
}
