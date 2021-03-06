import 'dart:math';

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

class ListEntities extends StatefulWidget {
  const ListEntities({Key? key}) : super(key: key);

  @override
  State<ListEntities> createState() => _ListEntitiesState();
}

class _ListEntitiesState extends State<ListEntities> {
  PaginatedModel<Entity> paginatedModel = const PaginatedModel(
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
  int _selectedFilterEntityTypeId = -1;

  var searchController = TextEditingController();


  void loadEntityTypes() async {
    if (entityTypes.isEmpty) {
      var tempEntityTypes = await EntityType.getAll();

      setState(() {
        entityTypes = tempEntityTypes;
        entityTypes
            .add(const EntityType(id: -1, name: "Any", description: "Any"));
      });
    }
  }

  void loadEntities(int page) async {
    var tempPaginatedModel = await Entity.getPaginated(true, 20, page, _selectedFilterEntityTypeId, searchController.text);
    setState(() {
      paginatedModel = tempPaginatedModel;
    });
  }


  Color isEntityTypeColor(Entity entity) {
    var rand = Random(entity.entityTypeId);
    return Color.fromRGBO(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255), 1);
  }

  remove(int id) {
    Entity.remove(id);
    setState(() {
      paginatedModel.data.removeAt(
          paginatedModel.data.indexWhere((element) => element.id == id));
    });
  }

  detailsClick(Entity e) {
    Get.toNamed("/entities/" + e.id.toString());
  }

  @override
  void initState() {
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadEntityTypes();
    loadEntities(1);
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
                                child: DropdownButton(
                                  items: entityTypes
                                      .map((e) => DropdownMenuItem(
                                          value: e.id, child: Text(e.name)))
                                      .toList(),
                                  onChanged: (dynamic newValue) {
                                    setState(() {
                                      _selectedFilterEntityTypeId = newValue;
                                    });
                                    loadEntities(
                                        paginatedModel.meta.current_page);
                                  },
                                  value: _selectedFilterEntityTypeId,
                                  underline: DropdownButtonHideUnderline(
                                    child: Container(),
                                  ),
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
                                      loadEntities(
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
                                    Get.toNamed("/entities/create");
                                  },
                                  child: const Text(
                                    "New Entity",
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
                                    "Id",
                                    "Name",
                                    "Type",
                                    "Email",
                                    "Phone\nNumber",
                                    "Tax\nNumber",
                                    "Actions"
                                  ]
                                      .map((e) => DataColumn(label: Expanded(child: Text(e, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))))
                                      .toList(),
                                  rows: List.generate(
                                      paginatedModel.data.length, (index) {
                                    return DataRow(cells: [
                                      DataCell(Container(
                                          child: SelectableText(paginatedModel
                                              .data[index].id
                                              .toString()))),
                                      DataCell(Container(
                                          child: SelectableText(paginatedModel
                                              .data[index].name))),
                                      DataCell(Container(
                                          child: SelectableText(paginatedModel
                                                  .data[index]
                                                  .entityType
                                                  ?.name ??
                                              ""))),
                                      DataCell(Container(
                                          child: SelectableText(paginatedModel
                                              .data[index].email))),
                                      DataCell(Container(
                                          child: SelectableText(paginatedModel
                                                  .data[index].phoneNumber ??
                                              "N/A"))),
                                      DataCell(Container(
                                          child: SelectableText(paginatedModel
                                              .data[index].taxNumber))),
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
                      PaginatedNavigation(paginatedModel: paginatedModel, callback: loadEntities)
                      //)
                    ])),
                  ),
                ],
              )
            : Center(
                child: ListView.builder(
                  itemCount: paginatedModel.data.length,
                  itemBuilder: (context, index) {
                    final entity = paginatedModel.data[index];
                    return Padding(
                      padding: EdgeInsets.all(smallPadding),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        clipBehavior: Clip.hardEdge,
                        child: ListTile(
                          trailing: const Icon(Icons.arrow_forward),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          tileColor: cardColor,
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.domain),
                              VerticalDivider()
                            ],
                          ),
                          textColor: Colors.grey,
                          title: Text(entity.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          subtitle: Text(
                            entity.entityType?.name ?? "",
                            style: TextStyle(color: isEntityTypeColor(entity)),
                          ),
                          onTap: () {
                            detailsClick(entity);
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
