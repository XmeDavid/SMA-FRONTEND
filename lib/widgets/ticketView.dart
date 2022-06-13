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
        return 384;
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
        return 160;
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
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " - ${ticket?.startDate}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      "${ticket?.bodyDescription}",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(224, 224, 224, 1),
                          fontWeight: FontWeight.w300
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
                            fontSize: 14),
                      ),
                      Text(
                        "${ticket?.assistantId}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
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
                              fontSize: 14),
                        ),
                        Text(
                          "${ticket?.assistantId}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
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
                              fontSize: 14),
                        ),
                        Text(
                          "${ticket?.estimatedTime} day",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                ),
                const Spacer(),
                TextButton(onPressed: (){}, child: const Icon(Icons.menu))
              ],
            ),
          )
        ],
      ),
    );
  }
}
