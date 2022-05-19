import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/paginated_model/Meta.dart';
import 'package:sma_frontend/models/paginated_model/PaginatedModel.dart';

import '../../responsive.dart';
import '../../consts.dart';
import '../side_menu.dart';

class ListContracts extends StatefulWidget {
  const ListContracts({Key? key}) : super(key: key);

  @override
  State<ListContracts> createState() => _ListContracts();
}

class _ListContracts extends State<ListContracts> {
  PaginatedModel<Contract> paginatedContractModel = const PaginatedModel(
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

  void loadContracts(int page) async {
    var tempContractPaginatedModel =
        await Contract.getPaginated(true, 20, page, "");
    setState(() {
      paginatedContractModel = tempContractPaginatedModel;
    });
  }

  removeClick(Contract e) {
    Contract.remove(e.id);
    setState(() {
      paginatedContractModel.data.removeAt(paginatedContractModel.data
          .indexWhere((element) => element.id == e.id));
    });
  }

  detailsClick(Contract e) {
    Get.toNamed("/contracts/" + e.id.toString());
  }

  @override
  void initState() {
    super.initState();
    loadContracts(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(title: const Text("Contracts"), backgroundColor: bgColor)
          : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Responsive.isDesktop(context)
            ? Row(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding),
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
                                    Get.toNamed("/contracts/create");
                                  },
                                  child: const Text(
                                    "New Contract",
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
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          decoration: const BoxDecoration(
                              color: secondColor3,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: MediaQuery.of(context).size.height - 164,
                          width: MediaQuery.of(context).size.width *
                              (Responsive.isDesktop(context) ? 0.8 : 0.95),
                          child: SingleChildScrollView(
                              scrollDirection: Axis
                                  .horizontal, //child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: SingleChildScrollView(
                                child: Expanded(
                                  child: DataTable(
                                    columnSpacing: 3,
                                    columns: [
                                      "Id",
                                      "Title",
                                      //"Description",
                                      "Start Date",
                                      "End Date",
                                      "Duration",
                                      //"Cover",
                                      //"Auto\nRenovation",
                                      "Last Renovation",
                                      "Budget",
                                      //"Allow\nSurplus",
                                      "Is Validated",
                                      "Actions"
                                    ].map((e) {
                                      return DataColumn(
                                          label: Expanded(child: Text(e)));
                                    }).toList(),
                                    rows: List.generate(
                                        paginatedContractModel.data.length,
                                        (index) {
                                      return DataRow(cells: [
                                        DataCell(
                                          Expanded(
                                              child: SelectableText(
                                                  paginatedContractModel
                                                      .data[index].id
                                                      .toString())),
                                        ),
                                        DataCell(
                                          Expanded(
                                            child: SelectableText(
                                                paginatedContractModel
                                                    .data[index].title),
                                          ),
                                        ),
                                        /*Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: */

                                        //],
                                        //)),
                                        //)),
                                        /*DataCell(SelectableText(paginatedContractModel
                                    .data[index].description)),*/
                                        DataCell(
                                          Expanded(
                                              child: SelectableText(
                                                  paginatedContractModel
                                                      .data[index].startDate)),
                                        ),
                                        DataCell(
                                          Expanded(
                                              child: SelectableText(
                                                  paginatedContractModel
                                                      .data[index].endDate)),
                                        ),
                                        DataCell(
                                          Expanded(
                                              child: SelectableText(
                                                  paginatedContractModel
                                                      .data[index].duration)),
                                        ),
                                        /*DataCell(SelectableText(
                                    paginatedContractModel.data[index].cover ??
                                        "No cover")),
                                DataCell(SelectableText(paginatedContractModel
                                    .data[index].autoRenovation
                                    .toString())),*/
                                        DataCell(
                                          Expanded(
                                              child: SelectableText(
                                                  paginatedContractModel
                                                          .data[index]
                                                          .lastRenovation ??
                                                      "No renovation yet")),
                                        ),
                                        DataCell(
                                          Expanded(
                                              child: SelectableText(
                                                  paginatedContractModel
                                                      .data[index].budget
                                                      .toString())),
                                        ),
                                        /*DataCell(SelectableText(paginatedContractModel
                                    .data[index].allowsSurplus
                                    .toString())),*/
                                        DataCell(
                                          Expanded(
                                              child: SelectableText(
                                                  paginatedContractModel
                                                      .data[index].isValidated
                                                      .toString())),
                                        ),
                                        DataCell(Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: TextButton(
                                                onPressed: () {
                                                  detailsClick(
                                                      paginatedContractModel
                                                          .data[index]);
                                                },
                                                child: const Text(
                                                  "Details",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                                  removeClick(
                                                      paginatedContractModel
                                                          .data[index]);
                                                },
                                                child: const Text(
                                                  "Remove",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                ),
                              ))),
                      Row(
                        children: [
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Spacer(),
                          ),
                          if (paginatedContractModel.meta.current_page != 1)
                            TextButton(
                              onPressed: () {
                                loadContracts(1);
                              },
                              child: const Text(
                                "<<",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          if (paginatedContractModel.meta.current_page != 1)
                            TextButton(
                                onPressed: () {
                                  loadContracts(
                                      paginatedContractModel.meta.current_page -
                                          1);
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
                                  paginatedContractModel.meta.current_page
                                      .toString(),
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ),
                          if (paginatedContractModel.meta.current_page !=
                              paginatedContractModel.meta.last_page)
                            TextButton(
                                onPressed: () {
                                  loadContracts(
                                      paginatedContractModel.meta.current_page +
                                          1);
                                },
                                child: const Text(
                                  ">",
                                  style: TextStyle(color: Colors.white),
                                )),
                          if (paginatedContractModel.meta.current_page !=
                              paginatedContractModel.meta.last_page)
                            TextButton(
                                onPressed: () {
                                  loadContracts(
                                      paginatedContractModel.meta.last_page);
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
              )
            : Center(
                child: ListView.builder(
                  itemCount: paginatedContractModel.data.length,
                  itemBuilder: (context, index) {
                    final contract = paginatedContractModel.data[index];
                    return Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        clipBehavior: Clip.hardEdge,
                        child: ListTile(
                          tileColor: bgColor,
                          title: Text(contract.entity?.name ?? "", style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                          )),
                          subtitle: Text(contract.title,
                              style: const TextStyle(color: Colors.grey)),
                          onTap: () {
                            detailsClick(contract);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
