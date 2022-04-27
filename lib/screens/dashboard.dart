import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key,}) : super(key: key);

  @override
  State<DashboardPage> createState() => _MyDashboardPageState();
}

class _MyDashboardPageState extends State<DashboardPage> {
  /**
   * Search later, something to do with the state
   * Might be usefull to define the user state after login idk
   *
      int _stateVariable = 0;
      void _loginFunction() {
      setState(() {
      _stateVariable++;
      });
      }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        MyFiles(),
                        SizedBox(height: defaultPadding),
                        RecentFiles(),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context)) StarageDetails(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                  if (!Responsive.isMobile(context)) Expanded(
                    flex: 2,
                    child: StarageDetails(),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );

  }
}