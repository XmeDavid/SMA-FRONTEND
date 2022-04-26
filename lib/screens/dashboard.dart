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
    return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text("DashboardPage"),
          ),
        )
    );

  }
}