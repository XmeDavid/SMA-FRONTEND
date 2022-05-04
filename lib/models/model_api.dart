import 'dart:convert';


import 'package:sma_frontend/models/TicketCategory.dart';

import '../api_interactions/api_functions.dart';
import 'Asset.dart';
import 'Contract.dart';
import 'Entity.dart';

class ModelApi{
  static Future<List<Contract>> getContracts() async{
    List<Contract> tempContracts = <Contract>[];
    var res = await ApiClient().getAll("contracts");
    dynamic json = jsonDecode(res.body);
    for(var contractJson in json){
      Contract contract = Contract.fromJson(contractJson);
      tempContracts.add(contract);
    }
    return tempContracts;
  }

  static Future<List<Asset>> getAssets() async{
    List<Asset> tempAssets = <Asset>[];
    var res = await ApiClient().getAll("assets");
    dynamic json = jsonDecode(res.body);
    for(var assetJson in json){
      Asset asset = Asset.fromJson(assetJson);
      tempAssets.add(asset);
    }
    return tempAssets;
  }

  static Future<List<Entity>> getEntities() async{
    List<Entity> tempEntities = <Entity>[];
    var res = await ApiClient().getAll("entities");
    dynamic json = jsonDecode(res.body);
    for(var entityJson in json){
      Entity entity = Entity.fromJson(entityJson);
      tempEntities.add(entity);
    }
    return tempEntities;
  }

  static Future<List<TicketCategory>> getTicketCategories() async{
    List<TicketCategory> tempTicketCategories = <TicketCategory>[];
    var res = await ApiClient().getAll("tickets/categories");
    dynamic json = jsonDecode(res.body);
    for(var ticketCategoryJson in json){
      TicketCategory ticketCategory = TicketCategory.fromJson(ticketCategoryJson);
      tempTicketCategories.add(ticketCategory);
    }
    return tempTicketCategories;
  }
}