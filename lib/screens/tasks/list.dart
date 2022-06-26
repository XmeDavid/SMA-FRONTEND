import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sma_frontend/consts.dart';
import 'package:sma_frontend/models/Ticket.dart';
import 'package:sma_frontend/models/TicketCategory.dart';
import 'package:sma_frontend/responsive.dart';
import 'package:sma_frontend/screens/side_menu.dart';
import 'package:sma_frontend/widgets/Card.dart';


import '../../models/TicketStates.dart';
import '../../widgets/ticketView.dart';

class ListTicketScreen extends StatefulWidget {
  const ListTicketScreen({Key? key}) : super(key: key);

  @override
  State<ListTicketScreen> createState() => _ListTicketScreenState();
}

class _ListTicketScreenState extends State<ListTicketScreen> {

  bool loaded = false;
  List<Ticket> tickets = [];
  List<TicketCategory>? categories;

  TicketState _status = TicketState(TicketState.PENDING);
  int _category = -1;

  var searchController = TextEditingController();

  void loadTickets() async {
    if(!loaded){
      var t = await Ticket.getAll(true,_status.state, searchController.text, _category);
      if(t == null) return;
      setState(() {
        tickets = t;
        loaded = true;
      });
    }
  }

  void loadCategories() async {
    var c = await TicketCategory.getAll();
    if(c == null) return;
    setState((){
      categories = c;
      categories!.add(TicketCategory(id: -1, name: "Any", description: "Any category. This serves as a default of no filter by category"));
    });
  }

  @override
  void initState() {
    super.initState();
    loadTickets();
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width < 1000 ? AppBar(
        title: const Text("Ticket Management"),
        backgroundColor: bgColor,
      ) : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          children: [
            if(Responsive.isDesktop(context)) const Expanded(child: SideMenu()),
            Expanded(
              flex: 6,
              child: Responsive.isDesktop(context) ?
              /** Desktop Version */Row(
                children: [
                  Container(
                    width: 200,
                    height: MediaQuery.of(context).size.height ,
                    color: secondColor3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text("Queues",
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(TicketState.values.length, (index) {
                              return TextButton(
                                  onPressed: (){
                                    setState(() {
                                      _status.state = TicketState.values[index];
                                      loaded = false;
                                    });
                                    loadTickets();
                                  },
                                  child: Row(children: [
                                    Text(TicketState.values[index],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: (TicketState.values[index] == _status.state) ? FontWeight.bold : FontWeight.normal
                                      ),
                                    ),
                                    const Spacer()
                                  ],)

                              );
                            }),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * (6/7)-200,
                        height: 60,
                        color: thirdColor3.withOpacity(0.5),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: SizedBox(
                                width: 128,
                                height: 30,
                                child: TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Search"),
                                  onEditingComplete: () {
                                    setState((){
                                      loaded = false;
                                    });
                                    loadTickets();
                                  },
                                ),
                              ),
                            ),
                            /**
                             * Convert from Ticket State to Category
                             */
                            if(categories != null)Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: DropdownButton(
                                items: List.generate(
                                  categories!.length,
                                  (index){
                                    return DropdownMenuItem(
                                      value: categories![index].id,
                                      child: Text(categories![index].name)
                                    );
                                  }
                                ),
                                onChanged: (dynamic newValue) {
                                  setState(() {
                                    _category = newValue;
                                    loaded = false;
                                  });
                                  loadTickets();
                                },
                                value: _category,
                                underline: DropdownButtonHideUnderline(
                                  child: Container(),
                                ),
                              ),
                            ),/**/
                          ]
                        ),
                      ),
                      Container(
                        color: bgColor,
                        width: MediaQuery.of(context).size.width * (6/7)-200,
                        height: MediaQuery.of(context).size.height - 60,
                        child: ListView.builder(
                            itemBuilder: (context, index){
                              return TicketView(ticket: tickets[index], isLine: true,);
                            },
                            itemCount: tickets.length
                        ),
                      )
                    ],
                  )
                ],
              ):
              /** Mobile Version */
              Container(
                color: bgColor,
                child: Column(
                  children: [
                    Container(
                      color: secondColor3,
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: DropdownButton(
                                  items: List.generate(
                                      TicketState.values.length,
                                          (index){
                                        return DropdownMenuItem(
                                            value: TicketState.values[index],
                                            child: Text(TicketState.values[index])
                                        );
                                      }
                                  ),
                                  onChanged: (dynamic newValue) {
                                    setState(() {
                                      _status.state = newValue;
                                      loaded = false;
                                    });
                                    loadTickets();
                                  },
                                  value: _status.state,
                                  underline: DropdownButtonHideUnderline(
                                    child: Container(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("data")
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height-216,
                      child: ListView.builder(
                          itemBuilder: (context, index){
                            return TicketView(ticket: tickets[index], isCard: true,);
                          },
                          itemCount: tickets.length
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
