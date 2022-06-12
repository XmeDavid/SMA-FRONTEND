import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sma_frontend/screens/auth/confirm.dart';
import 'package:sma_frontend/screens/auth/mfa.dart';
import 'package:sma_frontend/screens/contracts/create.dart';
import 'package:sma_frontend/screens/contracts/details.dart';
import 'package:sma_frontend/screens/contracts/list.dart';
import 'package:sma_frontend/screens/dashboard.dart';
import 'package:sma_frontend/screens/entities/details.dart';
import 'package:sma_frontend/screens/entities/create.dart';
import 'package:sma_frontend/screens/entities/list.dart';
import 'package:sma_frontend/screens/auth/login.dart';
import 'package:sma_frontend/screens/tickets/TicketDetailsScreen.dart';
import 'package:sma_frontend/screens/tickets/new_ticket_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sma_frontend/screens/users/create.dart';
import 'package:sma_frontend/screens/users/details.dart';
import 'package:sma_frontend/screens/users/list.dart';
import 'consts.dart';
import 'screens/auth/recovery.dart';

void main() async{
  await dotenv.load();
  runApp(const SMA());
}

class SMA extends StatelessWidget {
  const SMA({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMA - Support Management Application',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: bgColor,
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/', page: () => DashboardScreen()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/auth/mfa', page: () => const MfaScreen()),
        GetPage(name: '/password/reset', page: () => const ResetPasswordScreen()),
        GetPage(name: '/password/recovery', page: () => const RecoverPasswordScreen()),
        GetPage(name: '/users', page: () => const ListUsersScreen()),
        GetPage(name: '/users/register', page: () => const RegisterUserScreen()),
        GetPage(name: '/users/:id', page: () => const UserDetailsScreen()),
        GetPage(name: '/entities', page: () => const ListEntities()),
        GetPage(name: '/entities/create', page: () => const NewEntityScreen()),
        GetPage(name: '/entities/:id', page: () => const EntityDetailsScreen()),
        GetPage(name: '/contracts/create', page: () =>  const NewContractScreen()),
        GetPage(name: '/contracts/:id', page: () => const ContractsDetailsScreen()),
        GetPage(name: '/contracts/', page: () => const ListContracts()),
        GetPage(name: '/tickets/new', page: () => const NewTicketScreen()),
        GetPage(name: '/tickets/details', page: () => const TicketDetails()),

      ],
    );
  }
}


