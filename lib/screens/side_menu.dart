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
            title: Text("Tickets"),
            leading: Icon(Icons.dashboard),
            children: <Widget>[
              ListTile(
                title: const Center(
                  child: Text(
                    "Create Ticket",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage(title: "Login Page")),
                );
              },),
              ListTile(
                title: const Center(
                  child: Text(
                    "See Unassigned Ticket",
                    style: TextStyle(fontSize: 12),),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Tasks"),
            leading: Icon(Icons.dashboard),
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
              ListTile(
                title: const Center(
                  child: Text(
                    "See My Ticket",
                    style: TextStyle(fontSize: 12),),
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.devices),
            title: Text("Assets"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text("Contracts"),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
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
