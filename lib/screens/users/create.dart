import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/Country.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/TicketCategory.dart';
import 'package:sma_frontend/widgets/datePicker.dart';


import '../../api_interactions/api_functions.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
import '../../models/User.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState  extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameContrl = TextEditingController();
  final lastNameContrl = TextEditingController();
  final emailContrl = TextEditingController();
  final phoneNumberContrl = TextEditingController();
  final perHourContrl = TextEditingController();
  final birthDateContrl = TextEditingController();

  String _selectedEntity = "";

  DateTime? selectedDate;

  List<Entity> entities = <Entity>[];

  Future<List<String>> getEntities() async {
    if (entities.isEmpty) {
      entities = await Entity.getAll();
    }
    return entities.map((e) => (e.toString())).toList();
  }

  void createUser(){
    User.create(
      firstNameContrl.text,
      lastNameContrl.text,
      birthDateContrl.text,
      emailContrl.text,
      phoneNumberContrl.text,
      double.parse(perHourContrl.text),
      entities.where((element) => element.toString() == _selectedEntity).first.id,
      false,
    );
  }

  void showDatePanel()async{
    var tempDate = await getDateFromPicker(context: context, initialDate: selectedDate ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
    if(tempDate != null){
      setState(() {
        selectedDate = tempDate;
        birthDateContrl.text = "${selectedDate?.year.toString().padLeft(4,"0") ?? ""}-${selectedDate?.month.toString().padLeft(2,"0") ?? ""}-${selectedDate?.day.toString().padLeft(2,"0") ?? ""}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
          title: const Text("Register User"), backgroundColor: bgColor)
          : null,
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
                child: Column(children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width *
                          (Responsive.isDesktop(context) ? 0.666 : 0.9),
                      child: Row(
                        children: const [
                          Text(
                            "Register User",
                            style: TextStyle(fontSize: 42),
                          ),
                          Spacer()
                        ],
                      )),
                  Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                        color: secondColor3,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: MediaQuery.of(context).size.height * 0.95 - 118,
                    width: MediaQuery.of(context).size.width *
                        (Responsive.isDesktop(context) ? 0.666 : 0.9),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Flex(
                              direction: MediaQuery.of(context).size.width > 1000 ? Axis.horizontal : Axis.vertical,
                              children: [
                                TextLine(
                                  labelText: "First Name",
                                  hintText: "First Name",
                                  controller: firstNameContrl,
                                  size: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.333 - 164 : MediaQuery.of(context).size.width * 0.9 - 164,
                                  //size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 164,
                                ),
                                TextLine(
                                  labelText: "Last Name",
                                  hintText: "Last Name",
                                  controller: lastNameContrl,
                                  size: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.333 - 132 : MediaQuery.of(context).size.width * 0.9 - 164,
                                ),
                              ],
                            ),
                            DropDown(
                              label: "Entity Associated",
                              callback: (s) => {_selectedEntity = s},
                              getData: getEntities,
                            ),
                            Flex(
                              direction: MediaQuery.of(context).size.width > 1000 ? Axis.horizontal : Axis.vertical,
                              children: [
                                TextLine(
                                  labelText: "Email",
                                  hintText: "Email",
                                  controller: emailContrl,
                                  size: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.333 - 112 : MediaQuery.of(context).size.width * 0.9 - 112,
                                  //size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 164,
                                ),
                                TextLine(
                                  labelText: "Phone number",
                                  hintText: "Phone number",
                                  controller: phoneNumberContrl,
                                  size: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.333 - 174 : MediaQuery.of(context).size.width * 0.9 - 206,
                                ),
                              ],
                            ),

                            Flex(
                              direction: MediaQuery.of(context).size.width > 1000 ? Axis.horizontal : Axis.vertical,
                              children: [
                                TextLine(
                                  labelText: "Rate Per Hour",
                                  hintText: "Rate Per Hour",
                                  controller: perHourContrl,
                                  size: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.666 - 522 : MediaQuery.of(context).size.width * 0.9 - 192,
                                  //size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 164,
                                ),
                                Container(
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
                                          child: const Center(
                                              child:Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    "Birth Date",
                                                    style: TextStyle(fontSize: 20),
                                                  )
                                              )
                                          ),
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: thirdColor3,
                                          ),
                                          height: 40,
                                          width: 150,
                                          child: Center(
                                            child:TextFormField(
                                              enabled: true,
                                              controller: birthDateContrl,
                                              decoration: const InputDecoration(
                                                  contentPadding:  EdgeInsets.only(left: 10,bottom: 8),
                                                  hintText: "yyyy-mm-dd",
                                                  border: InputBorder.none
                                              ),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight: Radius.circular(10)
                                              ),
                                              color: thirdColor5,
                                            ),
                                            height: 40,
                                            child: TextButton(onPressed: showDatePanel, child: const Icon(Icons.calendar_month_outlined))
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  createUser();
                                },
                                child: const Text("Register User"))
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