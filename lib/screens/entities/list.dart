import 'dart:html';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sma_frontend/models/Contract.dart';
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


  bool isClient(){
    return false;
  }


  Future<List<String>> loadEntities() async{
    if(entities.isEmpty){
      entities = await ModelApi.getEntities();
    }
    return entities.map((e) => e.toString()).toList();
  }

  removeClick(Entity e){
    print(e);
  }

  detailsClick(Entity e){
    print(e);
  }

  @override
  Widget build(BuildContext context) {
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
                              columns: ["Id","Name", "Email", "Phone\nNumber", "Tax\nNumber","Actions"].map((e) => DataColumn(label: Text(e))).toList(),
                              rows: List.generate(entities.length, (index) {
                                return DataRow(cells: [
                                  DataCell(Container(child: Text(entities[index].id.toString()))),
                                  DataCell(Container(child: Text(entities[index].name))),
                                  DataCell(Container(child: Text(entities[index].email))),
                                  DataCell(Container(child: Text(entities[index].phoneNumber?? ""))),
                                  DataCell(Container(child: Text(entities[index].taxNumber))),
                                  DataCell(Row(
                                    children: [
                                      Padding(padding: const EdgeInsets.all(5),
                                        child: TextButton(
                                          onPressed: (){
                                            detailsClick(entities[index]);
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
                                            removeClick(entities[index]);
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