class EntityType{
  final int id;
  final String name;
  final String description;

  const EntityType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory EntityType.fromJson(Map<String, dynamic> json){
    return EntityType(id: json['id'], name: json['name'], description: json['description']);
  }

  @override
  String toString() {
    return "#" + id.toString() + " - " + name;
  }
}