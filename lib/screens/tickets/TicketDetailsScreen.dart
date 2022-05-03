import 'package:flutter/material.dart';
import '../../consts.dart';
import '../../responsive.dart';
import '../side_menu.dart';

class TicketDetails extends StatefulWidget {
  const TicketDetails({Key? key}) : super(key: key);

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  @override
  Widget build(BuildContext context) {
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
                  child: SideMenu(),
                ),
              Expanded(
                flex: 6,
                child: Center(
                  child: Column(
                    children: [
                      Padding(padding: const EdgeInsets.only(top: 10),

                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                          child: TabBar(indicator: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          ),
                              tabs: [
                                Tab(text: 'Ticket Details'),
                                Tab(text: 'Tasks'),
                                Tab(text: 'Assets Involved'),
                                Tab(text: 'Intervetions'),
                              ]),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: const BoxDecoration(
                            color: secondColor3,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                        child: TabBarView(
                          children: [
                            Container(child: Text("JAneiro")),
                            Container(child: Text("123")),
                            Container(child: Text("321")),
                            Container(child: Text("defefer")),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



