import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sma_frontend/screens/dashboard.dart';
import 'package:sma_frontend/screens/login.dart';
import 'package:sma_frontend/screens/new_ticket_screen.dart';

import 'consts.dart';

void main() {
  runApp(const SMA());
}

class SMA extends StatelessWidget {
  const SMA({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMA - Support Management Application',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: bgColor,
      ),
      initialRoute: '/login',
      routes: {
        '/' : (context) => DashboardScreen(),
        '/login' : (context) => const LoginPage(title: "Login Page",),
        '/tickets/new' : (context) => const NewTicketScreen(),
      },
    );
  }
}


