import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/EntityType.dart';

import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/datePicker.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class ContractsDetailsScreen extends StatefulWidget {
  const ContractsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ContractsDetailsScreen> createState() => _ContractsDetailsScreen();
}

class _ContractsDetailsScreen extends State<ContractsDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final entityTypeController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final durationController = TextEditingController();
  final totalKmsController = TextEditingController();
  final totalHoursController = TextEditingController();
  final budgetController = TextEditingController();
  final allowsSurplusController = TextEditingController();
  final isValidatedController = TextEditingController();
  final lastRenovationController = TextEditingController();
  final dateFormatted = DateFormat('dd-MM-yyyy');
  final dateFormattedDetailed = DateFormat('dd-MM-yyyy hh:mm');

  bool isEditMode = false;
  bool autoRenovation = false;
  bool isValidated = false;

  bool loaded = false;
  late Contract contract;
  late EntityType entityType;
  DateTime? selectedDate;

  void getEntityType() async {
    List<EntityType> entityTypes = await EntityType.getAll();
    entityTypes.where((element) => element.id != 1).map((e) => e.name).toList();
    setState(() {
      entityType = entityTypes
          .where((element) => element.id == contract.entitiesId)
          .first;
      loaded = true;
    });
  }

  void loadContract() async {
    //var contracts = await ModelApi.getContracts();
    var _contract =
        await Contract.get(int.parse(Get.parameters['id'] ?? ''), true);
    setState(() {
      contract = _contract;
      titleController.text = contract.title;
      descriptionController.text = contract.description;
      //vai ser entityType
      startDateController.text =
          dateFormatted.format(DateTime.parse(contract.startDate));
      endDateController.text =
          dateFormatted.format(DateTime.parse(contract.endDate));
      durationController.text = contract.duration;
      budgetController.text = contract.budget.toString();
      lastRenovationController.text = contract.lastRenovation != null
          ? dateFormattedDetailed
              .format(DateTime.parse(contract.lastRenovation!))
          : "No renovation done yet";
      autoRenovation = contract.autoRenovation;
      isValidated = contract.isValidated;
      loaded = true;
    });
    getEntityType();
  }

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

  void saveChanges() {
    print("saving");
  }

  void delete() async{
    Contract.remove(contract.id);
    Get.toNamed('/contracts');
  }

  @override
  void initState() {
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadContract();
  }

  @override
  Widget build(BuildContext context) {
    String radioValue;
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              title: const Text("Contract Details"), backgroundColor: bgColor)
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
              child: loaded
                  ? Center(
                      child: Column(children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width *
                                (Responsive.isDesktop(context) ? 0.666 : 0.9),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    contract.entity?.name ?? 'ss',
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                ),
                                const Spacer()
                              ],
                            )),
                        Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          decoration: const BoxDecoration(
                              color: secondColor3,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width *
                              (Responsive.isDesktop(context) ? 0.666 : 0.9),
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
                                    size: MediaQuery.of(context).size.width *
                                            (Responsive.isDesktop(context)
                                                ? 0.666
                                                : 0.9) -
                                        98,
                                  ),
                                  DropDown(
                                    label: "Entity Type",
                                    callback: (s) =>
                                        {entityTypeController.text},
                                    getData: getEntityType,
                                    selected: entityTypeController.text,
                                    enabled: contract.entitiesId == 1
                                        ? false
                                        : isEditMode,
                                  ),
                                  TextArea(
                                    labelText: "Description",
                                    hintText: "Description of the contract",
                                    controller: descriptionController,
                                    height: 160,
                                    isEnabled: false,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(
                                          defaultPadding / 2),
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
                                                        : 0.9) -
                                                199,
                                            child: Center(
                                              child: TextFormField(
                                                enabled: isEditMode,
                                                controller: startDateController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                bottom: 8),
                                                        hintText: "yyyy-mm-dd",
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
                                                  onPressed: () => isEditMode
                                                      ? showDatePanel(
                                                          startDateController)
                                                      : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor: Colors
                                                              .deepOrangeAccent,
                                                          content: Text(
                                                              "To make a change enable edit mode",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)))),
                                                  icon: const Icon(Icons
                                                      .calendar_month_outlined))),
                                        ],
                                      )),
                                  Container(
                                      padding: const EdgeInsets.all(
                                          defaultPadding / 2),
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
                                                        : 0.9) -
                                                188,
                                            child: Center(
                                              child: TextFormField(
                                                enabled: isEditMode,
                                                controller: endDateController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                bottom: 8),
                                                        hintText: "yyyy-mm-dd",
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
                                                  onPressed: () => isEditMode
                                                      ? showDatePanel(
                                                          endDateController)
                                                      : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor: Colors
                                                              .deepOrangeAccent,
                                                          content: Text(
                                                              "To make a change enable edit mode",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)))),
                                                  icon: const Icon(Icons
                                                      .calendar_month_outlined))),
                                        ],
                                      )),
                                  Row(
                                    children: [
                                      TextLine(
                                        isEnabled: isEditMode,
                                        labelText: "Duration",
                                        hintText: "Duration in months",
                                        controller: durationController,
                                        size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) *
                                                0.5 -
                                            145,
                                      ),
                                      TextLine(
                                        isEnabled: isEditMode,
                                        labelText: "Budget",
                                        hintText: "budget available",
                                        controller: budgetController,
                                        size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) *
                                                0.5 -
                                            98,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      TextLine(
                                        isEnabled: isEditMode,
                                        labelText: "Hours",
                                        hintText: "Number of hours covered",
                                        controller: totalHoursController,
                                        size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) *
                                                0.5 -
                                            87,
                                      ),
                                      TextLine(
                                        isEnabled: isEditMode,
                                        labelText: "Kms",
                                        hintText: "Kilometers covered",
                                        controller: totalKmsController,
                                        size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) *
                                                0.5 -
                                            98,
                                      ),
                                    ],
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(
                                          defaultPadding / 2),
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
                                                      "Last Renovation",
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
                                                        : 0.9) -
                                                256,
                                            child: Center(
                                              child: TextFormField(
                                                enabled: true,
                                                controller:
                                                    lastRenovationController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                bottom: 8),
                                                        hintText: "yyyy-mm-dd",
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
                                                  onPressed: () => isEditMode
                                                      ? showDatePanel(
                                                          lastRenovationController)
                                                      : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor: Colors
                                                              .deepOrangeAccent,
                                                          content: Text(
                                                              "To make a change enable edit mode",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)))),
                                                  icon: const Icon(Icons
                                                      .calendar_month_outlined))),
                                        ],
                                      )),
                                  Row(
                                    children: [
                                      Checkbox(
                                          checkColor: Colors.white,
                                          fillColor:
                                              MaterialStateProperty.all<Color>(
                                                  firstColor),
                                          value: autoRenovation,
                                          onChanged: (bool? newValue) {
                                            isEditMode
                                                ? setState(() {
                                                    autoRenovation =
                                                        !autoRenovation;
                                                  })
                                                : ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor: Colors
                                                            .deepOrangeAccent,
                                                        content: Text(
                                                            "To make a change enable edit mode",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))));
                                          }),
                                      const Text(
                                        "Auto Renovation",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Checkbox(
                                          checkColor: Colors.white,
                                          fillColor:
                                              MaterialStateProperty.all<Color>(
                                                  firstColor),
                                          value: isValidated,
                                          onChanged: (bool? newValue) {
                                            isEditMode
                                                ? setState(() {
                                                    isValidated = !isValidated;
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                  })
                                                : ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor: Colors
                                                            .deepOrangeAccent,
                                                        content: Text(
                                                            "To make a change enable edit mode",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))));
                                          }),
                                      const Text(
                                        "Validated",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            defaultPadding / 2),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Get.toNamed('/contracts');
                                          },
                                          child: const Text(
                                            "Go Back",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                        child: OutlinedButton (
                                          onPressed: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext dialogContext) {
                                                return ConfirmationDialog(title: 'Confirm Delete', message: 'You are about to delete Contract #${contract.id} - ${contract.title}\nAre you sure you want to continue?', callback: delete);
                                              },
                                            );
                                          },
                                          child: const Text("Delete",style: TextStyle(color: Colors.white),),
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            defaultPadding / 2),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isEditMode = !isEditMode;
                                              autoRenovation = contract.autoRenovation;
                                              isValidated = contract.isValidated;
                                              ScaffoldMessenger.of(
                                                  context).clearSnackBars();
                                            });
                                          },
                                          child: (() {
                                            if (isEditMode) {
                                              return const Text("Cancel");
                                            }
                                            return const Text("Edit");
                                          })(),
                                          style: isEditMode
                                              ? ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(thirdColor5),
                                                )
                                              : ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(firstColor),
                                                ),
                                        ),
                                      ),
                                      if (isEditMode)
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              defaultPadding / 2),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isEditMode = false;
                                              });
                                              saveChanges();
                                            },
                                            child: const Text("Save"),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.green),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
