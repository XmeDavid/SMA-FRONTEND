import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/screens/entities/list.dart';
import 'package:sma_frontend/screens/auth/login.dart';

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
                    Get.toNamed( "/");
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
                      Get.toNamed(
                        "/tickets/new",
                      );
                    },),
                  ListTile(
                    title: Text(
                      "Tickets",
                      style: TextStyle(fontSize: 12),),
                    onTap: (){
                      Get.toNamed(
                        "/tickets/",
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text("Tasks"),
                leading: const Icon(Icons.task_alt),
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      "Create Task",
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: (){
                      Get.toNamed('nothing yet');
                    },),
                  const ListTile(
                    title: Text(
                      "Tasks",
                      style: TextStyle(fontSize: 12),),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.devices),
                title: const Text("Assets"),
                onTap: (){},
              ),
              ExpansionTile(
                title: const Text("Contracts"),
                leading: const Icon(Icons.history_edu),
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      "New Contract",
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: (){
                      Get.toNamed(
                        "/contracts/create",
                      );
                    },),
                  ListTile(
                    title: const Text(
                      "Contracts",
                      style: TextStyle(fontSize: 12),),
                    onTap: (){
                      Get.toNamed(
                        "/contracts",
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.groups),
                title: const Text("Entities"),
                onTap: (){
                  Get.toNamed('/entities');
                },
              ),
              ExpansionTile(
                title: const Text("Users"),
                leading: const Icon(Icons.person),
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      "Register User",
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: (){
                      Get.toNamed(
                        "/users/register",
                      );
                    },),
                  ListTile(
                    title: const Text(
                      "Users",
                      style: TextStyle(fontSize: 12),),
                    onTap: (){
                      Get.toNamed(
                        "/users",
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
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
                              title: Text(GetStorage().read('user_first_name') ?? "User"),
                              onTap: (){
                                Get.toNamed('/users/me');
                              },
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
