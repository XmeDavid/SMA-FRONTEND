import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sma_frontend/consts.dart';

import '../models/Ticket.dart';

enum TicketViewFormat { SMALL, WIDE, TALL, LARGE }

class TicketView extends StatelessWidget {
  const TicketView({Key? key, required this.ticket, required this.format})
      : super(key: key);

  final TicketViewFormat format;
  final Ticket? ticket;

  double width() {
    switch (format) {
      case TicketViewFormat.SMALL:
        return 288;
      case TicketViewFormat.WIDE:
        return 1024;
      case TicketViewFormat.TALL:
        return 512;
      case TicketViewFormat.LARGE:
        return 1024;
    }
  }

  double height() {
    switch (format) {
      case TicketViewFormat.SMALL:
        return 96;
      case TicketViewFormat.WIDE:
        return 256;
      case TicketViewFormat.TALL:
        return 512;
      case TicketViewFormat.LARGE:
        return 512;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(),
      height: height(),
      decoration: BoxDecoration(
        border: Border.all(color: secondColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          TextButton(
            onPressed: ticket != null
                ? () {
                    Get.toNamed("/tickets/${ticket?.id}");
                  }
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: secondColor),
                      )
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${ticket?.title}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " - ${ticket?.startDate.substring(0,10)}",
                        style: const TextStyle(color: Colors.grey, fontSize: 8),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
                Container(
                  height: 38,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      "${ticket?.description}",
                      style: const TextStyle(
                          fontSize: 10,
                          color: Color.fromRGBO(224, 224, 224, 1),
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: secondColor),
              )
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "assignee",
                        style: TextStyle(
                            color: Color.fromRGBO(224, 224, 224, 0.5),
                            fontWeight: FontWeight.normal,
                            fontSize: 10),
                      ),
                      Text(
                        ticket != null ? "${ticket!.assistant!.fullName().length <= 12 ? ticket?.assistant?.fullName() : '${ticket?.assistant?.fullName().substring(0,10)}...'}" : "Unassigned",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  )
                ),
                TextButton(
                    onPressed: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "created by",
                          style: TextStyle(
                              color: Color.fromRGBO(224, 224, 224, 0.5),
                              fontWeight: FontWeight.normal,
                              fontSize: 10),
                        ),
                        Text(
                          ticket != null ? ticket!.entity!.name.length <= 12 ? ticket!.entity!.name : '${ticket!.entity!.name.substring(0,10)}...' : "Unknown",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                ),
                TextButton(
                    onPressed: null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "due in",
                          style: TextStyle(
                              color: Color.fromRGBO(224, 224, 224, 0.5),
                              fontWeight: FontWeight.normal,
                              fontSize: 10),
                        ),
                        Text(
                          "${ticket?.estimatedTime} days",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                ),
                Container(
                  width: 1,
                  child: TextButton(onPressed: (){}, child: Icon(Icons.menu)),
                )
                //const Icon(Icons.menu,size: 10,))
              ],
            ),
          )
        ],
      ),
    );
  }
}
