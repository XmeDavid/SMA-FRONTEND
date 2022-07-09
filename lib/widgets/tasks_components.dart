import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sma_frontend/models/Intervention.dart';

import '../consts.dart';
import '../models/Task.dart';
import '../responsive.dart';
import 'ui_fields.dart';

class NewTaskDialog extends StatefulWidget {
  final String title;
  final List<Widget> actions;
  final int ticketId;
  final int userId;

  const NewTaskDialog({Key? key, required this.title, required this.actions, required this.ticketId, required this.userId}) : super(key: key);

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {

  var taskTitleController = TextEditingController();
  var taskDescriptionController = TextEditingController();

  void createTask() async{
    dynamic res = await Task.create(widget.userId, widget.ticketId, taskTitleController.text, taskDescriptionController.text);
    if(res['code'] == 422){
      //TODO Treat Empty Fields
    }
    if(res['code'] == 201){
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
      ),
      actions: widget.actions,
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextLine(
                labelText: "Task",
                hintText: "Task Title",
                controller: taskTitleController,
                size: MediaQuery.of(context).size.width * 0.6,
              ),
              TextArea(
                labelText: "Description",
                hintText: "Task Description",
                controller: taskDescriptionController,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              ElevatedButton(
                  onPressed: (){
                    createTask();
                  },
                  child: const Text("Create Ticket"))
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterInterventionDialog extends StatefulWidget {
  final String title;
  final List<Widget> actions;
  final int taskId;

  const RegisterInterventionDialog({Key? key, required this.title, required this.actions, required this.taskId}) : super(key: key);

  @override
  State<RegisterInterventionDialog> createState() => _RegisterInterventionState();
}

class _RegisterInterventionState extends State<RegisterInterventionDialog> {

  var startDate = TextEditingController();
  var endDate = TextEditingController();
  var description = TextEditingController();

  void createTask() async{
    try{
      await Intervention.create(widget.taskId, startDate.text, endDate.text, description.text);
      Navigator.of(context).pop();
    } on Exception catch(_){

    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
      ),
      content: Form(
        child: Container(
          width: 400,
          height: 428,
          child: Column(
            children: [
              TextLine(
                labelText: "Start Date",
                hintText: "When the intervention was started",
                controller: startDate,
                size: 273,
              ),
              TextLine(
                labelText: "End Date",
                hintText: "When the intervention was concluded",
                controller: endDate,
                size: 284,
              ),
              TextArea(
                labelText: "Record of the Intervention",
                hintText: "Here you can register a record of what happend in the intervention, what was done, etc...",
                controller: description,
                height: 204,
              ),
                widget.actions[1],
              Row(children: [
                const Spacer(),
                widget.actions[0],
              ],)
            ],
          ),
        ),
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
  final Task? task;

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void goToTask() {
    print("/tickets/${task?.ticketId ?? -1}/tasks/${task?.id ?? ""}");
    Get.toNamed("/tickets/${task?.ticketId ?? -1}/tasks/${task?.id ?? ""}");
  }

  @override
  Widget build(BuildContext context) {
    if (isCard && task != null) {
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
                onPressed: () {
                  goToTask();
                },
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
                            (task!.title).length > 28
                                ? "${task!.title.substring(0, 25)}..."
                                : task!.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            " - ${task!.startDate.substring(0, 10)}",
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
                          task!.description,
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
                          var s = task!.entity?.id ?? "";
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
                              task!.endDate ?? "No end date",
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
                              task!.endDate == null ? "No Ending Date": "${daysBetween(DateTime.parse(task!.startDate), DateTime.parse(task!.endDate ?? ''))} days",
                              //"${task?.endDate} days",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                    const Spacer(),
                    TextButton(onPressed: () {

                    }, child: const Icon(Icons.menu)),
                    //const Icon(Icons.menu,size: 10,))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    if (isLine  && task != null) {
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
                Expanded(
                  flex: 4,
                    child: TextButton(
                  onPressed: () {
                    Get.toNamed('/tickets/tasks/${task!.id}');
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                )
                ),
                /** Category */
                Expanded(flex: 2,
                  child:TextButton(
                    onPressed: task!.entityId == null
                        ? null
                        : () {
                      Get.toNamed('entities/${task!.entityId}');
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
                              task!.entity == null
                                  ? "Unknown"
                                  : task!.entity!.id.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    )),
                ),
                /** Assigned user */
                Expanded(
                  flex: 2,
                  child: TextButton(
                        onPressed: task!.userId == null
                            ? null
                            : () {
                          Get.toNamed('/users/${task!.userId}');
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
                                      task!.user == null
                                          ? "Unassigned"
                                          : task!.user!.fullName().length > 30
                                          ? "${task!.user!.fullName().substring(0, 30)}..."
                                          : task!.user!.fullName(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ],
                          ),
                        )),

                ),

                /** Created by */
                //if (MediaQuery.of(context).size.width > 1318)
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero
                      ),
                        onPressed: () {
                          //Get.toNamed('tickets/tasks/${task.id}');
                        },
                        child: Container(
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
                                      task!.entity == null
                                          ? "Unknown"
                                          : task!.entity!.name.length > 23
                                          ? "${task!.entity!.name.substring(0, 23)}..."
                                          : task!.entity!.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ],
                          ),
                        )),
                  ),
                IconButton(
                  onPressed: () {
                    goToTask();
                  },
                  icon: const Icon(Icons.arrow_forward_ios)
                ),
              ],
            ),
          ));
    }
    return Container();
  }
}
