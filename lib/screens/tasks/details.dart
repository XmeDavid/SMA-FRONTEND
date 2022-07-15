import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sma_frontend/models/Intervention.dart';
import 'package:sma_frontend/widgets/tasks_components.dart';
import 'package:sma_frontend/widgets/tickets_components.dart';

import '../../models/Task.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsState();


}

class _TaskDetailsState  extends State<TaskDetailsScreen> {

  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final description = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();

  bool isEditMode = false;

  bool loaded = false;
  late Task task;
  late List<Intervention> interventions;

  void loadTask() async{
    var _task = await Task.get(int.parse(Get.parameters['id'] ?? ''),true);
    if(_task == null) return;
    var _interventions = await Intervention.getAll(_task.id);
    setState(() {
      task = _task;
      interventions = _interventions;
      title.text = task.title;
      description.text = task.description;
      startDate.text = task.startDate;
      endDate.text = task.endDate ?? "";
      loaded = true;
    });
  }


  void saveChanges() async{
    var _task = Task.update(task.id ,title.text, description.text, "endDate");
  }

  void delete() {
    Task.delete(task.id);
    Get.toNamed('/tickets/${task.ticketId ?? ""}');
  }

  @override
  void initState(){
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isDesktop(context) ? null : AppBar(title: Text(loaded ? task.title : "Unknown Task"), backgroundColor: bgColor),
      drawer: const SideMenu(),
      body: SafeArea(
        child: loaded ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 6,
              child: Responsive.isDesktop(context) ? Center(child:Column(
                  children:[
                    if(Responsive.isDesktop(context)) SizedBox(
                        width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                        child: Row(
                          children:  [
                            Text(task.title,
                              style: const TextStyle(
                                  fontSize: 32
                              ),
                            ),
                            const Spacer()
                          ],
                        )
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          decoration: const BoxDecoration(
                              color: secondColor3,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Title",
                                    hintText: "Title",
                                    controller: title,
                                    size: MediaQuery.of(context).size.width * 0.4 - 98,
                                  ),
                                  TextArea(
                                    isEnabled: isEditMode,
                                    labelText: "Description",
                                    hintText: "Description",
                                    controller: description,
                                    height: (MediaQuery.of(context).size.height * 0.8 - 300)  < 200 ? 200 : (MediaQuery.of(context).size.height * 0.8 - 300),
                                  ),
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Start Date",
                                    hintText: "Start Date",
                                    controller: startDate,
                                    size: MediaQuery.of(context).size.width * 0.4 - 159,
                                  ),
                                  if(endDate.text != "" || isEditMode)TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "End Date",
                                    hintText: "End Date",
                                    controller: endDate,
                                    size: MediaQuery.of(context).size.width * 0.4 -148,
                                  ),
                                  Row(children: [
                                    Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                      child: OutlinedButton (
                                        onPressed: (){
                                          Get.toNamed('/tickets/${task.ticketId ?? ""}');
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
                                              return ConfirmationDialog(title: 'Confirm Delete', message: 'You are about to delete Task #${task.id} - ${task.title}\nAre you sure you want to continue?', callback: delete);
                                            },
                                          );
                                        },
                                        child: const Text("Delete",style: TextStyle(color: Colors.white),),
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
                                      ),
                                    ),
                                    Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                      child: OutlinedButton (
                                        onPressed: (){
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext dialogContext) {
                                              return AssignUserDialog(title: 'Assign user to Task #${task.id} - ${task.title}', assignUserFunction: (){});
                                            },
                                          );
                                        },
                                        child: const Text("Assign",style: TextStyle(color: Colors.white),),
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),),
                                      ),
                                    ),
                                    Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                      child: ElevatedButton(
                                        onPressed: (){
                                          setState(() {
                                            isEditMode = !isEditMode;
                                          });
                                        },
                                        child: ((){
                                          if(isEditMode){
                                            return const Text("Cancel");
                                          }
                                          return const Text("Edit");
                                        })(),
                                        style: isEditMode ? ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(thirdColor5),) : ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(firstColor),),
                                      ),
                                    ),
                                    if(isEditMode)Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                      child: ElevatedButton(
                                        onPressed: (){
                                          setState(() {
                                            isEditMode = false;
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
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(defaultPadding/2),
                          decoration: const BoxDecoration(
                              color: secondColor3,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                padding: const EdgeInsets.all(defaultPadding/2),
                                child: Row(
                                  children: [
                                    const Text("Interventions",
                                      style: TextStyle(
                                        fontSize: 20
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext dialogContext) {
                                            return RegisterInterventionDialog(
                                              title: "Register Intervention",
                                              taskId: task.id,
                                              actions: [
                                                TextButton(
                                                    onPressed: (){
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text("Cancel")
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }, 
                                      icon: const Icon(Icons.add)
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.8 - 61,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: interventions.length,
                                    itemBuilder: (context, index){
                                      return Padding(
                                          padding: const EdgeInsets.all(defaultPadding/2),
                                          child: Container(
                                              padding: const EdgeInsets.all(defaultPadding/2),
                                              decoration: const BoxDecoration(
                                                  color: secondColor5,
                                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("Intervention #${index+1} "),
                                                      Text(" - id ${interventions[index].id}",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.grey
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      IconButton(
                                                        icon: Icon(Icons.remove,size: 16,),
                                                        onPressed: (){
                                                          Intervention.remove(interventions[index].id);
                                                          setState((){
                                                            interventions.removeAt(index);
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  Text("from ${interventions[index].startDate} to ${interventions[index].endDate}"),
                                                  SizedBox(height: 10,),
                                                  Text("${interventions[index].description}")
                                                ],
                                              )
                                          )
                                      );
                                    }
                                ),
                              )

                            ],
                          )
                        ),
                        Spacer()
                      ],
                    ),

                  ]),
              ) : /** MOBILE */
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding/2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLine(
                        isEnabled: isEditMode,
                        labelText: "Title",
                        hintText: "Title",
                        controller: title,
                        size: MediaQuery.of(context).size.width - 82,
                      ),
                      TextArea(
                        isEnabled: isEditMode,
                        labelText: "Description",
                        hintText: "Description",
                        controller: description,
                        height: 256,
                      ),
                      TextLine(
                        isEnabled: isEditMode,
                        labelText: "Start Date",
                        hintText: "Start Date",
                        controller: startDate,
                        size: MediaQuery.of(context).size.width - 143,
                      ),
                      if(endDate.text != "" || isEditMode)TextLine(
                        isEnabled: isEditMode,
                        labelText: "End Date",
                        hintText: "End Date",
                        controller: endDate,
                        size: MediaQuery.of(context).size.width - 132,
                      ),
                      Row(
                        children: [
                          Padding(padding: const EdgeInsets.all(defaultPadding/2),
                            child: OutlinedButton (
                              onPressed: (){
                                Get.toNamed('/tickets/${task.ticketId ?? ""}');
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
                                    return ConfirmationDialog(title: 'Confirm Delete', message: 'You are about to delete Task #${task.id} - ${task.title}\nAre you sure you want to continue?', callback: delete);
                                  },
                                );
                              },
                              child: const Text("Delete",style: TextStyle(color: Colors.white),),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(defaultPadding/2),
                            child: OutlinedButton (
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AssignUserDialog(title: 'Assign user to Task #${task.id} - ${task.title}', assignUserFunction: (){});
                                  },
                                );
                              },
                              child: const Text("Assign",style: TextStyle(color: Colors.white),),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(defaultPadding/2),
                            child: ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  isEditMode = !isEditMode;
                                });
                              },
                              child: ((){
                                if(isEditMode){
                                  return const Text("Cancel");
                                }
                                return const Text("Edit");
                              })(),
                              style: isEditMode ? ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(thirdColor5),) : ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(firstColor),),
                            ),
                          ),
                          if(isEditMode)Padding(padding: const EdgeInsets.all(defaultPadding/2),
                            child: ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  isEditMode = false;
                                });
                                saveChanges();
                              },
                              child: const Text("Save"),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green),),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          const Text("Interventions",
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return RegisterInterventionDialog(
                                      title: "Register Intervention",
                                      taskId: task.id,
                                      actions: [
                                        TextButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel")
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.add)
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: interventions.length,
                            itemBuilder: (context, index){
                              return Padding(
                                  padding: const EdgeInsets.all(defaultPadding/2),
                                  child: Container(
                                      padding: const EdgeInsets.all(defaultPadding/2),
                                      decoration: const BoxDecoration(
                                          color: secondColor5,
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Intervention #${index+1} "),
                                              Text(" - id ${interventions[index].id}",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon: Icon(Icons.remove,size: 16,),
                                                onPressed: (){
                                                  Intervention.remove(interventions[index].id);
                                                  setState((){
                                                    interventions.removeAt(index);
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                          Text("from ${interventions[index].startDate} to ${interventions[index].endDate}"),
                                          SizedBox(height: 10,),
                                          Text("${interventions[index].description}")
                                        ],
                                      )
                                  )
                              );
                            }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ) : const Center(child: CircularProgressIndicator()),
    ),
      );
  }

}