import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sma_frontend/screens/login.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image.asset("assets/logo.png"),
          ),
          ExpansionTile(
            title: const Text("Tickets"),
            leading: const Icon(Icons.dashboard),
            children: <Widget>[
              ListTile(
                title: const Center(
                  child: Text(
                    "Create Ticket",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onTap: (){
                Navigator.pushNamed(context, '/tickets/new');
              },),
              const ListTile(
                title:  Center(
                  child: Text(
                    "See Unassigned Ticket",
                    style: TextStyle(fontSize: 12),),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("Tasks"),
            leading: const Icon(Icons.dashboard),
            children: <Widget>[
              ListTile(
                title: const Center(
                  child: Text(
                    "Create Task",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage(title: "Login Page")),
                  );
                },),
              const ListTile(
                title: Center(
                  child: Text(
                    "See My Ticket",
                    style: TextStyle(fontSize: 12),),
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.devices),
            title: const Text("Assets"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Contracts"),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
