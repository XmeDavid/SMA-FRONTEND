import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Asset.dart';
import '../../consts.dart';
import '../../models/Task.dart';
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
                            child: Column(
                              children: [
                                TextLine(
                                  labelText: "Title",
                                  hintText: "Exemplo: Frigorifico deita agua",
                                  controller: ticketTitleController,
                                  size: MediaQuery.of(context).size.width *
                                      (Responsive.isDesktop(context)
                                          ? 0.666
                                          : 0.86),
                                  isEnabled: false,
                                ),
                                Row(
                                  children: [
                                    TextLine(
                                      labelText: "Contract ID",
                                      hintText: "no. 23213",
                                      controller: ticketContractController,
                                      size: MediaQuery.of(context).size.width *
                                              (Responsive.isDesktop(context)
                                                  ? 0.666
                                                  : 0.9) *
                                              0.5 -
                                          117,
                                      isEnabled: false,
                                    ),
                                    TextLine(
                                      labelText: "Assistant ID",
                                      hintText: "no. 23213",
                                      controller: ticketContractController,
                                      size: MediaQuery.of(context).size.width *
                                              (Responsive.isDesktop(context)
                                                  ? 0.666
                                                  : 0.9) *
                                              0.5 -
                                          117,
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
                                  size: MediaQuery.of(context).size.width *
                                          (Responsive.isDesktop(context)
                                              ? 0.666
                                              : 0.9) -
                                      70,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Entity",
                                  hintText: "Entity",
                                  controller: ticketEntityController,
                                  size: MediaQuery.of(context).size.width *
                                          (Responsive.isDesktop(context)
                                              ? 0.666
                                              : 0.9) -
                                      30,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Start Date",
                                  hintText: "Start Date",
                                  controller: ticketStartDateController,
                                  size: MediaQuery.of(context).size.width *
                                          (Responsive.isDesktop(context)
                                              ? 0.666
                                              : 0.9) -
                                      77,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Estimated Time",
                                  hintText: "Estimated",
                                  controller: ticketEstimatedTimeController,
                                  size: MediaQuery.of(context).size.width *
                                          (Responsive.isDesktop(context)
                                              ? 0.666
                                              : 0.9) -
                                      130,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Status",
                                  hintText: "Status",
                                  controller: ticketStatusController,
                                  size: MediaQuery.of(context).size.width *
                                          (Responsive.isDesktop(context)
                                              ? 0.666
                                              : 0.9) -
                                      39,
                                  isEnabled: false,
                                ),
                                TextLine(
                                  labelText: "Is Solved",
                                  hintText: "Is Solved",
                                  controller: ticketIsSolvedController,
                                  size: MediaQuery.of(context).size.width *
                                          (Responsive.isDesktop(context)
                                              ? 0.666
                                              : 0.9) -
                                      63,
                                  isEnabled: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        tasksLoaded
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height - 216,
                                child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return TaskView(
                                          task: tasks[index], isCard: true);
                                    },
                                    itemCount: tasks.length))
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

class TaskView extends StatelessWidget {
  const TaskView(
      {Key? key, required this.task, this.isCard = false, this.isLine = false})
      : super(key: key);

  final bool isLine;
  final bool isCard;
  final Task task;

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void goToTask() {
    Get.toNamed("/tickets/tasks/${task.id}");
  }

  @override
  Widget build(BuildContext context) {
    if (isCard) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        child: Container(
          height: 128,
          decoration: BoxDecoration(
            border: Border.all(color: secondColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              TextButton(
                onPressed: task != null
                    ? () {
                        goToTask();
                        //Get.toNamed("/tickets/task/${task?.id}");
                      }
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: secondColor),
                      )),
                      child: Row(
                        children: [
                          Text(
                            (task.title).length > 28
                                ? "${task.title.substring(0, 25)}..."
                                : task.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            " - ${task.startDate.substring(0, 10)}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 8),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          "${task?.description}",
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color.fromRGBO(224, 224, 224, 1),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(color: secondColor),
                )),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "assignee",
                              style: TextStyle(
                                  color: Color.fromRGBO(224, 224, 224, 0.5),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10),
                            ),
                            Text(
                              task != null && task?.user != null
                                  ? "${task!.user!.fullName().length <= 12 ? task?.user?.fullName() : '${task?.user?.fullName().substring(0, 10)}...'}"
                                  : "Unassigned",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: () {
                          var s = task?.entity?.id ?? "";
                          Get.toNamed('entities/$s');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "End Date",
                              style: TextStyle(
                                  color: Color.fromRGBO(224, 224, 224, 0.5),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10),
                            ),
                            Text(
                              task?.endDate ?? "No end date",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "due in",
                              style: TextStyle(
                                  color: Color.fromRGBO(224, 224, 224, 0.5),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10),
                            ),
                            Text(
                              task.endDate == null ? "No Ending Date": "${daysBetween(DateTime.parse(task.startDate), DateTime.parse(task.endDate ?? ''))} days",
                              //"${task?.endDate} days",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Icon(Icons.menu)),
                    //const Icon(Icons.menu,size: 10,))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    if (isLine) {
      return Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
          ),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: secondColor3),
            child: Row(
              children: [
                /** Task Title and start date */
                TextButton(
                  onPressed: () {
                    Get.toNamed('/tickets/tasks/${task.id}');
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 256,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 1,
                              bottom: 1,
                              right: 5,
                              left: 5,
                            ),
                            child: Text(
                              (task?.title ?? "").length > 25
                                  ? "${task?.title.substring(0, 26)}..."
                                  : "${task?.title}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                      Container(
                        width: 256,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            " - ${task?.startDate.substring(0, 10)}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /** Category */
                TextButton(
                    onPressed: task.entityId == null
                        ? null
                        : () {
                            Get.toNamed('entities/${task.entityId}');
                          },
                    child: Container(
                      width: 128,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Entity",
                            style: TextStyle(color: Colors.grey, fontSize: 9),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 1,
                              bottom: 1,
                              right: 5,
                              left: 5,
                            ),
                            child: Text(
                              task.entity == null
                                  ? "Unknown"
                                  : task.entity!.id.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    )),
                /** Assigned user */
                TextButton(
                    onPressed: task.userId == null
                        ? null
                        : () {
                            Get.toNamed('/users/${task.userId}');
                          },
                    child: Container(
                      width: 160,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Padding(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "assigned to",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 9),
                              ),
                            ),
                          ),
                          Container(
                              child: Padding(
                            padding: const EdgeInsets.only(
                              top: 1,
                              bottom: 1,
                              right: 5,
                              left: 5,
                            ),
                            child: Text(
                              task.user == null
                                  ? "Unassigned"
                                  : task.user!.fullName().length > 30
                                      ? "${task.user!.fullName().substring(0, 30)}..."
                                      : task.user!.fullName(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                        ],
                      ),
                    )),

                /** Created by */
                if (MediaQuery.of(context).size.width > 1200)
                  TextButton(
                      onPressed: () {
                        //Get.toNamed('tickets/tasks/${task.id}');
                      },
                      child: Container(
                        width: 200,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: const Padding(
                                padding: EdgeInsets.all(0),
                                child: Text(
                                  "End Date",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 9),
                                ),
                              ),
                            ),
                            Container(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                top: 1,
                                bottom: 1,
                                right: 5,
                                left: 5,
                              ),
                              child: Text(
                                task.entity == null
                                    ? "Unknown"
                                    : task.entity!.name.length > 23
                                        ? "${task.entity!.name.substring(0, 23)}..."
                                        : task.entity!.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                          ],
                        ),
                      )),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      goToTask();
                    },
                    child: const Icon(Icons.menu)),
              ],
            ),
          ));
    }
    return Container();
  }
}
