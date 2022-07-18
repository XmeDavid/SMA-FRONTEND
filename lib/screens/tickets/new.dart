import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/TicketCategory.dart';


import '../../api_interactions/api_functions.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
import '../../models/Ticket.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
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



  Future<List<String>> loadContracts() async {
    if(contracts.isEmpty){
      contracts = await Entity.getContracts(GetStorage().read('user_entity_id'));
    }
    return contracts.map((e) => e.toString()).toList();
  }
  Future<List<String>> loadAssets() async{
    if(assets.isEmpty){
      assets = await Asset.getAll();
    }
    return assets.map((e) => e.toString()).toList();
  }
  Future<List<String>> loadCategories() async{
    if(categories.isEmpty){
      categories = await TicketCategory.getAll();
    }
    return categories.map((e) => e.toString()).toList();
  }


  void createTicket() async{
    var _category = categories.where((element) => element.toString() ==  _selectedCategory).first;
    var _contract = contracts.where((element) => element.toString() == _selectedContract).first;
    var _assets = assets.where((element){
      return _selectedAssets != null ? _selectedAssets!.contains(element.toString()) : false;
    }).toList();
    try{
      var res = await Ticket.create(ticketTitleController.text, ticketDescriptionController.text,_category,_contract,_assets);
      if(res == null){
        Get.snackbar('Error', 'Something went wrong!',backgroundColor: Colors.redAccent.withOpacity(0.5));
      }else{
        Get.snackbar('Ticket Created!', 'Ticket #${res.id} - ${res.title} Created',backgroundColor: Colors.green.withOpacity(0.5));
        Get.toNamed('/tickets/${res.id}');
      }
    } on Exception catch(_){
      Get.snackbar('Error', '$_',backgroundColor: Colors.redAccent.withOpacity(0.5));
    }
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
                            TextLine(
                              labelText: "Title",
                              hintText: "Ticket Title",
                              controller: ticketTitleController,
                              size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 98,
                            ),
                            TextArea(
                                labelText: "Description",
                                hintText: "Ticket Description",
                                controller: ticketDescriptionController,
                                height: 160),
                            DropDown(
                              label: "Category",
                              callback: (s) =>{_selectedCategory = s},
                              getData: loadCategories,
                            ),
                            DropDown(
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
                                        _selectedAssets = a;
                                      },
                                    ),
                                  ),
                                ]
                              ),
                            ),
                            //TODO Still need a way to input estimated time
                            //TODO Maybe add option to attach files
                            ElevatedButton(
                                onPressed: (){
                                  createTicket();
                                  Get.toNamed('/tickets');
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


