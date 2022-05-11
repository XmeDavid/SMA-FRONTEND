
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/TicketCategory.dart';


import '../../api_interactions/api_functions.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
import '../../models/model_api.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class ListEntities extends StatefulWidget {
  const ListEntities({Key? key}) : super(key: key);



  @override
  State<ListEntities> createState() => _ListEntitiesState();
}

class _ListEntitiesState  extends State<ListEntities> {

  List<Entity> entities = <Entity>[];
  List<EntityType> entityTypes = <EntityType>[];

  List<Entity> filteredEntities = <Entity>[];

  int _selectedFilterEntityTypeId = -1;

  var searchController = TextEditingController();

  bool isClient(){
    return false;
  }


  void loadEntities() async{
    if(entities.isEmpty){
     var tempEntities = await ModelApi.getEntities(true);
      setState(() {
        entities = tempEntities;
        filteredEntities = entities;
      });
    }
  }
  void loadEntityTypes() async{

    if(entityTypes.isEmpty){
      var tempEntityTypes = await ModelApi.getEntityTypes();

      setState(() {
        entityTypes = tempEntityTypes;
        entityTypes.add(const EntityType(id: -1, name: "Any", description: "Any"));
      });
    }
  }

  removeClick(Entity e){
    print(e);
  }

  detailsClick(Entity e){
    print(e.id);
    Get.toNamed("/entities/" + e.id.toString());
  }

  @override
  void initState(){
    super.initState();
    loadEntityTypes();
    loadEntities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? AppBar(title: const Text ("Dashboard"), backgroundColor: bgColor) : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
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
                  child:Column(
                      children:[
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: thirdColor5,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            height: 60,
                            width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.8 : 0.95),
                            child: Row(
                              children: [
                                const Padding(padding: EdgeInsets.all(defaultPadding), child: Text("Filters",style: TextStyle(fontSize: 20),),),
                                const Padding(padding: EdgeInsets.all(defaultPadding), child: Text("Entity Type:",style: TextStyle(fontSize: 16),),),
                                Padding(padding: const EdgeInsets.all(defaultPadding),
                                  child: DropdownButton(
                                    items: entityTypes.map((e) => DropdownMenuItem(value: e.id,child: Text(e.name))).toList(),
                                    onChanged: (dynamic newValue){
                                      setState(() {
                                        _selectedFilterEntityTypeId = newValue;
                                        filteredEntities = entities.where((element) => ((element.name.contains(searchController.text) || element.email.contains(searchController.text) || element.taxNumber.contains(searchController.text)) && ((element.entityTypeId == _selectedFilterEntityTypeId)||(_selectedFilterEntityTypeId == -1)))).toList();
                                      });
                                    },
                                    value: _selectedFilterEntityTypeId,
                                    underline: DropdownButtonHideUnderline(child: Container(),),
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.all(defaultPadding),
                                  child: SizedBox(
                                    width: (!Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.15 : 160),
                                    child: TextField(
                                      controller: searchController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Search"
                                      ),
                                      onChanged: (e){
                                        setState(() {
                                          filteredEntities = entities.where((element) => ((element.name.contains(e) || element.email.contains(e) || element.taxNumber.contains(e)) && ((element.entityTypeId == _selectedFilterEntityTypeId)||(_selectedFilterEntityTypeId == -1)))).toList();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(padding: const EdgeInsets.all(defaultPadding),
                                  child: TextButton(
                                    onPressed: (){Navigator.pushNamed(context, '/entities/new');},
                                    child: const Text("New Entity", style: TextStyle(color: Colors.white),),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(firstColor),
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
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          height: MediaQuery.of(context).size.height - 164,
                          width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.8 : 0.95),
                          child: SingleChildScrollView(scrollDirection: Axis.vertical,//child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Scrollbar(isAlwaysShown: true,child: DataTable(
                              columnSpacing:  38,
                              columns: ["Id","Name","Type", "Email", "Phone\nNumber", "Tax\nNumber","Actions"].map((e) => DataColumn(label: Text(e))).toList(),
                              rows: List.generate(filteredEntities.length, (index) {
                                return DataRow(cells: [
                                  DataCell(Container(child: SelectableText(filteredEntities[index].id.toString()))),
                                  DataCell(Container(child: SelectableText(filteredEntities[index].name))),
                                  DataCell(Container(child: SelectableText(filteredEntities[index].entityTypeName ?? ""))),
                                  DataCell(Container(child: SelectableText(filteredEntities[index].email))),
                                  DataCell(Container(child: SelectableText(filteredEntities[index].phoneNumber?? ""))),
                                  DataCell(Container(child: SelectableText(filteredEntities[index].taxNumber))),
                                  DataCell(Row(
                                    children: [
                                      Padding(padding: const EdgeInsets.all(5),
                                        child: TextButton(
                                          onPressed: (){
                                            detailsClick(filteredEntities[index]);

                                          },
                                          child: const Text("Details", style: TextStyle(color: Colors.white),),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(firstColor),
                                          ),
                                        ),
                                      ),
                                      Padding(padding: const EdgeInsets.all(5),
                                        child: TextButton(
                                          onPressed: (){
                                            removeClick(filteredEntities[index]);
                                          },
                                          child: const Text("Remove",style: TextStyle(color: Colors.white),),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                                ]);
                              }),
                            ),)
                          ))
                        //)
                      ]
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}