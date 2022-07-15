import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Asset.dart';

import '../../consts.dart';
import '../../models/AssetStatus.dart';
import 'CircularChart.dart';
import 'AssetsInfoCard.dart';

class AssetsDashboardCard extends StatefulWidget {
  const AssetsDashboardCard({Key? key}) : super(key: key);

  @override
  State<AssetsDashboardCard> createState() => _AssetsDashboardCardState();
}

class _AssetsDashboardCardState extends State<AssetsDashboardCard> {

  late List<Asset> assets;
  List<AssetStatus> status = [];
  bool isAssetsLoaded = false;

  void loadAssets() async {
    var _status = await AssetStatus.getAll();
    var _tempAssets = await Asset.getAll();
    setState(() {
      status = _status.map((status) => AssetStatus(id: status.id, name: status.name, description: status.description,
          statusColor: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1))).toList();
      assets = _tempAssets;
      isAssetsLoaded = true;
    });
  }

  @override
  void initState() {
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondColor3,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: isAssetsLoaded ? Column(
        children: [
          Chart(assets: assets, assetStatus: status, contextToBeUsed: 'Assets'),
          Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(status.length, (index) {
                  return AssetInfoCard(
                    assetStatusColor: status[index].statusColor!,
                    assetStatusTitle: status[index].name,
                    assetsQnty: assets.where((asset) => asset.assetStatusId == status[index].id).length,
                  );
                })
            ),
          )
        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}

