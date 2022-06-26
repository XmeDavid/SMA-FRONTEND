import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/TicketCategory.dart';


import '../../api_interactions/api_functions.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
import '../../models/Ticket.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskState();
}

class _NewTaskState  extends State<NewTaskScreen> {

  final _formKey = GlobalKey<FormState>();

  var ticketTitleController = TextEditingController();
  var ticketDescriptionController = TextEditingController();

  int ticketId = -1;
  int userId = -1;

  @override
  void initState() {
    ticketId = Get.parameters['id'] == null ? -1 : int.parse(Get.parameters['id'] ?? '');
    userId = GetStorage().read('user_id') == null ? -1 : int.parse(GetStorage().read('user_id') ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? AppBar(title: const Text ("Dashboard"), backgroundColor: bgColor) : null,
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
                child:Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                    color: secondColor3,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextLine(
                              labelText: "Title",
                              hintText: "Ticket Title",
                              controller: ticketTitleController,
                              size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 98,
                            ),
                            TextArea(
                                labelText: "Description",
                                hintText: "Ticket Description",
                                controller: ticketDescriptionController,
                                size: MediaQuery.of(context).size.height * 0.6,
                            ),
                            //TODO Still need a way to input estimated time
                            //TODO Maybe add option to attach files
                            ElevatedButton(
                                onPressed: (){
                                 },
                                child: const Text("Create Ticket"))
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


