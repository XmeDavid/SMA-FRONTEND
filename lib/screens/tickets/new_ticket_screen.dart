import 'dart:convert';

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
import '../side_menu.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({Key? key}) : super(key: key);

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState  extends State<NewTicketScreen> {

  final _formKey = GlobalKey<FormState>();

  final ticketTitleController = TextEditingController();
  final ticketDescriptionController = TextEditingController();

  String _selectedCategory = "";
  String _selectedContract = "";
  String _selectedClient = "";
  List<String>? _selectedAssets;

  List<Entity> entities = <Entity>[];
  List<Contract> contracts = <Contract>[];
  List<TicketCategory> categories = <TicketCategory>[];
  List<Asset> assets = <Asset>[];


  bool isClient(){
    return false;
  }

  Future<List<String>> loadContracts() async {
    if(contracts.isEmpty){
      contracts = await ModelApi.getContracts();
    }
    return contracts.map((e) => e.toString()).toList();
  }
  Future<List<String>> loadAssets() async{
    if(assets.isEmpty){
      assets = await ModelApi.getAssets();
    }
    return assets.map((e) => e.toString()).toList();
  }
  Future<List<String>> loadEntities() async{
    if(entities.isEmpty){
      entities = await ModelApi.getEntities();
    }
    return entities.map((e) => e.toString()).toList();
  }
  Future<List<String>> loadCategories() async{
    if(categories.isEmpty){
      categories = await ModelApi.getTicketCategories();
    }
    return categories.map((e) => e.toString()).toList();
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
                child:Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                    color: secondColor3,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if(!isClient())DropDown(this,
                              label: "Client Entity",
                              callback: (s) => {_selectedClient = s},
                              getData: loadEntities,
                            ),
                            TextField(
                              labelText: "Title",
                              hintText: "Ticket Title",
                              controller: ticketTitleController,
                              size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 98,
                            ),
                            TextBox(
                                labelText: "Description",
                                hintText: "Ticket Description",
                                controller: ticketDescriptionController,
                                size: 400),
                            DropDown(this,
                              label: "Category",
                              callback: (s) =>{_selectedCategory = s},
                              getData: loadCategories,
                            ),
                            DropDown(this,
                              label: "Contract",
                              callback: (s) =>{_selectedContract = s},
                              getData: loadContracts,
                            ),
                            Container(
                              padding: const EdgeInsets.all(defaultPadding/2),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: thirdColor5,
                                    ),
                                    child: DropdownSearch<String>.multiSelection(
                                      onFind: (String? filter) => loadAssets(),
                                      //items: assets.map((a) => a.toString()).toList(),
                                      mode: Responsive.isDesktop(context) ? Mode.MENU : Mode.BOTTOM_SHEET,
                                      showSelectedItems: true,
                                      popupBackgroundColor: thirdColor3,
                                      dropdownSearchDecoration: const InputDecoration(
                                        labelText: "Assets",
                                        contentPadding: EdgeInsets.all(10),
                                        border: InputBorder.none
                                      ),
                                      //popupItemDisabled: (String s) => s.startsWith('I'),
                                      showSearchBox: true,
                                      onChanged: (a){
                                        print(a);
                                        _selectedAssets = a;
                                      },
                                    ),
                                  ),
                                ]
                              ),
                            ),
                            //TODO Still need a way to input estimated time
                            ElevatedButton(
                                onPressed: (){
                                  ApiClient().createTicket(
                                      int.parse(_selectedClient.replaceAll(RegExp('[^0-9]'), '')),
                                    1,
                                      int.parse(_selectedContract.replaceAll(RegExp('[^0-9]'), '')),
                                      int.parse(_selectedCategory.replaceAll(RegExp('[^0-9]'), '')),
                                    "asd"
                                  );
                                  print("Client: "+ _selectedClient +"\nTitle: " + ticketTitleController.text + "\nDescription: " + ticketDescriptionController.text + "\nCategory: " + _selectedCategory + "\nContract: " + _selectedContract);
                                  print("Assets: " + _selectedAssets.toString());
                                },
                                child: const Text("Create Ticket"))
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TextField extends StatelessWidget {
  const TextField({Key? key, required this.labelText ,required this.hintText, required this.controller, required this.size}) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding/2),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                ),
                color: thirdColor5,
              ),
              height: 40,
              child: Center(
                child:Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    labelText,
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  )
                )
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                color: thirdColor3,
              ),
              height: 40,
              width: size,
              child: Center(
                child:TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10,bottom: 8),
                    hintText: hintText,
                    border: InputBorder.none
                  ),
                  style: const TextStyle(
                    fontSize: 20
                  ),
                  ),
                ),
              ),
          ],
      )
    );
  }
}

class TextBox extends StatelessWidget {
  const TextBox({Key? key, required this.labelText ,required this.hintText, required this.controller, required this.size}) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double size;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding/2),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
              ),
              color: thirdColor5,
            ),
            height: 40,
            child: Center(
                child:Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      labelText,
                      style: const TextStyle(
                          fontSize: 20
                      ),
                    )
                )
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              color: thirdColor3,
            ),
            height: 120,
            child: Center(
              child:TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 6,
                maxLines: 20,
                controller: controller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    hintText: hintText,
                    border: InputBorder.none
                ),
                style: const TextStyle(
                    fontSize: 16
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class DropDown extends StatelessWidget {
  const DropDown(_NewTicketScreenState _newTicketScreenState, {Key? key, required this.label, required this.callback, required this.getData}) : super(key: key);

  final String label;

  final Function(String s) callback;
  final Function() getData;

  bool whatDropdownMode(BuildContext context){
    return (MediaQuery.of(context).size.width > 800);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding/2),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              //borderRadius: whatDropdownMode(context)? const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)) : const BorderRadius.all(Radius.circular(10)),
              color: thirdColor5,
            ),
            height: 50,
            child: DropdownSearch<String>(
              onFind: (String? filter) => getData(),
              mode:whatDropdownMode(context) ? Mode.MENU : Mode.BOTTOM_SHEET,
              showSelectedItems: true,
              popupBackgroundColor: thirdColor3,
              dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: InputBorder.none,
                  labelText: label,
              ),
              //popupItemDisabled: (String s) => s.startsWith('I'),
              showSearchBox: true,
              onChanged: (s){
                callback(s ?? "");
              },
            ),
          ),
        ]
      ),
    );
  }
}
