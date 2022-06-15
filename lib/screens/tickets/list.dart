import 'package:flutter/material.dart';
import 'package:sma_frontend/consts.dart';
import 'package:sma_frontend/models/Ticket.dart';
import 'package:sma_frontend/responsive.dart';
import 'package:sma_frontend/screens/side_menu.dart';
import 'package:sma_frontend/widgets/Card.dart';

import '../../widgets/ticketView.dart';

class ListTicketScreen extends StatefulWidget {
  const ListTicketScreen({Key? key}) : super(key: key);

  @override
  State<ListTicketScreen> createState() => _ListTicketScreenState();
}

class _ListTicketScreenState extends State<ListTicketScreen> {

  bool loaded = false;
  List<Ticket> tickets = [];

  void loadTickets() async {
    var t = await Ticket.getAll(true);
    if(t == null) return;
    setState(() {
      tickets = t;
      loaded = true;
    });
    print('${tickets.length}');
  }

  @override
  void initState() {
    super.initState();
    loadTickets();
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
                        TextButton(
                          onPressed: (){},
                          child: const Text("All Tickets",
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height,
                    color: secondColor3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: loaded ? List.generate(30, (index)
                        {
                          print("Ticket: ${tickets[index].title}");
                          return Container(
                            padding: const EdgeInsets.all(8),
                            child: TicketView(
                              format: TicketViewFormat.SMALL,
                              ticket: tickets[index],
                            )
                          );
                        }) : [
                          TicketView(ticket: null, format: TicketViewFormat.SMALL)
                        ],
                      ),
                    )
                  ),
                  Spacer(),

                ],
              ):
              /** Mobile Version */Container()
            )
          ],
        ),
      ),
    );
  }
}
