import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Address.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/Country.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/TicketCategory.dart';


import '../../api_interactions/api_functions.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
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

  bool taskLoaded = false;
  late Task task;

  void loadEntity() async{
    var _task = await Task.get(int.parse(Get.parameters['id'] ?? ''),true);
    if(_task == null) return;
    setState(() {
      task = _task;
      title.text = task.title;
      description.text = task.description;
      startDate.text = task.startDate;
      endDate.text = task.endDate ?? "";
      taskLoaded = true;
    });
  }

  void saveChanges() async{
    var _task = Task.update(title.text, description.text, "endDate");
  }

  void delete() {
    Task.delete(task.id);
  }

  @override
  void initState(){
    super.initState();
    loadEntity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: /*!Responsive.isDesktop(context)*/false ? AppBar(
        title: Text(taskLoaded ? task.title : "Unknown Task"),
        backgroundColor: bgColor,
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.visibility)),
            Tab(icon: Icon(Icons.task)),
            Tab(icon: Icon(Icons.devices_other)),
          ],
        ),
      ) :
      AppBar(title: Text(taskLoaded ? task.title : "Unknown Task"), backgroundColor: bgColor),
      drawer: const SideMenu(),
      body: SafeArea(
        child: taskLoaded ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 6,
              child: Center(child:Column(
                  children:[
                    if(Responsive.isDesktop(context)) SizedBox(
                        width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                        child: Row(
                          children:  [
                            Text(task.title,
                              style: const TextStyle(
                                  fontSize: 48
                              ),
                            ),
                            const Spacer()
                          ],
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: const BoxDecoration(
                          color: secondColor3,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      height: Responsive.isDesktop(context) ? MediaQuery.of(context).size.height * 0.8 : MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
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
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 98,
                              ),
                              TextArea(
                                isEnabled: isEditMode,
                                labelText: "Description",
                                hintText: "Description",
                                controller: description,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                              ),
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Start Date",
                                hintText: "Start Date",
                                controller: startDate,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 159,
                              ),
                              if(endDate.text != "" || isEditMode)TextLine(
                                isEnabled: isEditMode,
                                labelText: "End Date",
                                hintText: "End Date",
                                controller: endDate,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 148,
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
                                  child: OutlinedButton (
                                    onPressed: (){
                                      delete();
                                      Get.toNamed('/tickets/${task.ticketId ?? ""}');
                                    },
                                    child: const Text("Delete",style: TextStyle(color: Colors.white),),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
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
                  ]),
              ),
            ),
          ],
        ) : const Center(child: CircularProgressIndicator()),
    ),
      );
  }

}