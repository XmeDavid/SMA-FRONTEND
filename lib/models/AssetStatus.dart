import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/api_interactions/api_functions.dart';

import 'paginated_model/Meta.dart';
import 'paginated_model/PaginatedModel.dart';

class AssetStatus {
  final int id;
  final String name;
  final String description;


  const AssetStatus({
    required this.id,
    required this.name,
    required this.description
  });

  factory AssetStatus.fromJson(Map<String, dynamic> json){
    return AssetStatus(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  static Future<List<AssetStatus>> getAll() async {
    List<AssetStatus> tempStatus = <AssetStatus>[];
    var res = await ClientApi.get("assets/status");
    for (var statusJson in jsonDecode(res.body)['data']) {
      AssetStatus status = AssetStatus.fromJson(statusJson);
      tempStatus.add(status);
    }
    return tempStatus;
  }
}
