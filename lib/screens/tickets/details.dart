import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Asset.dart';
import 'package:sma_frontend/widgets/tickets_components.dart';
import '../../consts.dart';
import '../../models/Task.dart';
import '../../models/Ticket.dart';
import '../../models/User.dart';
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
  final ticketAssignedController = TextEditingController();
  final ticketDescriptionController = TextEditingController();
  final ticketCategoryController = TextEditingController();
  final ticketEntityController = TextEditingController();
  final ticketStatusController = TextEditingController();
  final ticketStartDateController = TextEditingController();
  final ticketEstimatedTimeController = TextEditingController();
  final ticketIsSolvedController = TextEditingController();
  final ticketFilesPathController = TextEditingController();

  bool editMode = false;

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
      ticketAssignedController.text = ticket.assistant?.fullName() ?? 'Unassigned';
      ticketEntityController.text = ticket.entity.toString();
      ticketStatusController.text = ticket.status;
      ticketStartDateController.text = ticket.startDate;
      ticketEstimatedTimeController.text = "${ticket.contractId} months";
      ticketIsSolvedController.text =
          ticket.isSolved == true ? "Solved" : "Unsolved";
      ticketFilesPathController.text = ticket.filesPath ?? "No files";
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

  void saveChanges() async {
    await Ticket.update(ticket, );
    Get.snackbar('Ticket Updated!', 'Your changes have been saved.', backgroundColor: Colors.green.withOpacity(0.5));
  }
  delete() async{
    Ticket.delete(ticket);
    Get.snackbar('Ticket Deleted!', 'Ticket #${ticket.id} ${ticket.title} has been deleted', backgroundColor: Colors.redAccent.withOpacity(0.5));
    Get.toNamed('/tickets');
  }

  assignUser(User user){
    Ticket.assignUser(ticket, user);
    ticketAssignedController.text = user.fullName();
    Get.snackbar('User Assigned!', '${user.fullName()} has been assigned to Ticket #${ticket.id} ${ticket.title}', backgroundColor: Colors.green.withOpacity(0.5));
  }

  @override
  void initState() {
    GetStorage().read('token') ?? Get.toNamed('/login');
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
                                  height: MediaQuery.of(context).size.height > 760 ? 670 : MediaQuery.of(context).size.height -140,
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
                                                isEnabled: editMode,
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
                                                    isEnabled: editMode,
                                                  ),
                                                  TextLine(
                                                    labelText: "Assigned To",
                                                    hintText: "no. 23213",
                                                    controller:
                                                        ticketAssignedController,
                                                    size: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 0.666
                                                                : 0.9) *
                                                            0.5 -
                                                        167,
                                                    isEnabled: editMode,
                                                  ),
                                                ],
                                              ),
                                              TextArea(
                                                labelText: "Description",
                                                hintText: "Ticket Description",
                                                controller:
                                                    ticketDescriptionController,
                                                height: 256,
                                                isEnabled: editMode,
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
                                                    isEnabled: editMode,
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
                                                    isEnabled: editMode,
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
                                                    isEnabled: editMode,
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
                                                    isEnabled: editMode,
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
                                                    isEnabled: editMode,
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
                                                    isEnabled: editMode,
                                                  )
                                                ],
                                              ),
                                              Row(children: [
                                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                                  child: OutlinedButton (
                                                    onPressed: (){
                                                      Get.toNamed('/tickets/${ticket.id}');
                                                    },
                                                    child: const Text("Go Back",style: TextStyle(color: Colors.white),),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                                  child: OutlinedButton (
                                                    onPressed: (){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext dialogContext) {
                                                          return ConfirmationDialog(title: 'Confirm Delete', message: 'You are about to delete Ticket #${ticket.id} - ${ticket.title}\nAre you sure you want to continue?', callback: delete);
                                                        },
                                                      );
                                                    },
                                                    child: const Text("Delete",style: TextStyle(color: Colors.white),),
                                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
                                                  ),
                                                ),
                                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                                  child: ElevatedButton(
                                                    onPressed: (){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext dialogContext){
                                                          return AssignUserDialog(
                                                            title: 'Assign User to ticket ${ticket.title}',
                                                            assignUserFunction: assignUser
                                                          );
                                                        }
                                                      );
                                                      setState(() {
                                                        editMode = false;
                                                      });
                                                    },
                                                    child: const Text("Assign"),
                                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),),
                                                  ),
                                                ),
                                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                                  child: ElevatedButton(
                                                    onPressed: (){
                                                      setState(() {
                                                        editMode = !editMode;
                                                      });
                                                    },
                                                    child: ((){
                                                      if(editMode){
                                                        return const Text("Cancel");
                                                      }
                                                      return const Text("Edit");
                                                    })(),
                                                    style: editMode ? ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(thirdColor5),) : ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(firstColor),),
                                                  ),
                                                ),
                                                if(editMode)Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                                  child: ElevatedButton(
                                                    onPressed: (){
                                                      setState(() {
                                                        editMode = false;
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
                                      tasksLoaded ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text('Create Task'),
                                              IconButton(onPressed: () async{
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext dialogContext) {
                                                    return NewTaskDialog(title: 'Create task for Ticket #${ticket.id} - ${ticket.title}', actions: [],userId: GetStorage().read('user_id'), ticketId: ticket.id,);
                                                  },
                                                );
                                                loadTasks();
                                              }, icon: const Icon(Icons.add))
                                            ],
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height > 760 ? 598 : MediaQuery.of(context).size.height -212,
                                            child: ListView.builder(
                                                itemBuilder: (context, index) {
                                                  return TaskView(
                                                      task: tasks[index],
                                                      isLine: true);
                                                },
                                                itemCount: tasks.length),
                                          ),
                                        ],
                                      ) : const CircularProgressIndicator(),
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
                                      labelText: "Assigned To",
                                      hintText: "no. 23213",
                                      controller: ticketAssignedController,
                                      size: MediaQuery.of(context).size.width * 0.5 - 146,
                                      isEnabled: false,
                                    ),
                                  ],
                                ),
                                TextArea(
                                  labelText: "Description",
                                  hintText: "Ticket Description",
                                  controller: ticketDescriptionController,
                                  height: 400,
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
                                          onPressed: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext dialogContext) {
                                                return NewTaskDialog(title: 'Create task for Ticket #${ticket.id} - ${ticket.title}', actions: [],userId: GetStorage().read('user_id'), ticketId: ticket.id,);
                                              },
                                            );
                                            loadTasks();
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


