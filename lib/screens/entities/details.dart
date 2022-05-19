import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Address.dart';
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

class EntityDetailsScreen extends StatefulWidget {
  const EntityDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EntityDetailsScreen> createState() => _EntityDetailsScreen();


}

class _EntityDetailsScreen  extends State<EntityDetailsScreen> {



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
  final entityTypeController = TextEditingController();
 final zipCodeController = TextEditingController();


  bool isEditMode = false;

  String _selectedDefaultLanguage = "";
  String _selectedEntityType = "";
  List<String>? _selectedAssets;
  late Entity entity;

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


  void loadEntity() async{
    var _entity = await Entity.get(int.parse(Get.parameters['id'] ?? ''),true);
    setState(() {
      entity = _entity;
      nameController.text = entity.name;
      entityTypeController.text = entity.entityType?.name ?? 'unknow';
      emailController.text = entity.email;
      phoneNumberController.text = entity.phoneNumber ?? 'No phone number';
      taxNumberController.text = entity.taxNumber;
      streetController.text = entity.address?.street ?? "";
      doorController.text = entity.address?.door ?? "";
      floorController.text = entity.address?.floor ?? "";
      roomController.text = entity.address?.room ?? "";
      localController.text = entity.address?.local ?? "";
      districtController.text = entity.address?.district ?? "";
      countryController.text = entity.address?.country.toString() ?? "";
      zipCodeController.text = entity.address?.zipCode ?? "";
    });
  }

  void saveChanges() async{
    if(countrys.isEmpty) countrys = await Country.getAll();
    int countryId = countrys.where((element) => element.toString() == countryController.text).first.id;
    Address.update(entity.addressId,streetController.text, doorController.text, floorController.text, roomController.text, zipCodeController.text, localController.text, districtController.text, countryId);
  }

  @override
  void initState(){
    super.initState();
    loadEntity();
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
                          children:  [
                            Text(entity.name,
                              style: const TextStyle(
                                  fontSize: 48
                              ),
                            ),
                            const Spacer()
                          ],
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: const BoxDecoration(
                          color: secondColor3,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      height: Responsive.isDesktop(context) ? MediaQuery.of(context).size.height * 0.8 : MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Name",
                                hintText: "Entity name",
                                controller: nameController,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 119,
                              ),
                              DropDown(
                                label: "Entity Type",
                                callback: (s) => {entityTypeController.text},
                                getData: getEntityTypesString,
                                selected: entityTypeController.text,
                                enabled: entity.entityTypeId == 1 ? false : isEditMode,
                              ),
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Entity Type",
                                hintText: "Client or Suppiler",
                                controller: entityTypeController,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) -165,
                              ),
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Email",
                                hintText: "Entity email",
                                controller: emailController,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 112,
                              ),
                              Responsive.isDesktop(context) ? Row(
                                children: [
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Phone Number",
                                    hintText: "Entity phone number",
                                    controller: phoneNumberController,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 207,
                                  ),
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Tax Number",
                                    hintText: "Entity tax payer number",
                                    controller: taxNumberController,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 146,
                                  ),
                                ],
                              ) : Column(
                                children: [
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Phone No.",
                                    hintText: "Entity phone number",
                                    controller: phoneNumberController,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 156,
                                  ),
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Tax No.",
                                    hintText: "Entity tax payer number",
                                    controller: taxNumberController,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) -128,
                                  ),
                                ],
                              ),
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Language",
                                hintText: "Entity Language",
                                controller: taxNumberController,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 159,
                              ),
                              AddressField(
                                enabled: isEditMode,
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
                              Row(children: [
                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                    child: OutlinedButton (
                                      onPressed: (){
                                        Get.toNamed('/entities');
                                      },
                                      child: const Text("Go Back",style: TextStyle(color: Colors.white),),
                                    ),
                                ),
                                const Spacer(),
                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        isEditMode = !isEditMode;
                                      });
                                    },
                                    child: ((){
                                      if(isEditMode){
                                        return const Text("Cancel");
                                      }
                                      return const Text("Edit");
                                    })(),
                                    style: isEditMode ? ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(thirdColor5),) : ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(firstColor),),
                                  ),
                                ),

                                if(isEditMode)Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        isEditMode = false;
                                      });
                                      saveChanges();
                                    },
                                    child: const Text("Save"),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green),),
                                  ),
                                ),
                              ],)
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