import 'dart:convert';

import '../api_interactions/api_functions.dart';

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

  static Future<List<TicketCategory>> getAll() async{
    List<TicketCategory> tempTicketCategories = <TicketCategory>[];
    var res = await ClientApi.get("tickets/categories");
    dynamic json = jsonDecode(res.body);
    for(var ticketCategoryJson in json['data']){
      TicketCategory ticketCategory = TicketCategory.fromJson(ticketCategoryJson);
      tempTicketCategories.add(ticketCategory);
    }
    return tempTicketCategories;
  }

  @override
  String toString() {
    return "Category #" + id.toString() + " - " + name;
  }
}