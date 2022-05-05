import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sma_frontend/screens/dashboard.dart';
import 'package:sma_frontend/screens/login.dart';
import 'package:sma_frontend/screens/tickets/TicketDetailsScreen.dart';
import 'package:sma_frontend/screens/tickets/new_ticket_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'consts.dart';

void main() async{
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
        '/tickets/details' : (context) => const TicketDetails(),
      },
    );
  }
}


