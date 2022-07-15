import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/screens/side_menu.dart';
import 'package:sma_frontend/widgets/dashboardWidgets/AssetsDashboardCard.dart';

import '../config.dart';
import '../consts.dart';
import '../models/Ticket.dart';
import '../responsive.dart';
import '../widgets/BarChartComponent.dart';
import '../widgets/Card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Ticket> tickets;
  bool isTicketsloaded = false;

  void loadTickets() async {
    var tempTickets = await Ticket.getAll(true, "", "", -1);
    if (tempTickets == null) return;
    setState(() {
      tickets = tempTickets;
      isTicketsloaded = true;
    });
  }

  List<Ticket> filterBy(status) {
    return tickets
        .where((ticket) =>
            ticket.status.toUpperCase().removeAllWhitespace == status)
        .toList();
  }

  @override
  void initState() {
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: MediaQuery.of(context).size.width < 1000
          ? AppBar(
              title: const Text("Dashboard"),
              backgroundColor: bgColor,
            )
          : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            // It takes 5/6 part of the screen
            Expanded(
              // It takes 5/6 part of the screen
              flex: 6,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      isTicketsloaded
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  TicketCard(
                                      icon: Icons.person_add_alt_1_rounded,
                                      label: 'Unassigned Tickets',
                                      amount:
                                          filterBy("PENDING").length.toString(),
                                      color: Colors.red),
                                  TicketCard(
                                      icon: Icons.access_time,
                                      label: 'On going Tickets',
                                      amount:
                                          filterBy("ONGOING").length.toString(),
                                      color: Colors.orange),
                                  TicketCard(
                                      icon: Icons.check_circle,
                                      label: 'Resolved Tickets',
                                      amount:
                                          filterBy("SOLVED").length.toString(),
                                      color: Colors.green),
                                  TicketCard(
                                      icon: Icons.search,
                                      label: 'Needing Validation',
                                      amount: filterBy("VALIDATION")
                                          .length
                                          .toString(),
                                      color: firstColor),
                                ],
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      /*Container(
                          decoration: const BoxDecoration(
                              color: secondColor3,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          padding: const EdgeInsets.all(20),
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [Text("Performance")]),
                                  Text("Mensal")
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 3,
                              ),
                              Container(
                                height: 178,
                                child: BarChartComponent(),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 5,
                              ),
                            ],
                          )),*/
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      AssetsDashboardCard()
                    ],
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
