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

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState  extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final durationController = TextEditingController();
  final totalHoursController = TextEditingController();
  final kmController = TextEditingController();
  final budgetController = TextEditingController();
  final autoRenovationController = TextEditingController();
  final allowsSurplusController = TextEditingController();
  final isValidatedController = TextEditingController();
  final lastRenovationController = TextEditingController();

  String _selectedEntity = "";

  List<Entity> entities = <Entity>[];

  Future<List<String>> getEntities() async {
    if (entities.isEmpty) {
      entities = await Entity.getAll();
    }
    return entities.map((e) => (e.id.toString() + " - " + e.name)).toList();
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
                                  controller: titleController,
                                  size: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.333 - 164 : MediaQuery.of(context).size.width * 0.9 - 164,
                                  //size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 164,
                                ),
                                TextLine(
                                  labelText: "Last Name",
                                  hintText: "Last Name",
                                  controller: titleController,
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
                                  controller: titleController,
                                  size: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.333 - 112 : MediaQuery.of(context).size.width * 0.9 - 112,
                                  //size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 164,
                                ),
                                TextLine(
                                  labelText: "Phone number",
                                  hintText: "Phone number",
                                  controller: titleController,
                                  size: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.333 - 174 : MediaQuery.of(context).size.width * 0.9 - 206,
                                ),
                              ],
                            ),


                            TextLine(
                              labelText: "Budget",
                              hintText: "Set tbe budget",
                              controller: budgetController,
                              size: MediaQuery.of(context).size.width *
                                  (Responsive.isDesktop(context)
                                      ? 0.666
                                      : 0.9) -
                                  130,
                            ),

                            Row(
                              children: [
                                TextLine(
                                  labelText: "Hours",
                                  hintText: "This contract covers this hours",
                                  controller: totalHoursController,
                                  size: MediaQuery.of(context).size.width *
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.9) * 0.5 - 123,
                                ),
                                TextLine(
                                  labelText: "Dislocation",
                                  hintText: "Total kms",
                                  controller: kmController,
                                  size: MediaQuery.of(context).size.width *
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.9)  * 0.5 - 130,
                                ),
                              ],
                            ),
                            TextLine(
                              labelText: "Duration",
                              hintText: "Duration",
                              controller: durationController,
                              size: MediaQuery.of(context).size.width *
                                  (Responsive.isDesktop(context)
                                      ? 0.666
                                      : 0.9) -
                                  216,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.all<Color>(firstColor),
                                  value: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                    });
                                  },
                                ),
                                const Text("Auto Renovation" ,style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
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