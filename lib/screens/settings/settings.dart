import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sma_frontend/consts.dart';
import 'package:sma_frontend/responsive.dart';
import 'package:sma_frontend/screens/side_menu.dart';

import '../../models/Role.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {

  void loadRoles() async{
    var _roles = await Role.all();
    setState((){
      roles = _roles;
      rolesLoaded = true;
    });
  }

  void create(){

  }

  @override
  void initState() {
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadRoles();
  }

  bool rolesLoaded = false;
  late List<Role> roles;

  var searchRole = TextEditingController();

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
                          children: const [
                            SizedBox(width: 8),
                            Text("General",
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
                                        color: Colors.white.withOpacity(0.6)
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
                      const SizedBox(
                        height: 40,
                      ),
                      const Text("Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32
                        ),
                      ),
                      Text("Change the settings of the application to change the app behavior",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7)
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width > 1200 ? MediaQuery.of(context).size.width * 0.5 : 600,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white.withOpacity(0.1)
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Icon(Icons.supervised_user_circle_sharp,
                                size: 40,
                                color: Colors.white.withOpacity(0.8),
                              )
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Text("Default Permissions",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withOpacity(0.8)
                                  ),
                                ),
                                Text("Default permissions apply to all users unless otherwise specified",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: (){
                                Get.toNamed('/settings/roles/default');
                              },
                              icon: const Icon(Icons.arrow_forward_ios)
                            ),
                            const SizedBox(width: 12,)
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              left: 16,
                              bottom: 2
                            ),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: Colors.black.withOpacity(0.2)
                            ),
                            width: MediaQuery.of(context).size.width > 1200 ? MediaQuery.of(context).size.width * 0.5 - 130: 470,
                            height: 40,
                            child: TextField(
                              controller: searchRole,
                              decoration: const InputDecoration(
                                hintText: "Search",
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.search),
                              ),
                            )
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: firstColor
                            ),
                            width: 120,
                            height: 40,
                            child: TextButton(
                              onPressed: (){
                                create();
                              },
                              child: const Text("Create Role",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 300,
                            child: Text("Roles - ${rolesLoaded ? roles.length : 0}",
                              style: const TextStyle(
                                  fontSize: 12
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 300,
                            child: Text("Users",
                              style: TextStyle(
                                  fontSize: 12
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      rolesLoaded ? SizedBox(
                        height: MediaQuery.of(context).size.height - 316,
                        child: Column(
                          children: List.generate(roles.length * 2, (index){
                            return index % 2 == 0 || roles.length == index ? Row(
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Text(roles[index~/2].name,
                                    style: const TextStyle(
                                        fontSize: 12
                                    ),
                                  ),
                                ),
                                Text("${roles[index~/2].usersInRole}",
                                  style: const TextStyle(
                                    fontSize: 16
                                  ),
                                ),
                                const Icon(Icons.person),
                                const Spacer(),
                                IconButton(
                                  onPressed: (){
                                    Get.toNamed('/settings/roles/${index~/2}');
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios)
                                )
                              ],
                            ) : const Divider();
                          }),
                        )
                      ) : const SizedBox(),
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
