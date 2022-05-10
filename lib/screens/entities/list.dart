import 'dart:html';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
      entities = await ModelApi.getEntities();
      filteredEntities = entities;
    }
  }
  void loadEntityTypes() async{
    if(entityTypes.isEmpty){
      entityTypes = await ModelApi.getEntityTypes();
      entityTypes.add(const EntityType(id: -1, name: "Any", description: "Any"));
    }
  }

  EntityType getEntityTypeFromId(int id){
    return entityTypes.where((element) => element.id == id).first;
  }

  removeClick(Entity e){
    print(e);
  }

  detailsClick(Entity e){
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    loadEntityTypes();
    loadEntities();
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
                            width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
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
                                        filteredEntities = entities.where((element) => (element.entityTypeId == _selectedFilterEntityTypeId)||(_selectedFilterEntityTypeId == -1)).toList();
                                      });
                                    },
                                    value: _selectedFilterEntityTypeId,
                                    underline: DropdownButtonHideUnderline(child: Container(),),
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.all(defaultPadding),
                                  child: SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: searchController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Search"
                                      ),
                                      onChanged: (e){
                                        setState(() {
                                          filteredEntities = entities.where((element) => (element.name.contains(e) || (element.email.contains(e)) || (element.taxNumber.contains(e)))).toList();
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
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                          child: SingleChildScrollView(scrollDirection: Axis.vertical,child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing:  38,
                              columns: ["Id","Name","Type", "Email", "Phone\nNumber", "Tax\nNumber","Actions"].map((e) => DataColumn(label: Text(e))).toList(),
                              rows: List.generate(filteredEntities.length, (index) {
                                return DataRow(cells: [
                                  DataCell(Container(child: SelectableText(filteredEntities[index].id.toString()))),
                                  DataCell(Container(child: SelectableText(filteredEntities[index].name))),
                                  DataCell(Container(child: SelectableText(getEntityTypeFromId(filteredEntities[index].entityTypeId).name))),
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
                            ),
                          ))
                        )
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