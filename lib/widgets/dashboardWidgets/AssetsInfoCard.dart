import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../consts.dart';

class AssetInfoCard extends StatelessWidget {
  const AssetInfoCard({
    Key? key,
    required this.assetStatusTitle,
    required this.assetStatusColor,
    required this.assetsQnty,
  }) : super(key: key);

  final String assetStatusTitle;
  final Color assetStatusColor;
  final int assetsQnty;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: bgColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Icon(Icons.circle, color: assetStatusColor),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assetStatusTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$assetsQnty",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
