import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sma_frontend/consts.dart';

import '../config.dart';
import '../responsive.dart';

class TicketCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color color;

  TicketCard({required this.icon, required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isMobile(context) ? 64 : 128,
      constraints: BoxConstraints(minWidth: Responsive.isDesktop(context) ? 250 : SizeConfig.screenWidth/2-40),
      padding: EdgeInsets.only(
          top: 20, bottom: 20, left: 20, right: Responsive.isMobile(context) ? 20 : 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: secondColor3,
          border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 35,
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Text(label),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Text(amount),
        ],
      ),);
  }
}