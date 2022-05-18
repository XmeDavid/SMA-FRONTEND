import 'Entity.dart';

class Contract{
  final int id;
  final String title;
  final String description;
  final int entitiesId;
  final Entity? entity;
  final String startDate;
  final String duration;
  final String endDate;
  final String? cover;
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
    required this.entitiesId,
    required this.startDate,
    required this.duration,
    required this.endDate,
    required this.cover,
    required this.autoRenovation,
    required this.lastRenovation,
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
      duration: json['duration_months'],
      endDate: json['end_date'],
      cover: json['cover'],
      allowsSurplus: json['allow_surplus'],
      autoRenovation: json['auto_renovation']==0 ? false : true,
      lastRenovation : json['last_renovation_at'],
      isValidated: json['is_validated']==0 ? false : true,
      budget: json['budget'],
    );
  }
  factory Contract.fromJsonDetailed(Map<String, dynamic> json){
    return Contract(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      entitiesId: json['entity']['id'],
      entity: Entity.fromJsonDetailed(json['entity']),
      startDate: json['start_date'],
      duration: json['duration_months'],
      endDate: json['end_date'],
      cover: json['cover'],
      allowsSurplus: json['allow_surplus'],
      autoRenovation: json['auto_renovation']==0 ? false : true,
      lastRenovation : json['last_renovation_at'],
      isValidated: json['is_validated']==0 ? false : true,
      budget: json['budget'],
    );
  }

  @override
  String toString() {
    return "Contract #" + id.toString() + " - " + description.substring(0,25) + "...";
  }
}