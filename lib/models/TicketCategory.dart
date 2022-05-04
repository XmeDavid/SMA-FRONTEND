class TicketCategory{
  final int id;
  final String name;
  final String? description;

  const TicketCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory TicketCategory.fromJson(Map<String, dynamic> json){
    return TicketCategory(id: json['id'], name: json['name'], description: json['description']);
  }


  @override
  String toString() {
    return "Category #" + id.toString() + " - " + name;
  }
}