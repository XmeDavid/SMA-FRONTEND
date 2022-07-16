import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
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
  final dateFormatted = DateFormat('dd-MM-yyyy');
  final dateFormattedDetailed = DateFormat('dd-MM-yyyy hh:mm');
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

  void loadContracts(int page) async {
    var tempContractPaginatedModel =
        await Contract.getPaginated(true, 20, page, searchController.text);
    setState(() {
      paginatedContractModel = tempContractPaginatedModel;
    });
  }

  detailsClick(Contract e) {
    Get.toNamed("/contracts/" + e.id.toString());
  }

  @override
  void initState() {
    GetStorage().read('token') ?? Get.toNamed('/login');
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
          child: paginatedContractModel.meta.current_page != -1
              ? Responsive.isDesktop(context)
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
                                    (Responsive.isDesktop(context)
                                        ? 0.8
                                        : 0.95),
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
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      child: SizedBox(
                                        width: (!Responsive.isDesktop(context)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15
                                            : 160),
                                        child: TextField(
                                          controller: searchController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: "Search"),
                                          onChanged: (e) {
                                            loadContracts(paginatedContractModel
                                                .meta.current_page);
                                          },
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
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
                                height:
                                    MediaQuery.of(context).size.height - 164,
                                width: MediaQuery.of(context).size.width *
                                    (Responsive.isDesktop(context)
                                        ? 0.8
                                        : 0.95),
                                child: SingleChildScrollView(
                                    scrollDirection: Axis
                                        .horizontal, //child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: SingleChildScrollView(
                                      child: DataTable(
                                        columnSpacing: 20,
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
                                          "Actions"
                                        ].map((e) {
                                          return DataColumn(label: Expanded(child: Text(e, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))));
                                        }).toList(),
                                        rows: List.generate(
                                            paginatedContractModel.data.length,
                                            (index) {
                                          return DataRow(cells: [
                                            DataCell(
                                              SelectableText(
                                                  paginatedContractModel
                                                      .data[index].id
                                                      .toString()),
                                            ),
                                            DataCell(
                                              SelectableText(
                                                  paginatedContractModel
                                                      .data[index].title),
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
                                              SelectableText(dateFormatted
                                                  .format(DateTime.parse(
                                                      paginatedContractModel
                                                          .data[index]
                                                          .startDate))),
                                            ),
                                            DataCell(
                                              SelectableText(
                                                dateFormatted.format(
                                                    DateTime.parse(
                                                        paginatedContractModel
                                                            .data[index]
                                                            .endDate)),
                                              ),
                                            ),
                                            DataCell(
                                              SelectableText(
                                                  '${paginatedContractModel.data[index].duration} months'),
                                            ),
                                            /*DataCell(SelectableText(
                                    paginatedContractModel.data[index].cover ??
                                        "No cover")),
                                DataCell(SelectableText(paginatedContractModel
                                    .data[index].autoRenovation
                                    .toString())),*/
                                            DataCell(
                                              SelectableText(
                                                paginatedContractModel
                                                            .data[index]
                                                            .lastRenovation ==
                                                        null
                                                    ? "No renovation yet"
                                                    : dateFormattedDetailed
                                                        .format(DateTime.parse(
                                                            paginatedContractModel
                                                                .data[index]
                                                                .lastRenovation!)),
                                              ),
                                            ),
                                            DataCell(
                                              SelectableText(
                                                  paginatedContractModel
                                                      .data[index].budget
                                                      .toString()),
                                            ),
                                            /*DataCell(SelectableText(paginatedContractModel
                                    .data[index].allowsSurplus
                                    .toString())),*/
                                            DataCell(Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
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
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  firstColor),
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
                                if (paginatedContractModel.meta.current_page !=
                                    1)
                                  TextButton(
                                    onPressed: () {
                                      loadContracts(1);
                                    },
                                    child: const Text(
                                      "<<",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                if (paginatedContractModel.meta.current_page !=
                                    1)
                                  TextButton(
                                      onPressed: () {
                                        loadContracts(paginatedContractModel
                                                .meta.current_page -
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
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                ),
                                if (paginatedContractModel.meta.current_page !=
                                    paginatedContractModel.meta.last_page)
                                  TextButton(
                                      onPressed: () {
                                        loadContracts(paginatedContractModel
                                                .meta.current_page +
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
                                        loadContracts(paginatedContractModel
                                            .meta.last_page);
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
                                      Icon(Icons.history_edu),
                                      VerticalDivider(),
                                    ],),
                                  textColor: Colors.grey,
                                  title: Text(contract.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  subtitle: Text(
                                    'Entity: ${contract.entity?.name ?? 'No entity associated'}',
                                  ),
                                  onTap: () {
                                    detailsClick(contract);
                                  },
                                ),
                              ),
                            ]),
                          );
                        },
                      ),
                    )
              : const Center(child: CircularProgressIndicator())),
    );
  }
}
