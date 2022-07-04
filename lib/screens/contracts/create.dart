import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/Entity.dart';
import 'package:sma_frontend/api_interactions/api_functions.dart';

import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/datePicker.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class NewContractScreen extends StatefulWidget {
  const NewContractScreen({Key? key}) : super(key: key);

  @override
  State<NewContractScreen> createState() => _NewContractScreen();
}

class _NewContractScreen extends State<NewContractScreen> {
  DateTimeRange? dateRange;
  bool _isAutoRenovationChecked = true;
  DateTime? selectedDate;

  void showDatePanel(TextEditingController controller) async {
    var tempDate = await getDateFromPicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (tempDate != null) {
      setState(() {
        selectedDate = tempDate;
        controller.text =
            "${selectedDate?.day.toString().padLeft(2, "0") ?? ""}-${selectedDate?.month.toString().padLeft(2, "0") ?? ""}-${selectedDate?.year.toString().padLeft(4, "0") ?? ""}";
      });
    }
  }

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
              title: const Text("Create Contract"), backgroundColor: bgColor)
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
                            "Create Contract",
                            style: TextStyle(fontSize: 48),
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
                            TextLine(
                              labelText: "Title",
                              hintText: "Title",
                              controller: titleController,
                              size: MediaQuery.of(context).size.width *
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.9) -98,
                            ),
                            DropDown(
                              label: "Entity Associated",
                              callback: (s) => {_selectedEntity = s},
                              getData: getEntities,
                            ),
                            TextLine(
                              labelText: "Description",
                              hintText: "Description of the contract",
                              controller: descriptionController,
                              size: MediaQuery.of(context).size.width *
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.9) -
                                  172,
                            ),
                            Container(
                              padding: const EdgeInsets.all(defaultPadding / 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft:
                                                  Radius.circular(10)),
                                          color: thirdColor5,
                                        ),
                                        height: 40,
                                        child: const Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "Start Date",
                                                  style: TextStyle(
                                                      fontSize: 20),
                                                ))),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: thirdColor3,
                                        ),
                                        height: 40,
                                        width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (Responsive.isDesktop(
                                                        context)
                                                    ? 0.666
                                                    : 0.9) -199,
                                        child: Center(
                                          child: TextFormField(
                                            controller: startDateController,
                                            decoration:
                                                const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 10,
                                                            bottom: 8),
                                                    hintText: "dd-mm-yyyy",
                                                    border:
                                                        InputBorder.none),
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
                                                topRight:
                                                    Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            color: thirdColor5,
                                          ),
                                          height: 40,
                                          child: IconButton(
                                              onPressed: () =>
                                                  showDatePanel(
                                                      startDateController),
                                              icon: const Icon(Icons
                                                  .calendar_month_outlined))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(defaultPadding / 2),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft:
                                          Radius.circular(10)),
                                      color: thirdColor5,
                                    ),
                                    height: 40,
                                    child: const Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "End Date",
                                              style: TextStyle(
                                                  fontSize: 20),
                                            ))),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: thirdColor3,
                                    ),
                                    height: 40,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        (Responsive.isDesktop(
                                            context)
                                            ? 0.666
                                            : 0.9) -188,
                                    child: Center(
                                      child: TextFormField(
                                        controller: endDateController,
                                        decoration:
                                        const InputDecoration(
                                            contentPadding:
                                            EdgeInsets.only(
                                                left: 10,
                                                bottom: 8),
                                            hintText: "dd-mm-yyyy",
                                            border:
                                            InputBorder.none),
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
                                            topRight:
                                            Radius.circular(10),
                                            bottomRight:
                                            Radius.circular(10)),
                                        color: thirdColor5,
                                      ),
                                      height: 40,
                                      child: IconButton(
                                          onPressed: () =>
                                              showDatePanel(
                                                  endDateController),
                                          icon: const Icon(Icons
                                              .calendar_month_outlined))),
                                ],
                              ),
                            ),
                            TextLine(
                              labelText: "Budget",
                              hintText: "Set the budget",
                              controller: budgetController,
                              size: MediaQuery.of(context).size.width *
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.9) -130,
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
                                              : 0.9) *
                                          0.5 -
                                      123,
                                ),
                                TextLine(
                                  labelText: "Dislocation",
                                  hintText: "Total kms",
                                  controller: kmController,
                                  size: MediaQuery.of(context).size.width *
                                          (Responsive.isDesktop(context)
                                              ? 0.666
                                              : 0.9) *
                                          0.5 -
                                      130,
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
                                          : 0.9) -145,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.all<Color>(
                                      firstColor),
                                  value: _isAutoRenovationChecked,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _isAutoRenovationChecked = newValue!;
                                    });
                                  },
                                ),
                                const Text(
                                  "Auto Renovation",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  int entityNo = entities.firstWhere(
                                          (element) =>
                                    element.id.toString() + " - " + element.name == _selectedEntity
                                  ).id;
                                  Future<Contract> contract = Contract.create(
                                      titleController.text,
                                      descriptionController.text,
                                      entityNo,
                                      '${selectedDate?.year ?? '1970'}-${selectedDate?.month.toString().padLeft(2, '0') ?? '01'}-${selectedDate?.day.toString().padLeft(2, '0') ?? '01'}',
                                      int.parse(durationController.text),
                                      allowsSurplusController.text.toLowerCase() == "true" ? true : false,
                                      autoRenovationController.text.toLowerCase() == "true" ? true : false,
                                      totalHoursController.text,
                                      kmController.text,
                                      double.parse(budgetController.text));

                                  if (contract.toString().isNotEmpty) {
                                    Get.toNamed("/contracts");
                                  }
                                },
                                child: const Text("Create Contract"))
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
