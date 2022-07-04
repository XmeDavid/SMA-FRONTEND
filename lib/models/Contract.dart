import 'dart:convert';
import 'package:sma_frontend/api_interactions/api_functions.dart';
import 'package:sma_frontend/models/paginated_model/PaginatedModel.dart';
import 'Entity.dart';
import 'paginated_model/Meta.dart';

class Contract{
  final int id;
  final String title;
  final String description;
  final int? entitiesId;
  final Entity? entity;
  final String startDate;
  final String duration;
  final String endDate;
  final int? totalHours;
  final int? dislocationKm;
  final bool autoRenovation;
  final String? lastRenovation;
  final double budget;
  final bool allowsSurplus;
  final bool isValidated;

  const Contract(  {
    required this.id,
    required this.title,
    required this.description,
    this.entity,
    this.entitiesId,
    required this.startDate,
    this.totalHours,
    this.dislocationKm,
    required this.duration,
    required this.endDate,
    required this.autoRenovation,
    this.lastRenovation,
    required this.budget,
    required this.allowsSurplus,
    required this.isValidated,

  });

  factory Contract.fromJson(Map<String, dynamic> json){
    return Contract(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      entitiesId: json ['entities_id'],
      startDate: json['start_date'],
      totalHours: json['hours_total'],
      dislocationKm: json['dislocation_km'],
      duration: json['duration_months'],
      endDate: json['end_date'],
      allowsSurplus: json['allow_surplus'],
      autoRenovation: json['auto_renovation'],
      lastRenovation : json['last_renovation_at'],
      isValidated: json['is_validated'],
      budget: json['budget'],
    );
  }
  factory Contract.fromJsonDetailed(Map<String, dynamic> json){
    return Contract(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      entitiesId: json['entity'] != null ? json['entity']['id'] : null,
      entity: json['entity'] != null ? Entity.fromJsonDetailed(json['entity']) : null,
      startDate: json['start_date'],
      totalHours: json['hours_total'],
      dislocationKm: json['dislocation_km'],
      duration: json['duration_months'],
      endDate: json['end_date'],
      allowsSurplus: json['allow_surplus'],
      autoRenovation: json['auto_renovation'],
      lastRenovation : json['last_renovation_at'],
      isValidated: json['is_validated'],
      budget: json['budget'],
    );
  }

  static Future<Contract> get(int id, bool detailed) async {
    var res = await ClientApi.get("contracts/$id?format=detailed");
    return Contract.fromJsonDetailed(jsonDecode(res.body));
  }

  static Future<List<Contract>> getAll() async{
    List<Contract> tempContracts = <Contract>[];
    var res = await ClientApi.get("contracts");
    for(var contractJson in jsonDecode(res.body)['data']){
      Contract contract = Contract.fromJson(contractJson);
      tempContracts.add(contract);
    }
    return tempContracts;
  }

  static Future<PaginatedModel<Contract>> getPaginated(bool detailed, int paginate, int page, String search) async{
    var res = await ClientApi.get("contracts?${(detailed ? "format=detailed&" : "")}paginate=$paginate&page=$page${(search != "" ? "&search=$search" : "")}");
    dynamic json = jsonDecode(res.body);
    List<Contract> data = <Contract>[];
    for(var jsonContract in json['data']){
      Contract contract = detailed ? Contract.fromJsonDetailed(jsonContract) : Contract.fromJson(jsonContract);
      print(contract);
      data.add(contract);
    }
    return PaginatedModel(
      data: data,
      meta: Meta.fromJson(json['meta']),
    );
  }

  static Future<Contract> create(String title, String description, int entityId, String startDate, int duration, bool allowSurplus, bool autoRenovation, String totalHours, String totalKms, double budget) async{
    var cover = jsonEncode(<String, dynamic> {
      'hours_total' : int.parse(totalHours),
      'dislocation_km' : int.parse(totalKms),
    });
    var res = await ClientApi.post("contracts", jsonEncode(<String, dynamic>{
      'title': title,
      'description': description,
      'entities_id': '$entityId',
      'start_date': startDate,
      'duration_months': duration,
      'allow_surplus': allowSurplus,
      'auto_renovation': autoRenovation,
      'cover': cover,
      'budget': budget,
    }));
    return Contract.fromJson(jsonDecode(res.body));
  }

  static void remove(int contractId) async{
    await ClientApi.remove('contracts/$contractId');
  }

  @override
  String toString() {
    return "Contract #" + id.toString() + " - " + description.substring(0,25) + "...";
  }
}