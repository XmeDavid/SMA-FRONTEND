import 'dart:convert';

import '../api_interactions/api_functions.dart';
import 'Asset.dart';
import 'Contract.dart';

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
}