import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sma_frontend/screens/assets/details.dart';
import 'package:sma_frontend/screens/assets/list.dart';
import 'package:sma_frontend/screens/assets/new.dart';

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
import 'package:sma_frontend/screens/settings/role.dart';
import 'package:sma_frontend/screens/settings/roles.dart';
import 'package:sma_frontend/screens/settings/settings.dart';
import 'package:sma_frontend/screens/tickets/details.dart';
import 'package:sma_frontend/screens/tickets/list.dart';
import 'package:sma_frontend/screens/tickets/new.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sma_frontend/screens/users/create.dart';
import 'package:sma_frontend/screens/users/details.dart';
import 'package:sma_frontend/screens/users/list.dart';
import 'consts.dart';
import 'screens/auth/recovery.dart';
import 'screens/tasks/details.dart';

void main() async{
  await dotenv.load();
  await GetStorage.init();
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
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/auth/mfa', page: () => const MfaScreen()),
        GetPage(name: '/password/reset', page: () => const ResetPasswordScreen()),
        GetPage(name: '/password/recovery', page: () => const RecoverPasswordScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
        GetPage(name: '/settings/roles', page: () => const RolesScreen()),
        GetPage(name: '/settings/roles/:role', page: () => const RoleScreen()),
        GetPage(name: '/users', page: () => const ListUsersScreen()),
        GetPage(name: '/users/register', page: () => const RegisterUserScreen()),
        GetPage(name: '/users/me', page: () => const UserDetailsScreen()),
        GetPage(name: '/users/:id', page: () => const UserDetailsScreen()),
        GetPage(name: '/entities', page: () => const ListEntities()),
        GetPage(name: '/entities/create', page: () => const NewEntityScreen()),
        GetPage(name: '/entities/:id', page: () => const EntityDetailsScreen()),
        GetPage(name: '/contracts/create', page: () =>  const NewContractScreen()),
        GetPage(name: '/contracts/:id', page: () => const ContractsDetailsScreen()),
        GetPage(name: '/contracts/', page: () => const ListContracts()),
        GetPage(name: '/tickets', page: () => const ListTicketScreen()),
        GetPage(name: '/tickets/new', page: () => const NewTicketScreen()),
        GetPage(name: '/tickets/:id', page: () => const TicketDetails()),
        GetPage(name: '/tickets/:ticket/tasks/:id', page: () => const TaskDetailsScreen()),
        GetPage(name: '/assets', page: () => const ListAssetsScreen()),
        GetPage(name: '/assets/new', page: () => const NewAssetScreen()),
        GetPage(name: '/assets/:id', page: () => const AssetDetailsScreen()),
      ],
    );
  }
}


