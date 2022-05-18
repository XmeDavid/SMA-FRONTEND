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
import '../../models/model_api.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class ContractsDetailsScreen extends StatefulWidget {
  const ContractsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ContractsDetailsScreen> createState() => _ContractsDetailsScreen();


}

class _ContractsDetailsScreen  extends State<ContractsDetailsScreen> {



  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final entityTypeController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final durationController = TextEditingController();
  final coverController = TextEditingController();
  final budgetController = TextEditingController();
  final autoRenovationController = TextEditingController();
  final allowsSurplusController = TextEditingController();
  final isValidatedController = TextEditingController();
  final lastRenovationController = TextEditingController();


  bool isEditMode = false;

  late Contract contract;
  late EntityType entityType;



  void getEntityType() async {
    List<EntityType> entityTypes = await ModelApi.getEntityTypes();
    entityTypes.where((element) => element.id != 1).map((e) => e.name).toList();
    setState(() {
      entityType = entityTypes.where((element) => element.id == contract.entitiesId).first;
    });
  }



  void loadContract() async{
    //var contracts = await ModelApi.getContracts();
    var _contract = await ModelApi.getContract(int.parse(Get.parameters['id'] ?? ''));
    setState(() {
      contract = _contract;
      titleController.text = contract.title;
      descriptionController.text = contract.description;
      //vai ser entityType
      startDateController.text = contract.startDate;
      endDateController.text = contract.endDate;
      durationController.text = contract.duration;
      coverController.text = contract.cover ?? '';
      budgetController.text = contract.budget.toString();
      lastRenovationController.text = contract.lastRenovation ?? '';
    });
    getEntityType();
  }

  void saveChanges(){
    print("saving");
  }

  @override
  void initState(){
    super.initState();
    loadContract();

  }

  @override
  Widget build(BuildContext context) {

    String radioValue;
    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? AppBar(title: const Text ("Contract Details"), backgroundColor: bgColor) : null,
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
                            Text(contract.id.toString(),
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
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Title",
                                hintText: "Contract Title",
                                controller: titleController,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 119,
                              ),
                              DropDown(
                                label: "Entity Type",
                                callback: (s) => {entityTypeController.text},
                                getData: getEntityType,
                                selected: entityTypeController.text,
                                enabled: contract.entitiesId == 1 ? false : isEditMode,
                              ),
                              TextArea(
                                labelText: "Description",
                                hintText: "Description of the contract",
                                controller: descriptionController,
                                size: 400,
                                isEnabled: false,
                              ),
                              Row(
                                children: [
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Start Date",
                                    hintText: "Start Date",
                                    controller: startDateController,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 127,
                                  ),
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "End Date",
                                    hintText: "End Date",
                                    controller: endDateController,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 -148,
                                  ),
                                ],
                              ),
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Cover",
                                hintText: "This contract covers",
                                controller: coverController,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 118,
                              ),
                              Row(
                                children: [
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Duration",
                                    hintText: "Duration in months",
                                    controller: durationController,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 -145,
                                  ),
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Budget",
                                    hintText: "budget available",
                                    controller: budgetController,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 -98,
                                  ),
                                ],
                              ),
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Last Renovation",
                                hintText: "Last Renovation",
                                controller: lastRenovationController,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) -216,
                              ),

                              Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all<Color>(firstColor),
                                    value: contract.autoRenovation,
                                    onChanged: null
                                  ),
                                  const Text("Auto Renovation" ,style: TextStyle(color: Colors.white),),
                                  Checkbox(
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateProperty.all<Color>(firstColor),
                                      value: contract.isValidated,
                                      onChanged: null
                                  ),
                                  const Text("Validated" ,style: TextStyle(color: Colors.white),),
                                ],
                              ),

                              Row(children: [
                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                  child: OutlinedButton (
                                    onPressed: (){
                                      Get.toNamed('/contracts');
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