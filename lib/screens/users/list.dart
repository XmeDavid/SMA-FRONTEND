import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/paginated_model/Meta.dart';
import 'package:sma_frontend/models/paginated_model/PaginatedModel.dart';
import 'package:sma_frontend/widgets/ui_fields.dart';

import '../../models/User.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../side_menu.dart';

class ListUsersScreen extends StatefulWidget {
  const ListUsersScreen({Key? key}) : super(key: key);

  @override
  State<ListUsersScreen> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsersScreen> {
  PaginatedModel<User> paginatedUserModel = const PaginatedModel(
      data: [],
      meta: Meta(
          current_page: -1,
          from: -1,
          last_page: -1,
          path: "",
          per_page: 0,
          to: -1,
          total: -1));

  var searchController = TextEditingController();

  void loadUsers(int page) async {
    var tempUserPaginatedModel = await User.getPaginated(true,20,page,"");
    setState(() {
      paginatedUserModel = tempUserPaginatedModel;
    });
  }

  removeClick(User u) {
    Contract.remove(u.id);
    setState(() {
      paginatedUserModel.data.removeAt(paginatedUserModel.data
          .indexWhere((element) => element.id == u.id));
    });
  }

  detailsClick(User u) {
    Get.toNamed("/users/" + u.id.toString());
  }

  @override
  void initState() {
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadUsers(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(title: const Text("Users"), backgroundColor: bgColor)
          : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: paginatedUserModel.meta.current_page != -1 ? Responsive.isDesktop(context) ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 6,
              child: Center(
                  child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: thirdColor5,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 60,
                    width: MediaQuery.of(context).size.width *
                        (Responsive.isDesktop(context) ? 0.8 : 0.95),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text(
                            "Filters",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text(
                            "Entity Type:",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          /*child: DropdownButton(
                                    items: entityTypes.map((e) => DropdownMenuItem(value: e.id,child: Text(e.name))).toList(),
                                    onChanged: (dynamic newValue){
                                      setState(() {
                                        _selectedFilterEntityTypeId = newValue;
                                      });
                                      loadContracts(paginatedContractModel.meta.current_page);
                                    },
                                    value: _selectedFilterEntityTypeId,
                                    underline: DropdownButtonHideUnderline(child: Container(),),
                                  ),*/
                        ),
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: SizedBox(
                            width: (!Responsive.isDesktop(context)
                                ? MediaQuery.of(context).size.width * 0.15
                                : 160),
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Search"),
                              onChanged: (e) {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed("/users/register");
                            },
                            child: const Text(
                              "New User",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(firstColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                        color: secondColor3,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: MediaQuery.of(context).size.height - 164,
                    width: MediaQuery.of(context).size.width *
                        (Responsive.isDesktop(context) ? 0.8 : 0.95),
                    child: SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, //child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: 7,
                              columns: [
                                "ID",
                                "NAME",
                                "ENTITY",
                                "PHONE NO.",
                                "EMAIL",
                                "BLOCKED",
                                "LAST LOGIN",
                                "ACTIONS"
                              ].map((e) {
                                return DataColumn(
                                    label: Expanded(child: Text(e, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))));
                              }).toList(),
                              rows: List.generate(
                                  paginatedUserModel.data.length, (index) {
                                return DataRow(cells: [
                                  DataCell(SelectableText(
                                      paginatedUserModel
                                                .data[index].id
                                                .toString(), textAlign: TextAlign.center),
                                  ),
                                  DataCell(SelectableText(
                                      paginatedUserModel
                                              .data[index].fullName(), textAlign: TextAlign.center),
                                  ),
                                  DataCell(SelectableText(
                                      paginatedUserModel
                                          .data[index].entity?.name ?? '-', textAlign: TextAlign.center)),
                                  DataCell(
                                    SelectableText(
                                        paginatedUserModel
                                                .data[index].phoneNumber ?? "-", textAlign: TextAlign.center),
                                  ),
                                  DataCell(
                                    SelectableText(
                                        paginatedUserModel
                                                .data[index].email, textAlign: TextAlign.center),
                                  ),
                                  DataCell(
                                    SelectableText(
                                        paginatedUserModel
                                                .data[index].blockedAt != null ? "No" : "Yes", textAlign: TextAlign.center),
                                  ),
                                  DataCell(
                                    SelectableText(
                                        paginatedUserModel.data[index].lastLoginAt ?? '-', textAlign: TextAlign.center),
                                  ),
                                  DataCell(Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: TextButton(
                                          onPressed: () {
                                            detailsClick(paginatedUserModel
                                                .data[index]);
                                          },
                                          child: const Text(
                                            "Details",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(firstColor),
                                          ),
                                        ),
                                  )),
                                ]);
                              }),
                            ),
                        ))),

                        PaginatedNavigation(paginatedModel: paginatedUserModel, callback: loadUsers),

                //)
              ])),
            ),
          ],
        ) : Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              color: const Color.fromRGBO(51, 52, 67, 1),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.all(smallPadding),
                        child: SizedBox(
                          width: 160,
                          height: 30,
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Search"),
                            onChanged: (e) {
                              loadUsers(paginatedUserModel
                                  .meta.current_page);
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding:
                        const EdgeInsets.all(smallPadding),
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed("/users/register");
                          },
                          child: const Text(
                            "Register New User",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                firstColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        const Spacer(),
                        PaginatedNavigation(paginatedModel: paginatedUserModel, callback: loadUsers),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            (true) ? SizedBox(
              height: MediaQuery.of(context).size.height - 146,
              child: ListView.builder(
                itemCount: paginatedUserModel.data.length-1,
                itemBuilder: (context, index) {
                  final user = paginatedUserModel.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        clipBehavior: Clip.hardEdge,
                        child: ListTile(
                          trailing: const Icon(Icons.arrow_forward),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          tileColor: cardColor,
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.person),
                              VerticalDivider(),
                            ],),
                          textColor: Colors.grey,
                          title: Text(user.fullName(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          subtitle: Text(
                            user.email,
                          ),
                          onTap: () {
                            detailsClick(user);
                          },
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ) : Center(child: Text('No Data Found'),),
          ],
        ): const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
