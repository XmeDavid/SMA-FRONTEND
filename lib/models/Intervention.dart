import 'dart:convert';

import 'package:get/get.dart';

import '../api_interactions/api_functions.dart';
import 'Task.dart';
import 'paginated_model/Meta.dart';
import 'paginated_model/PaginatedModel.dart';

class Intervention{
  final int id;
  final String startDate;
  final String endDate;
  final String description;
  final int taskId;
  final Task? parentTask;

  const Intervention({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.taskId,
    this.parentTask
  });

  factory Intervention.fromJson(Map<String, dynamic> json){
    try{
      if(json['tasks_id'] == null){
        throw Exception("is Detailed");
      }
    }on Exception catch(_){
      return Intervention(
          id: json['id'],
          startDate: json['start_date'],
          endDate: json['end_date'],
          description: json['record_description'],
          taskId: json['task']['id'],
          parentTask: Task.fromJsonDetailed(json['task'])
      );
    }
    return Intervention(
        id: json['id'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        description: json['record_description'],
        taskId: json['tasks_id']
    );
  }

  /** METHODS */

  static Future<Intervention> create(int taskId, String startDate, String endDate, String description) async{
    var res = await ClientApi.post("tickets/tasks/interventions",jsonEncode(<String, dynamic>{
      'tasks_id' : taskId,
      'start_date' : startDate,
      'end_date' : endDate,
      'record_description' : description
    }));
    if(res.statusCode == 400){
      throw Exception("Can't create Invervention, either this task is solved, canceled, or there was something in the server");
    }
    if(res.statusCode != 204){
      throw Exception("Something went wrong!");
    }
    return Intervention.fromJson(jsonDecode(res.body));
  }

  static Future<Intervention> get(int id, bool detailed) async{
    var res = await ClientApi.get("tickets/tasks/interventions/$id${(detailed ? "?format=detailed" : "")}");
    return Intervention.fromJson(jsonDecode(res.body));
  }

  static Future<List<Intervention>> getAll(int taskId) async{
    var res = await ClientApi.get("tickets/tasks/interventions?tasks_id=$taskId");
    dynamic json = jsonDecode(res.body);
    List<Intervention> data = <Intervention>[];
    for(var _interventionJson in json['data']){
      Intervention _intervention = Intervention.fromJson(_interventionJson);
      data.add(_intervention);
    }
    return data;
  }

  static Future<PaginatedModel<Intervention>> getPaginated(bool detailed, int paginate, int page, String search) async{
    var res = await ClientApi.get("entities?${(detailed ? "format=detailed&" : "")}paginate=$paginate&page=$page${(search != "" ? "&search=$search" : "")}");
    dynamic json = jsonDecode(res.body);
    List<Intervention> data = <Intervention>[];
    for(var _interventionJson in json['data']){
      Intervention _intervention = Intervention.fromJson(_interventionJson);
      data.add(_intervention);
    }
    return PaginatedModel(
      data: data,
      meta: Meta.fromJson(json['meta']),
    );
  }

  static void remove(int interventionId) async{
    await ClientApi.remove('tickets/tasks/interventions/$interventionId');
  }
}