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

  int loadAttempts = 0;
  bool loaded = false;
  List<Ticket> tickets = [];

  void loadTickets() async {
    var t = await Ticket.get(1,true);
    if(t == null){
      loadAttempts++;
      return;
    }
    setState(() {
      tickets.add(t);
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width < 1100 ? AppBar(
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
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: secondColor3
                  ),
                  Container(
                    child: TicketView(
                      format: TicketViewFormat.SMALL,
                      ticket: loaded ? tickets.first : ((){
                        loadAttempts < 3 ? loadTickets() :  null;
                      })(),
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
