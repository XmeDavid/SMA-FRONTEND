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
      roleId = link != 'default' ? int.parse(link) : -1;
    });
    var _roles = await Role.all();
    setState((){
      roles = _roles;
      rolesLoaded = true;
      roleName.text = roleId != -1 ? roles.where((element) => element.id == roleId).first.name : 'Default';
    });
  }

  @override
  void initState() {
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadRoles();
  }

  bool isEditMode = false;

  bool rolesLoaded = false;
  late List<Role> roles;
  int roleId = -1;

  var roleName = TextEditingController();
  var search = TextEditingController();

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
                          Get.toNamed('/settings');
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
                        Get.toNamed('/settings/roles');
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Text("Roles",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(0.6)
                            ),
                          ),
                          const Spacer()
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
                                        color: roles[index].id == roleId ? Colors.white : Colors.white.withOpacity(0.6)
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
                      TextField(
                        enabled: true,
                        controller: roleName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState((){
                              });
                            },
                            icon: const Icon(Icons.save)
                          )
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          //const SizedBox(width: 10),
                          Text("Here you can change the permissions for the role ${roleName.text}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7)
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                          padding: const EdgeInsets.only(
                              left: 16,
                              bottom: 2
                          ),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              color: Colors.black.withOpacity(0.2)
                          ),
                          width: MediaQuery.of(context).size.width > 1200 ? MediaQuery.of(context).size.width * 0.5 : 600,
                          height: 40,
                          child: TextField(
                            controller: search,
                            decoration: const InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.search),
                            ),
                          )
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          Text("Search a permission",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7)
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: (){},
                            child: const Text('Clear permissions',
                              style: TextStyle(
                                fontSize: 12
                              ),
                            )
                          ),
                        ],
                      ),
                      Center(
                        child: IconButton(
                          onPressed: (){
                            setState((){
                              isEditMode = !isEditMode;
                            });
                          },
                          icon: Icon(isEditMode ? Icons.toggle_off : Icons.toggle_on,
                            size: 50,
                            color: isEditMode ? Colors.green : Colors.redAccent,
                          )
                        ),
                      )
                    ],
                  )
                ),
              )
            ),
          ],
        ) : /** MOBILE */
        const Text("A implementar no futuro"),
      ),
    );
  }
}
