import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/consts.dart';
import 'package:sma_frontend/responsive.dart';
import 'package:sma_frontend/screens/side_menu.dart';

import '../../models/Role.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  State<RoleScreen> createState() => _RoleState();
}

class _RoleState extends State<RoleScreen> {

  void loadRoles() async{
    String? link = Get.parameters['role'];
    if(link == null){
      Get.toNamed('/settings/roles');
      return;
    }
    setState((){
      roleIndex = link != 'default' ? int.parse(link) : -1;
    });
    var _roles = await Role.all();
    setState((){
      roles = _roles;
      rolesLoaded = true;
      roleName.text = roleIndex != -1 ? roles[roleIndex].name : 'Default';
    });
  }

  @override
  void initState() {
    super.initState();
    loadRoles();
  }


  bool rolesLoaded = false;
  late List<Role> roles;
  int roleIndex = -1;

  var roleName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? AppBar(
        title: const Text("Settings"),
        backgroundColor: bgColor,
      ) : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Responsive.isDesktop(context) ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(child: SideMenu(), width: 200,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07)
              ),
              height: MediaQuery.of(context).size.height,
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(
                    width: 180,
                    height: 60,
                    child: Center(
                      child: Text("Settings",
                        style: TextStyle(
                          fontSize: 32
                        ),
                      ),
                    )
                  ),
                  const Divider(),
                  SizedBox(
                    width: 180,
                    height: 32,
                    child: TextButton(
                        onPressed: (){ /** GENERAL Settings */
                          return;
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Text("General",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.7)
                              ),
                            ),
                            const Spacer()
                          ],
                        )
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    width: 180,
                    height: 32,
                    child: TextButton(
                      onPressed: (){ /** ROLES Settings */
                        return;
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 8),
                          Text("Roles",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Spacer()
                        ],
                      )
                    ),
                  ),
                  rolesLoaded ? SizedBox(
                    width: 180,
                    height: 20 * roles.length.toDouble(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(roles.length, (index){
                        return SizedBox(
                          width: 180,
                          height: 20,
                          child: TextButton(
                              onPressed: (){ /** Each role */
                                Get.toNamed('/settings/roles/${roles[index].id}');
                              },
                              child: Row(
                                children: [
                                  const SizedBox(width: 24),
                                  Text(roles[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white.withOpacity(0.7)
                                    ),
                                  ),
                                  const Spacer()
                                ],
                              )
                          ),
                        );
                      }),
                    ),
                  ) : const SizedBox(),
                  const Divider(),
                  SizedBox(
                    width: 180,
                    height: 32,
                    child: TextButton(
                        onPressed: (){ /** GENERAL Settings */
                          return;
                        },
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Text("Future option",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.7)
                              ),
                            ),
                            const Spacer()
                          ],
                        )
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 1200 ? MediaQuery.of(context).size.width * 0.5 : 600,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(roleName.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32
                        ),
                      ),
                    ],
                  )
                ),
              )
            ),
          ],
        ) : /** MOBILE */
        const Text("data"),
      ),
    );
  }
}
