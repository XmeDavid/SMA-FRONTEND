import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Asset.dart';
import '../../consts.dart';
import '../../models/Task.dart';
import '../../models/Ticket.dart';
import '../../responsive.dart';
import '../../widgets/tasks_components.dart';
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
  bool tasksLoaded = false;
  late Ticket ticket;
  late List<Task> tasks;

  void load() async {
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
      ticketIsSolvedController.text =
          ticket.isSolved == true ? "Solved" : "Unsolved";
      ticketFilesPathController.text = ticket.filesPath;
      loaded = true;
    });
  }

  void loadTasks() async {
    List<Task>? _tasks = await Task.getAll(true);
    if (_tasks == null) {
      return;
    }

    setState(() {
      tasks = _tasks.where((task) => task.ticketId == ticket.id).toList();
      tasksLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    load();
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: !Responsive.isDesktop(context)
            ? AppBar(
                title: const Text("Dashboard"),
                backgroundColor: bgColor,
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.visibility)),
                    Tab(icon: Icon(Icons.task)),
                    Tab(icon: Icon(Icons.devices_other)),
                  ],
                ),
              )
            : null,
        drawer: const SideMenu(),
        body: SafeArea(
          child: loaded
              ? Responsive.isDesktop(context)
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
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.9),
                                  child: const ClipRRect(
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
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.9),
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
                                                controller:
                                                    ticketTitleController,
                                                size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        (Responsive.isDesktop(
                                                                context)
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
                                                    controller:
                                                        ticketContractController,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0.666
                                                                : 0.9) *
                                                            0.5 -
                                                        151,
                                                    isEnabled: false,
                                                  ),
                                                  TextLine(
                                                    labelText: "Assistant ID",
                                                    hintText: "no. 23213",
                                                    controller:
                                                        ticketContractController,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0.666
                                                                : 0.9) *
                                                            0.5 -
                                                        162,
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
                                                    controller:
                                                        ticketCategoryController,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0.666
                                                                : 0.9) *
                                                            0.5 -
                                                        116,
                                                    isEnabled: false,
                                                  ),
                                                  TextLine(
                                                    labelText: "Entity",
                                                    hintText: "Entity",
                                                    controller:
                                                        ticketEntityController,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0.666
                                                                : 0.9) *
                                                            0.5 -
                                                        116,
                                                    isEnabled: false,
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  TextLine(
                                                    labelText: "Start Date",
                                                    hintText: "Start Date",
                                                    controller:
                                                        ticketStartDateController,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0.666
                                                                : 0.9) *
                                                            0.5 -
                                                        116,
                                                    isEnabled: false,
                                                  ),
                                                  TextLine(
                                                    labelText: "Estimated Time",
                                                    hintText: "Estimated",
                                                    controller:
                                                        ticketEstimatedTimeController,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0.666
                                                                : 0.9) *
                                                            0.5 -
                                                        223,
                                                    isEnabled: false,
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  TextLine(
                                                    labelText: "Status",
                                                    hintText: "Status",
                                                    controller:
                                                        ticketStatusController,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0.666
                                                                : 0.9) *
                                                            0.5 -
                                                        116,
                                                    isEnabled: false,
                                                  ),
                                                  TextLine(
                                                    labelText: "Is Solved",
                                                    hintText: "Is Solved",
                                                    controller:
                                                        ticketIsSolvedController,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0.666
                                                                : 0.9) *
                                                            0.5 -
                                                        118,
                                                    isEnabled: false,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      tasksLoaded
                                          ? ListView.builder(
                                              itemBuilder: (context, index) {
                                                return TaskView(
                                                    task: tasks[index],
                                                    isLine: true);
                                              },
                                              itemCount: tasks.length)
                                          : const CircularProgressIndicator(),
                                      Text("Assets WAITING FOR BACKEND"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                TextLine(
                                  labelText: "Title",
                                  hintText: "Exemplo: Frigorifico deita agua",
                                  controller: ticketTitleController,
                                  size: MediaQuery.of(context).size.width - 86,
                                  isEnabled: false,
                                ),
                                Row(
                                  children: [
                                    TextLine(
                                      labelText: "Contract ID",
                                      hintText: "no. 23213",
                                      controller: ticketContractController,
                                      size: MediaQuery.of(context).size.width * 0.5 - 160,
                                      isEnabled: false,
                                    ),
                                    TextLine(
                                      labelText: "Assistant ID",
                                      hintText: "no. 23213",
                                      controller: ticketContractController,
                                      size: MediaQuery.of(context).size.width * 0.5 - 141,
                                      isEnabled: false,
                                    ),
                                  ],
                                ),
                                TextArea(
                                  labelText: "Description",
                                  hintText: "Ticket Description",
                                  controller: ticketDescriptionController,
                                  size: 400,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Category",
                                  hintText: "Category",
                                  controller: ticketCategoryController,
                                  size: MediaQuery.of(context).size.width-140,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Entity",
                                  hintText: "Entity",
                                  controller: ticketEntityController,
                                  size: MediaQuery.of(context).size.width-
                                      100,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Start Date",
                                  hintText: "Start Date",
                                  controller: ticketStartDateController,
                                  size: MediaQuery.of(context).size.width - 147,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Estimated Time",
                                  hintText: "Estimated",
                                  controller: ticketEstimatedTimeController,
                                  size: MediaQuery.of(context).size.width - 200,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Status",
                                  hintText: "Status",
                                  controller: ticketStatusController,
                                  size: MediaQuery.of(context).size.width - 109,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Is Solved",
                                  hintText: "Is Solved",
                                  controller: ticketIsSolvedController,
                                  size: MediaQuery.of(context).size.width - 133,
                                  isEnabled: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        tasksLoaded ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 216,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 200,
                                  child: Row(
                                    children: [
                                      Text("Create Task: "),
                                      TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext dialogContext) {
                                                return NewTaskDialog(title: 'Create task for Ticket #${ticket.id} - ${ticket.title}', actions: [],userId: GetStorage().read('user_id'), ticketId: ticket.id,);
                                              },
                                            );
                                          },
                                          child: const Icon(Icons.add)
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height - 416,
                                  child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        return TaskView(
                                            task: tasks[index], isCard: true);
                                      },
                                      itemCount: tasks.length
                                  ),
                                ),
                              ]
                            )
                        )
                            : const CircularProgressIndicator(),
                        Icon(Icons.directions_bike),
                      ],
                    )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}


