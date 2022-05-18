import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:sma_frontend/models/Address.dart';
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

  static Future<Entity> createEntity(
      int entityTypeId,
      String fullName,
      String email,
      String phoneNumber,
      String taxNumber,
      String defaultLanguage,
      String streetName,
      String door,
      int floor,
      String room,
      String local,
      String district,
      String zipCode,
      int countryId
    ) async{
    var res = await ApiClient().create("entities",jsonEncode(<String, dynamic>{
      'entities_types_id': entityTypeId,
      'full_name': fullName,
      'email' : email,
      'phone_numbers' : phoneNumber,
      'taxpayer_number' : taxNumber,
      'default_language' : defaultLanguage,
      'street_name' : streetName,
      'door' : door,
      'floor' : floor,
      'room' : room,
      'local' : local,
      'district' : district,
      'zip_code' : zipCode,
      'countries_id' : countryId,
    }));
    return Entity.fromJsonDetailed(jsonDecode(res.body));
  }

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

  static Future<PaginatedModel<Entity>> getEntitiesPaginated(bool detailed, int paginate, int page,int filterEntityType, String search) async{
    var res = await ApiClient().getAll("entities?" + (detailed ? "format=detailed&" : "")+"paginate=$paginate&page=$page" + (filterEntityType != -1 ? "&entities_types_id=$filterEntityType" : "") + (search != "" ? "&search=$search" : ""));
    dynamic json = jsonDecode(res.body);
    List<Entity> data = <Entity>[];
    for(var entityJson in json['data']){
      Entity entity = detailed ? Entity.fromJsonDetailed(entityJson) : Entity.fromJson(entityJson);
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


  static void removeEntity(int entityId) async{
    await ApiClient().remove('entities/' + entityId.toString());
  }

  static Future<Entity> getEntity(int entityId) async{
    var res = await ApiClient().getAll('entities/$entityId?format=detailed');
    return Entity.fromJsonDetailed(jsonDecode(res.body));
  }

  static updateAddress(int id,String street, String door, String floor, String room, String zipCode, String local, String district, int countryId) async{
    var res = await ApiClient().update("addresses/$id",jsonEncode(<String, dynamic>{
      'street_name' : street,
      'door' : door,
      'floor' : floor,
      'room' : room,
      'zip_code' : zipCode,
      'local' : local,
      'district' : district,
      'country_id' : countryId,
    }));
    dynamic json = jsonDecode(res.body);
    return Address.fromJson(json);
  }
}