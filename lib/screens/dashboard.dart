import 'package:sma_frontend/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sma_frontend/screens/side_menu.dart';
import 'package:provider/provider.dart';

import '../../consts.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width < 1000 ? AppBar(
          title: const Text ("Dashboard"),
          backgroundColor: bgColor,) : null,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
              // It takes 5/6 part of the screen
            Expanded(
              // It takes 5/6 part of the screen
              flex: 6,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
