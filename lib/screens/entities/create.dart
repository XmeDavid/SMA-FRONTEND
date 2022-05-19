import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/Country.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/TicketCategory.dart';


import '../../api_interactions/api_functions.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class NewEntityScreen extends StatefulWidget {
  const NewEntityScreen({Key? key}) : super(key: key);

  @override
  State<NewEntityScreen> createState() => _NewEntityScreenState();
}

class _NewEntityScreenState  extends State<NewEntityScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final taxNumberController = TextEditingController();
  final streetController = TextEditingController();
  final doorController = TextEditingController();
  final floorController = TextEditingController();
  final roomController = TextEditingController();
  final countryController = TextEditingController();
  final districtController = TextEditingController();
  final localController = TextEditingController();
  final zipCodeController = TextEditingController();


  String _selectedDefaultLanguage = "";
  String _selectedEntityType = "";
  List<String>? _selectedAssets;

  List<EntityType> entityTypes = <EntityType>[];
  List<Country> countrys = <Country>[];
  List<TicketCategory> categories = <TicketCategory>[];
  List<Asset> assets = <Asset>[];

  bool isClient(){
    return false;
  }

  Future<List<String>> getEntityTypesString() async {
    if(entityTypes.isEmpty){
      entityTypes = await EntityType.getAll();
    }
    return entityTypes.where((element) => element.id != 1).map((e) => e.name).toList();
  }
  Future<List<String>> getCountrysString() async{
    if(countrys.isEmpty){
      countrys = await Country.getAll();
    }
    return countrys.map((e) => e.toString()).toList();
  }

  createEntity(){
    Entity.create(
        entityTypes.where((element) => element.name == _selectedEntityType).first.id,
        nameController.text,
        emailController.text,
        phoneNumberController.text,
        taxNumberController.text,
        countrys.where((element) => element.toString() == _selectedDefaultLanguage).first.iso,
        streetController.text,
        doorController.text,
        int.parse(floorController.text),
        roomController.text,
        localController.text,
        districtController.text,
        zipCodeController.text,
        countrys.where((element) => element.toString() == countryController.text).first.id
    );
    Get.toNamed("/entities");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? AppBar(title: const Text ("Create Entity"), backgroundColor: bgColor) : null,
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
              child: Center(child:Column(
                children:[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                    child: Row(
                      children: const [
                        Text("Create Entity",
                            style: TextStyle(
                              fontSize: 48
                            ),
                        ),
                        Spacer()
                      ],
                    )
                  ),
                  Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                      color: secondColor3,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextLine(
                            labelText: "Name",
                            hintText: "Entity name",
                            controller: nameController,
                            size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 119,
                          ),
                          DropDown(
                            label: "Entity Type",
                            callback: (s) =>{_selectedEntityType = s},
                            getData: getEntityTypesString,
                          ),
                          TextLine(
                            labelText: "Email",
                            hintText: "Entity email",
                            controller: emailController,
                            size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 112,
                          ),
                          TextLine(
                            labelText: "Phone Number",
                            hintText: "Entity phone number",
                            controller: phoneNumberController,
                            size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 207,
                          ),
                          TextLine(
                            labelText: "Tax Number",
                            hintText: "Entity tax payer number",
                            controller: taxNumberController,
                            size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 178,
                          ),
                          DropDown(
                            label: "Default Language",
                            callback: (s) =>{_selectedDefaultLanguage = s},
                            getData: getCountrysString,
                          ),
                          AddressField(
                            height: 280,
                            width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                            streetController: streetController,
                            doorController: doorController,
                            floorController: floorController,
                            roomController: roomController,
                            countryController: countryController,
                            districtController: districtController,
                            localController: localController,
                            zipCodeController: zipCodeController,
                            getCountrys: getCountrysString,
                          ),
                          ElevatedButton(
                              onPressed: (){
                                createEntity();
                              },
                              child: const Text("Create Ticket"))
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            ),
          ],
        ),
      ),
    );
  }
}