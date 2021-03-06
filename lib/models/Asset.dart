import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/api_interactions/api_functions.dart';

import 'paginated_model/Meta.dart';
import 'paginated_model/PaginatedModel.dart';

class Asset{
  final int id;
  final int entitiesId;
  final int? userId;
  final int? ticketId;
  final String brand;
  final String model;
  final String serialNumber;
  final int assetStatusId;
  final String purchaseDate;
  final int warrantyMonths;
  final double purchasePrice;
  final int? assetTypeId;

  const Asset({
    required this.id,
    required this.entitiesId,
    this.userId,
    this.ticketId,
    required this.brand,
    required this.model,
    required this.serialNumber,
    required this.assetStatusId,
    required this.purchaseDate,
    required this.warrantyMonths,
    required this.purchasePrice,
    this.assetTypeId,
  });

  factory Asset.fromJson(Map<String, dynamic> json){
    return Asset(
      id: json['id'],
      entitiesId: json['entities_id'],
      userId: json['user_id'],
      ticketId: json['tickets_id'],
      brand: json['brand'],
      model: json['model'],
      serialNumber: json['serial_number'],
      assetStatusId: json['assets_status'],
      purchaseDate: json['purchase_date'],
      warrantyMonths : json['warranty_months'],
      purchasePrice: json['purchase_price'].toDouble(),
      assetTypeId: json['asset_type'],
    );
  }

  static Future<Asset?> get(int id) async{
    try{
      var res = await ClientApi.get("assets/$id");
      if(res.statusCode != 200){
        switch(res.statusCode){
          case 401:
            throw Exception("Unauthenticated");
          case 500:
            throw Exception("Internal Server Error");
        }
      }
      return Asset.fromJson(jsonDecode(res.body));
    }on Exception catch(e){
      return null;
    }
  }

  static Future<List<Asset>> getAll() async{
    List<Asset> tempAssets = <Asset>[];
    var res = await ClientApi.get("assets");
    for(var assetJson in jsonDecode(res.body)['data']){
      Asset asset = Asset.fromJson(assetJson);
      tempAssets.add(asset);
    }
    return tempAssets;
  }

  static getPaginated(int paginate, int page, String search) async {
    var res = await ClientApi.get("assets?paginate=$paginate&page=$page${(search != "" ? "&search=$search" : "")}");
    dynamic json = jsonDecode(res.body);
    List<Asset> data = <Asset>[];
    for(var entityJson in json['data']){
      Asset asset = Asset.fromJson(entityJson);
      data.add(asset);
    }
    return PaginatedModel(
      data: data,
      meta: Meta.fromJson(json['meta']),
    );
  }

  static create(String serialNumber, String brand, String model, String date, double price, int warrantyMonths) async {
    int entityId = GetStorage().read('user_entity_id');
    var res = await ClientApi.post('assets', jsonEncode(<String, dynamic>{
      'serial_number' : serialNumber,
      'brand' : brand,
      'model' : model,
      'purchase_date' : date,
      'purchase_price' : price,
      'warranty_months' : warrantyMonths,
      'assets_status_id' : 1,
      'assets_types_id' : 1,
      'user_entity_id' : entityId,
    }));
  }

  static void remove(int assetId) async{
    await ClientApi.remove('assets/$assetId');
  }

  @override
  String toString() {
    return "Asset #" + id.toString() + " - " + brand + " " + model + " - #" + serialNumber;
  }

  static void update(int id, String serialNumber, String brand, String model, String date, String price, int warranty, int statusId) async {
    var res = await ClientApi.update('assets/$id', jsonEncode(<String, dynamic>{
      'serial_number' : serialNumber,
      'brand' : brand,
      'model' : model,
      'purchase_date' : date,
      'purchase_price' : price,
      'warranty_months' : warranty,
      'assets_status_id' : statusId,
    }));
  }


}