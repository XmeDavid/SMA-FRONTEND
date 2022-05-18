import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/Entity.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/api_interactions/api_functions.dart';

import '../../models/model_api.dart';
import '../../responsive.dart';
import '../../consts.dart';
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
  bool _isValidatedChecked = true;

  String getFrom() {
    if (dateRange == null) {
      return 'From';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange!.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Until';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange!.end);
    }
  }

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final durationController = TextEditingController();
  final coverController = TextEditingController();
  final budgetController = TextEditingController();
  final autoRenovationController = TextEditingController();
  final allowsSurplusController = TextEditingController();
  final isValidatedController = TextEditingController();
  final lastRenovationController = TextEditingController();

  String _selectedEntity = "";

  List<Entity> entities = <Entity>[];

  Future<List<String>> getEntities() async {
    if (entities.isEmpty) {
      entities = await ModelApi.getEntities(false);
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
                    height: MediaQuery.of(context).size.height * 0.9,
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
                                          : 0.9) -
                                  119,
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
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Color.fromRGBO(secondColor7.red,
                                    secondColor7.green, secondColor7.blue, 0.3),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Select a Start and End Date:"),
                                  Row(
                                    children: [

                                      Expanded(
                                        child: TextButton(
                                          onPressed: () =>
                                              pickDateRange(context),
                                          child: Text(getFrom()),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () =>
                                              pickDateRange(context),
                                          child: Text(getUntil()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TextLine(
                              labelText: "Budget",
                              hintText: "Set tbe budget",
                              controller: budgetController,
                              size: MediaQuery.of(context).size.width *
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.9) -
                                  178,
                            ),
                            TextLine(
                              labelText: "Cover",
                              hintText: "This contract Covers",
                              controller: coverController,
                              size: MediaQuery.of(context).size.width *
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.9) -
                                  178,
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
                                    value: _isAutoRenovationChecked,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _isAutoRenovationChecked = newValue!;
                                      });
                                    },
                                ),
                                const Text("Auto Renovation" ,style: TextStyle(color: Colors.white),),
                                Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all<Color>(firstColor),
                                    value: _isValidatedChecked,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _isValidatedChecked = newValue!;
                                      });
                                    },
                                ),
                                const Text("Validated" ,style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ApiClient().createContract(titleController.text, descriptionController.text, int.parse(_selectedEntity),
                                      getFrom(), int.parse(durationController.text), allowsSurplusController.text.toLowerCase()=="true" ? true : false, autoRenovationController.text.toLowerCase()=="true" ? true : false,
                                      coverController.text, double.parse(budgetController.text));
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

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }
}
