import 'package:flutter/material.dart';
import 'package:sma_frontend/consts.dart';
import 'package:sma_frontend/screens/side_menu.dart';

import '../responsive.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({Key? key}) : super(key: key);

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {

  final _formKey = GlobalKey<FormState>();

  final ticketTitleController = TextEditingController();
  final ticketDescriptionController = TextEditingController();

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
                  width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.8),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextField(
                            labelText: "Title",
                            hintText: "Ticket Title",
                            controller: ticketTitleController,
                            size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.8) - 98,
                          ),
                          TextBox(
                              labelText: "Description",
                              hintText: "Ticket Description",
                              controller: ticketDescriptionController,
                              size: 400)
                        ],
                      ),
                    )
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


class TextField extends StatelessWidget {
  const TextField({Key? key, required this.labelText ,required this.hintText, required this.controller, required this.size}) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding/2),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                ),
                color: thirdColor5,
              ),
              height: 40,
              child: Center(
                child:Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    labelText,
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  )
                )
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                color: thirdColor3,
              ),
              height: 40,
              width: size,
              child: Center(
                child:TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10,bottom: 8),
                    hintText: hintText,
                    border: InputBorder.none
                  ),
                  style: const TextStyle(
                    fontSize: 20
                  ),
                  ),
                ),
              ),
          ],
      )
    );
  }
}

class TextBox extends StatelessWidget {
  const TextBox({Key? key, required this.labelText ,required this.hintText, required this.controller, required this.size}) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double size;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding/2),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
              ),
              color: thirdColor5,
            ),
            height: 40,
            child: Center(
                child:Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      labelText,
                      style: const TextStyle(
                          fontSize: 20
                      ),
                    )
                )
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              color: thirdColor3,
            ),
            height: 120,
            child: Center(
              child:TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 6,
                maxLines: 6,
                controller: controller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10,bottom: 8),
                    hintText: hintText,
                    border: InputBorder.none
                ),
                style: const TextStyle(
                    fontSize: 16
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

