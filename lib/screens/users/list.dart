import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/paginated_model/Meta.dart';
import 'package:sma_frontend/models/paginated_model/PaginatedModel.dart';

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

  bool isClient() {
    return false;
  }

  void loadUsers(int page) async {
    var tempUserPaginatedModel =
        await User.getPaginated(true,20,page,"");
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
    super.initState();
    loadUsers(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(title: const Text("Contracts"), backgroundColor: bgColor)
          : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: paginatedUserModel.meta.current_page != -1 ? Row(
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
                                  DataCell(Row(
                                    children: [
                                      Padding(
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
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: TextButton(
                                          onPressed: () {
                                            removeClick(paginatedUserModel
                                                .data[index]);
                                          },
                                          child: const Text(
                                            "Remove",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                                ]);
                              }),
                            ),
                        ))),
                Row(
                  children: [
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Spacer(),
                    ),
                    if (paginatedUserModel.meta.current_page != 1)
                      TextButton(
                        onPressed: () {
                          loadUsers(1);
                        },
                        child: const Text(
                          "<<",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (paginatedUserModel.meta.current_page != 1)
                      TextButton(
                          onPressed: () {
                            loadUsers(
                                paginatedUserModel.meta.current_page - 1);
                          },
                          child: const Text(
                            "<",
                            style: TextStyle(color: Colors.white),
                          )),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: TextButton(
                          onPressed: null,
                          child: Text(
                            paginatedUserModel.meta.current_page.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                    if (paginatedUserModel.meta.current_page !=
                        paginatedUserModel.meta.last_page)
                      TextButton(
                          onPressed: () {
                            loadUsers(
                                paginatedUserModel.meta.current_page + 1);
                          },
                          child: const Text(
                            ">",
                            style: TextStyle(color: Colors.white),
                          )),
                    if (paginatedUserModel.meta.current_page !=
                        paginatedUserModel.meta.last_page)
                      TextButton(
                          onPressed: () {
                            loadUsers(
                                paginatedUserModel.meta.last_page);
                          },
                          child: const Text(
                            ">>",
                            style: TextStyle(color: Colors.white),
                          )),
                    const Spacer(),
                  ],
                )
                //)
              ])),
            ),
          ],
        ) : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
