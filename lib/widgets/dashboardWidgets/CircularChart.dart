import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../consts.dart';
import '../../models/Asset.dart';
import '../../models/AssetStatus.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
    required this.assets,
    required this.assetStatus,
    required this.contextToBeUsed
  }) : super(key: key);
  final List<Asset> assets;
  final List<AssetStatus> assetStatus;
  final String contextToBeUsed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: List<PieChartSectionData>.generate(assetStatus.length, (index) {
                var value = (assets.where((element) => element.assetStatusId
                    == assetStatus[index].id).toList().length/assets.length)*100;
                return PieChartSectionData(
                  color: assetStatus[index].statusColor,
                  value: value,
                  showTitle: false,
                  radius: value*0.2+5
                );
              }),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  "${assets.length}\n\n$contextToBeUsed",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    height: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



