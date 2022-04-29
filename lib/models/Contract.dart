class Contract{
  final int id;
  final String description;
  final int entitiesId;
  final String startDate;
  final String duration;
  final String endDate;
  final bool autoRenovation;
  final String? lastRenovation;
  final double budget;

  const Contract(  {
    required this.id,
    required this.description,
    required this.entitiesId,
    required this.startDate,
    required this.duration,
    required this.endDate,
    required this.autoRenovation,
    required this.lastRenovation,
    required this.budget,
  });

  factory Contract.fromJson(Map<String, dynamic> json){
    return Contract(
      id: json['id'],
      description: json['description'],
      entitiesId: json ['entities_id'],
      startDate: json['start_date'],
      duration: json['duration'],
      endDate: json['end_date'],
      autoRenovation: json['auto_renovation'] == 1 ? true : false,
      lastRenovation : json['last_renovation'],
      budget: json['budget'],
    );
  }

  @override
  String toString() {
    return "Contract #" + id.toString() + " - " + description.substring(0,25) + "...";
  }
}