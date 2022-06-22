import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Asset.dart';
import '../../consts.dart';
import '../../models/Ticket.dart';
import '../../responsive.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class TicketDetails extends StatefulWidget {
  const TicketDetails({Key? key}) : super(key: key);

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  final ticketTitleController = TextEditingController();
  final ticketContractController = TextEditingController();
  final ticketDescriptionController = TextEditingController();
  final ticketCategoryController = TextEditingController();
  final ticketEntityController = TextEditingController();
  final ticketStatusController = TextEditingController();
  final ticketStartDateController = TextEditingController();
  final ticketEstimatedTimeController = TextEditingController();
  final ticketIsSolvedController = TextEditingController();
  final ticketFilesPathController = TextEditingController();

  bool loaded = false;
  late Ticket ticket;
  late Asset asset;

  void load() async {
    print(Get.parameters['id'] ?? 'Nada');
    Ticket? _ticket =
        await Ticket.get(int.parse(Get.parameters['id'] ?? ''), true);
    if (_ticket == null) {
      return;
    }
    setState(() {
      ticket = _ticket;
      ticketTitleController.text = ticket.title;
      ticketDescriptionController.text = ticket.description;
      ticketCategoryController.text = "${ticket.category}";
      ticketContractController.text = "${ticket.contractId}";
      ticketEntityController.text = ticket.entity.toString();
      ticketStatusController.text = ticket.status;
      ticketStartDateController.text = ticket.startDate;
      ticketEstimatedTimeController.text = "${ticket.contractId} months";
      ticketIsSolvedController.text = ticket.isSolved==true ? "Solved": "Unsolved";
      ticketFilesPathController.text = ticket.filesPath;
      loaded = true;
    });


  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: !Responsive.isDesktop(context)
            ? AppBar(title: const Text("Dashboard"), backgroundColor: bgColor)
            : null,
        drawer: const SideMenu(),
        body: SafeArea(
          child: loaded
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Responsive.isDesktop(context))
                      const Expanded(
                        flex: 1,
                        child: SideMenu(),
                      ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!Responsive.isMobile(context)) ...[
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    (Responsive.isDesktop(context)
                                        ? 0.666
                                        : 0.9),
                                child: const Text(
                                  "Ticket Detail",
                                  style: TextStyle(fontSize: 48),
                                ),
                              ),
                            ),
                          ],
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  (Responsive.isDesktop(context) ? 0.666 : 0.9),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                clipBehavior: Clip.hardEdge,
                                child: TabBar(
                                    indicator: BoxDecoration(
                                      color: secondColor3,
                                    ),
                                    labelStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    unselectedLabelStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    unselectedLabelColor: Colors.white60,
                                    tabs: [
                                      Tab(text: 'Details'),
                                      Tab(text: 'Tasks'),
                                      Tab(text: 'Assets Involved'),
                                    ]),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(defaultPadding),
                              decoration: const BoxDecoration(
                                color: secondColor3,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                              ),
                              height: 550,
                              width: MediaQuery.of(context).size.width *
                                  (Responsive.isDesktop(context) ? 0.666 : 0.9),
                              child: TabBarView(
                                children: [
                                  SingleChildScrollView(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          TextLine(
                                            labelText: "Title",
                                            hintText:
                                                "Exemplo: Frigorifico deita agua",
                                            controller: ticketTitleController,
                                            size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    (Responsive.isDesktop(context)
                                                        ? 0.666
                                                        : 0.9) -
                                                98,
                                            isEnabled: false,
                                          ),
                                          Row(
                                            children: [
                                              TextLine(
                                                labelText: "Contract ID",
                                                hintText: "no. 23213",
                                                controller: ticketContractController,
                                                size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    (Responsive.isDesktop(context)
                                                        ? 0.666
                                                        : 0.9) * 0.5 -151,
                                                isEnabled: false,
                                              ),
                                              TextLine(
                                                labelText: "Assistant ID",
                                                hintText: "no. 23213",
                                                controller: ticketContractController,
                                                size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    (Responsive.isDesktop(context)
                                                        ? 0.666
                                                        : 0.9) * 0.5 -162,
                                                isEnabled: false,
                                              ),
                                            ],
                                          ),
                                          TextArea(
                                            labelText: "Description",
                                            hintText: "Ticket Description",
                                            controller:
                                                ticketDescriptionController,
                                            size: 400,
                                            isEnabled: false,
                                          ),
                                          Row(
                                            children: [
                                              TextLine(
                                                labelText: "Category",
                                                hintText: "Category",
                                                controller: ticketCategoryController,
                                                size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    (Responsive.isDesktop(context)
                                                        ? 0.666
                                                        : 0.9) * 0.5 -116,
                                                isEnabled: false,
                                              ),
                                              TextLine(
                                                labelText: "Entity",
                                                hintText: "Entity",
                                                controller: ticketEntityController,
                                                size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    (Responsive.isDesktop(context)
                                                        ? 0.666
                                                        : 0.9) * 0.5 -116,
                                                isEnabled: false,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              TextLine(
                                                labelText: "Start Date",
                                                hintText: "Start Date",
                                                controller: ticketStartDateController,
                                                size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    (Responsive.isDesktop(context)
                                                        ? 0.666
                                                        : 0.9) * 0.5 -116,
                                                isEnabled: false,
                                              ),
                                              TextLine(
                                                labelText: "Estimated Time",
                                                hintText: "Estimated",
                                                controller: ticketEstimatedTimeController,
                                                size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    (Responsive.isDesktop(context)
                                                        ? 0.666
                                                        : 0.9) * 0.5 -223,
                                                isEnabled: false,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              TextLine(
                                                labelText: "Status",
                                                hintText: "Status",
                                                controller: ticketStatusController,
                                                size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    (Responsive.isDesktop(context)
                                                        ? 0.666
                                                        : 0.9) * 0.5 -116,
                                                isEnabled: false,
                                              ),
                                              TextLine(
                                                labelText: "Is Solved",
                                                hintText: "Is Solved",
                                                controller: ticketIsSolvedController,
                                                size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    (Responsive.isDesktop(context)
                                                        ? 0.666
                                                        : 0.9) * 0.5 -118,
                                                isEnabled: false,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(child: Text("TASKS WAITING FOR BACKEND")),
                                  Container(child: Column(
                                    children: [
                                      TextLine(
                                        labelText: "Title",
                                        hintText:
                                        "Exemplo: Frigorifico deita agua",
                                        controller: ticketTitleController,
                                        size: MediaQuery.of(context)
                                            .size
                                            .width *
                                            (Responsive.isDesktop(context)
                                                ? 0.666
                                                : 0.9) -
                                            98,
                                        isEnabled: false,
                                      ),
                                      Row(
                                        children: [
                                          TextLine(
                                            labelText: "Contract ID",
                                            hintText: "no. 23213",
                                            controller: ticketContractController,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) * 0.5 -151,
                                            isEnabled: false,
                                          ),
                                          TextLine(
                                            labelText: "Assistant ID",
                                            hintText: "no. 23213",
                                            controller: ticketContractController,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) * 0.5 -162,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                      TextArea(
                                        labelText: "Description",
                                        hintText: "Ticket Description",
                                        controller:
                                        ticketDescriptionController,
                                        size: 400,
                                        isEnabled: false,
                                      ),
                                      Row(
                                        children: [
                                          TextLine(
                                            labelText: "Category",
                                            hintText: "Category",
                                            controller: ticketCategoryController,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) * 0.5 -116,
                                            isEnabled: false,
                                          ),
                                          TextLine(
                                            labelText: "Entity",
                                            hintText: "Entity",
                                            controller: ticketEntityController,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) * 0.5 -116,
                                            isEnabled: false,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          TextLine(
                                            labelText: "Start Date",
                                            hintText: "Start Date",
                                            controller: ticketStartDateController,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) * 0.5 -116,
                                            isEnabled: false,
                                          ),
                                          TextLine(
                                            labelText: "Estimated Time",
                                            hintText: "Estimated",
                                            controller: ticketEstimatedTimeController,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) * 0.5 -223,
                                            isEnabled: false,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          TextLine(
                                            labelText: "Status",
                                            hintText: "Status",
                                            controller: ticketStatusController,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) * 0.5 -116,
                                            isEnabled: false,
                                          ),
                                          TextLine(
                                            labelText: "Is Solved",
                                            hintText: "Is Solved",
                                            controller: ticketIsSolvedController,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                (Responsive.isDesktop(context)
                                                    ? 0.666
                                                    : 0.9) * 0.5 -118,
                                            isEnabled: false,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

//Custom input field of ticket title
class TextField extends StatelessWidget {
  const TextField(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.controller,
      required this.size})
      : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(
            defaultPadding / 2, defaultPadding / 2, defaultPadding / 2, 1),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                color: thirdColor5,
              ),
              height: 40,
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        labelText,
                        style: const TextStyle(fontSize: 20),
                      ))),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                color: thirdColor3,
              ),
              height: 40,
              width: size,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    enabled: false,
                    contentPadding: const EdgeInsets.only(left: 10, bottom: 8),
                    hintText: hintText,
                    border: InputBorder.none),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ));
  }
}

//Custom Description Widget
class TextBox extends StatelessWidget {
  const TextBox(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.controller,
      required this.size})
      : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding / 2),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: thirdColor5,
            ),
            height: 40,
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      labelText,
                      style: const TextStyle(fontSize: 20),
                    ))),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: thirdColor3,
            ),
            height: 120,
            child: Center(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 6,
                maxLines: 20,
                controller: controller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    hintText: hintText,
                    border: InputBorder.none),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
