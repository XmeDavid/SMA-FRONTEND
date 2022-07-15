import 'package:flutter/material.dart';
import 'package:sma_frontend/models/Asset.dart';

import '../../consts.dart';
import 'CircularChart.dart';
import 'AssetsInfoCard.dart';

class AssetsDashboardCart extends StatefulWidget {
  const AssetsDashboardCart({Key? key}) : super(key: key);

  @override
  State<AssetsDashboardCart> createState() => _AssetsDashboardCartState();
}

class _AssetsDashboardCartState extends State<AssetsDashboardCart> {

  late List<Asset> assets;
  bool isAssetsLoaded = false;

  void loadAssets() async {
    var tempAssets = await Asset.getAll();
    setState(() {
      assets = tempAssets;
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
      decoration: BoxDecoration(
        color: secondColor3,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Assets Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          AssetInfoCard(
            assetStatusColor: Colors.red,
            assetStatusTitle: "Fetch assets types or status",
            assetsQnty: 0,
          ),
          AssetInfoCard(
            assetStatusColor: Colors.yellow,
            assetStatusTitle: "Fetch assets types or status",
            //Enviar conforme o tipo/status do asset
            assetsQnty: 1,
          ),
          AssetInfoCard(
            assetStatusColor: Colors.blue,
            assetStatusTitle: "Fetch assets types or status",
            assetsQnty: 2,
          ),
          AssetInfoCard(
            assetStatusColor: Colors.green,
            assetStatusTitle: "Fetch assets types or status",
            assetsQnty: 3,
          ),
        ],
      ),
    );
  }
}

