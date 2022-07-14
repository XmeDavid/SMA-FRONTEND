import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/TicketCategory.dart';
import 'package:sma_frontend/models/paginated_model/Meta.dart';
import 'package:sma_frontend/models/paginated_model/PaginatedModel.dart';

import '../../api_interactions/api_functions.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class ListAssetsScreen extends StatefulWidget {
  const ListAssetsScreen({Key? key}) : super(key: key);

  @override
  State<ListAssetsScreen> createState() => _ListAssetsState();
}

class _ListAssetsState extends State<ListAssetsScreen> {

  PaginatedModel<Asset> paginatedModel = const PaginatedModel(
      data: [],
      meta: Meta(
          current_page: -1,
          from: -1,
          last_page: -1,
          path: "",
          per_page: 0,
          to: -1,
          total: -1));

  List<EntityType> entityTypes = <EntityType>[];

  var searchController = TextEditingController();

  void loadAssets(int page) async {
    var tempPaginatedModel = await Asset.getPaginated(20, page, searchController.text);
    setState(() {
      paginatedModel = tempPaginatedModel;
    });
  }

  detailsClick(Asset a) {
    Get.toNamed("/assets/" + a.id.toString());
  }

  @override
  void initState() {
    super.initState();
    loadAssets(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(title: const Text("Entities"), backgroundColor: bgColor)
          : null,
      drawer: const SideMenu(),
      body: paginatedModel.meta.current_page != -1 ? SafeArea(
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
                                child: SizedBox(
                                  width: (!Responsive.isDesktop(context)
                                      ? MediaQuery.of(context).size.width * 0.15
                                      : 160),
                                  child: TextField(
                                    controller: searchController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Search"),
                                    onEditingComplete: () {
                                      loadAssets(
                                          paginatedModel.meta.current_page);
                                    },
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: TextButton(
                                  onPressed: () {
                                    Get.toNamed("/assets/new");
                                  },
                                  child: const Text(
                                    "New Asset",
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
                              scrollDirection:
                                  Axis.vertical, //child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Scrollbar(
                                isAlwaysShown: true,
                                child: DataTable(
                                  columnSpacing: 38,
                                  columns: [
                                    "Serial\nNumber",
                                    "Brand",
                                    "Model",
                                    "Purchase\nDate",
                                    "Purchase\nPrice",
                                    "Warranty\nMonths",
                                    "Actions"
                                  ]
                                      .map((e) => DataColumn(label: Text(e)))
                                      .toList(),
                                  rows: List.generate(
                                      paginatedModel.data.length, (index) {
                                    return DataRow(cells: [
                                      DataCell(Container(child: SelectableText(paginatedModel.data[index].serialNumber))),
                                      DataCell(Container(child: SelectableText(paginatedModel.data[index].brand))),
                                      DataCell(Container(child: SelectableText(paginatedModel.data[index].model))),
                                      DataCell(Container(child: SelectableText(paginatedModel.data[index].purchaseDate))),
                                      DataCell(Container(child: SelectableText(paginatedModel.data[index].purchasePrice.toString()))),
                                      DataCell(Container(child: SelectableText(paginatedModel.data[index].warrantyMonths.toString()))),
                                      DataCell(Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextButton(
                                              onPressed: () {
                                                detailsClick(
                                                    paginatedModel.data[index]);
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
                          if (paginatedModel.meta.current_page != 1)
                            TextButton(
                              onPressed: () {
                                loadAssets(1);
                              },
                              child: const Text(
                                "<<",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          if (paginatedModel.meta.current_page != 1)
                            TextButton(
                                onPressed: () {
                                  loadAssets(paginatedModel.meta.current_page - 1);
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
                                  paginatedModel.meta.current_page.toString(),
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ),
                          if (paginatedModel.meta.current_page !=
                              paginatedModel.meta.last_page)
                            TextButton(
                                onPressed: () {
                                  loadAssets(paginatedModel.meta.current_page + 1);
                                },
                                child: const Text(
                                  ">",
                                  style: TextStyle(color: Colors.white),
                                )),
                          if (paginatedModel.meta.current_page !=
                              paginatedModel.meta.last_page)
                            TextButton(
                                onPressed: () {
                                  loadAssets(paginatedModel.meta.last_page);
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
                  itemCount: paginatedModel.data.length,
                  itemBuilder: (context, index) {
                    final asset = paginatedModel.data[index];
                    return Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        clipBehavior: Clip.hardEdge,
                        child: ListTile(
                          tileColor: bgColor,
                          title: Text(asset.model),
                          subtitle: Text(
                            asset.brand,
                            style: TextStyle(color: Colors.grey),
                          ),
                          onTap: () {
                            detailsClick(asset);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
      ): const Center(child: CircularProgressIndicator()),
    );
  }
}
