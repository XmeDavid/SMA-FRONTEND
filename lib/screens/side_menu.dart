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
      child: Column(
        children: [
          Expanded(child:
          ListView(
            children: <Widget>[
              DrawerHeader(
                child: TextButton(
                  child : Image.asset("assets/logo.png"),
                  onPressed: (){
                    Navigator.pushNamed(context, "/");
                  },
                ),
              ),
              ExpansionTile(
                title: Text("Tickets"),
                leading: Icon(Icons.assignment),
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      "Create Ticket",
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        "/tickets/new",
                      );
                    },),
                  ListTile(
                    title: Text(
                      "See Unassigned Ticket",
                      style: TextStyle(fontSize: 12),),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text("Tasks"),
                leading: Icon(Icons.task_alt),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Create Task",
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage(title: "Login Page")),
                      );
                    },),
                  ListTile(
                    title: Text(
                      "See My Ticket",
                      style: TextStyle(fontSize: 12),),
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
          ),
          Container(
            // This align moves the children to the bottom
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  // This container holds all the children that will be aligned
                  // on the bottom and should not scroll with the above ListView
                  child: Container(
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          ListTile(
                              leading: Icon(Icons.person),
                              title: Text('User'),
                          ),
                        ],
                      )
                  )
              )
          )
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
