import 'dart:convert';


import 'package:sma_frontend/models/Country.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/TicketCategory.dart';
import 'package:sma_frontend/models/paginated_model/Meta.dart';
import 'package:sma_frontend/models/paginated_model/PaginatedModel.dart';

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

  static Future<List<Entity>> getEntities(bool detailed) async{
    List<Entity> tempEntities = <Entity>[];
    var res = await ApiClient().getAll("entities" + (detailed ? "?format=detailed" : ""));
    dynamic json = jsonDecode(res.body);
    for(var entityJson in json['data']){
      Entity entity = detailed ? Entity.fromJsonDetailed(entityJson) : Entity.fromJson(entityJson);
      tempEntities.add(entity);
    }
    return tempEntities;
  }

  static Future<PaginatedModel<Entity>> getEntitiesPaginated(bool detailed, int paginate, int page) async{
    var res = await ApiClient().getAll("entities?" + (detailed ? "format=detailed&" : "")+"paginate=" + paginate.toString() + "&page=" + page.toString());
    dynamic json = jsonDecode(res.body);
    List<Entity> data = <Entity>[];
    for(var entityJson in json['data']){
      print(entityJson);
      Entity entity = detailed ? Entity.fromJsonDetailed(entityJson) : Entity.fromJson(entityJson);
      print(entity);
      data.add(entity);
    }
    return PaginatedModel(
        data: data,
        meta: Meta.fromJson(json['meta']),
    );
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

  static Future<List<EntityType>> getEntityTypes() async{
    List<EntityType> tempEntityType = <EntityType>[];
    var res = await ApiClient().getAll("entities/types");
    dynamic json = jsonDecode(res.body);
    for(var entityTypeJson in json['data']){
      EntityType entityType = EntityType.fromJson(entityTypeJson);
      tempEntityType.add(entityType);
    }
    return tempEntityType;
  }

  static Future<List<Country>> getCountrys() async{
    List<Country> tempCountry = <Country>[];
    var res = await ApiClient().getAll("countries");
    dynamic json = jsonDecode(res.body);
    for(var countryJson in json){
      Country country = Country.fromJson(countryJson);
      tempCountry.add(country);
    }
    return tempCountry;
  }

}