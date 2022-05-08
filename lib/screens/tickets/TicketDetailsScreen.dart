import 'package:flutter/material.dart';
import '../../consts.dart';
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

  @override
  Widget build(BuildContext context) {
    ticketTitleController.text = "New Ticket";
    ticketContractController.text = "New Contract";
    ticketDescriptionController.text = "New Description";
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: !Responsive.isDesktop(context) ? AppBar(title: const Text ("Dashboard"), backgroundColor: bgColor) : null,
        drawer: const SideMenu(),
        body: SafeArea(
          child: Row(
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
                        if (Responsive.isDesktop(context)) ...[
                          Padding(
                            padding: EdgeInsets.only(left: 130, top: 30, bottom: 20),
                            child: Text("Ticket Details", style: TextStyle(fontSize: 40)),
                          ),
                        ],
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                            child: TabBar(indicator: BoxDecoration(
                              color: secondColor3,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                            ),
                                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                unselectedLabelColor: Colors.white60,
                                tabs: [
                                  Tab(text: 'Details'),
                                  Tab(text: 'Tasks'),
                                  Tab(text: 'Assets Involved'),
                                  Tab(text: 'Intervetions'),
                                ]),
                          ),
                        ),
                        Center(
                          child:
                          Container(
                            padding: const EdgeInsets.all(defaultPadding),
                            decoration: const BoxDecoration(
                              color: secondColor3,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            height: 550,
                            width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                            child: TabBarView(
                              children: [
                                Container(
                                  child: Column(
                                    children:[
                                      TextLine(
                                        labelText: "Title",
                                        hintText: "Exemplo: Frigorifico deita agua",
                                        controller: ticketTitleController,
                                        size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 98,
                                        isEnabled: false,
                                      ),
                                      TextLine(
                                        labelText: "Contract ID",
                                        hintText: "no. 23213",
                                        controller: ticketContractController,
                                        size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 172,
                                        isEnabled: false,
                                      ),
                                      TextArea(
                                        labelText: "Description",
                                        hintText: "Ticket Description",
                                        controller: ticketDescriptionController,
                                        size: 400,
                                        isEnabled: false,
                                      ),
                                      Container(
                                        //Ver melhor isto da width para ambientes de telemv
                                        padding: EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: thirdColor3,
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                          child: Row(
                                            children: [
                                              Text("Categorias: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                              //Usar um foreach ?
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.all(2),
                                                      child: InputChip(
                                                          label: Text("Categoria 1")),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(2),
                                                      child: InputChip(
                                                          label: Text("Categoria 2")),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(2),
                                                      child: InputChip(
                                                          label: Text("Categoria 3")),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(2),
                                                      child: InputChip(
                                                          label: Text("Categoria 4")),
                                                    ),
                                                  ],
                                                )
                                              )
                                            ],
                                          ),
                                        ),
                                      Container(
                                        margin: EdgeInsets.all(defaultPadding/2),
                                        //Ver melhor isto da width para ambientes de telemv
                                        padding: EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: thirdColor3,
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("Assets: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                            //Usar um foreach ?
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                              child: InputChip(
                                                  label: Text("Asset 1")),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                              child: InputChip(
                                                  label: Text("Asset 2")),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(child: Text("123")),
                                Container(child: Text("321")),
                                Container(child: Text("defefer")),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Custom input field of ticket title
class TextField extends StatelessWidget {
  const TextField({Key? key, required this.labelText ,required this.hintText, required this.controller, required this.size}) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(defaultPadding/2, defaultPadding/2, defaultPadding/2, 1),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)
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
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)
                ),
                color: thirdColor3,
              ),
              height: 40,
              width: size,
                child:TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                      enabled: false,
                      contentPadding: const EdgeInsets.only(left: 10,bottom: 8),
                      hintText: hintText,
                      border: InputBorder.none
                  ),
                  style: const TextStyle(
                      fontSize: 20
                  ),
                ),
            ),
          ],
        )
    );
  }
}

//Custom Description Widget
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
                maxLines: 20,
                controller: controller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
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

