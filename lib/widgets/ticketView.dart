import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sma_frontend/consts.dart';

import '../models/Ticket.dart';

class TicketView extends StatelessWidget {
  const TicketView(
      {Key? key,
      required this.ticket,
      this.isCard = false,
      this.isLine = false})
      : super(key: key);

  final bool isLine;
  final bool isCard;
  final Ticket? ticket;

  void goToTicket(){
    Get.toNamed("/tickets/${ticket?.id}");
  }

  @override
  Widget build(BuildContext context) {
    if (isCard) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        child: Container(
          height: 128,
          decoration: BoxDecoration(
            border: Border.all(color: secondColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              TextButton(
                onPressed: ticket != null
                    ? () {
                        goToTicket();
                        //Get.toNamed("/tickets/${ticket?.id}");
                      }
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: secondColor),
                      )),
                      child: Row(
                        children: [
                          Text(
                            (ticket?.title ?? "").length > 28
                                ? "${ticket?.title.substring(0, 25)}..."
                                : "${ticket?.title}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            " - ${ticket?.startDate.substring(0, 10)}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 8),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          "${ticket?.description}",
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color.fromRGBO(224, 224, 224, 1),
                              fontWeight: FontWeight.normal),
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
                )),
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
                              ticket != null && ticket?.assistant != null
                                  ? "${ticket!.assistant!.fullName().length <= 12 ? ticket?.assistant?.fullName() : '${ticket?.assistant?.fullName().substring(0, 10)}...'}"
                                  : "Unassigned",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: () {
                          var s = ticket?.entity?.id ?? "";
                          Get.toNamed('entities/${s}');
                        },
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
                              ticket != null
                                  ? ticket!.entity!.name.length <= 12
                                      ? ticket!.entity!.name
                                      : '${ticket!.entity!.name.substring(0, 10)}...'
                                  : "Unknown",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
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
                        )),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Icon(Icons.menu)),
                    //const Icon(Icons.menu,size: 10,))
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    if (isLine) {
      return Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
          ),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: secondColor3),
            child: Row(
              children: [
                /** Ticket Title and created date */
                TextButton(
                  onPressed: ticket != null ?(){
                    Get.toNamed('/tickets/${ticket!.id}');
                  } : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 256,
                          child: Padding(
                        padding: const EdgeInsets.only(
                          top: 1,
                          bottom: 1,
                          right: 5,
                          left: 5,
                        ),
                        child: Text(
                          (ticket?.title ?? "").length > 25
                              ? "${ticket?.title.substring(0, 26)}..."
                              : "${ticket?.title}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                      Container(
                        width: 256,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            " - ${ticket?.startDate.substring(0, 10)}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /** Category */
                TextButton(
                  onPressed: (){
                    Get.toNamed('categories/${ticket?.categoryId}');
                  },
                  child: Container(
                    width: 128,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "category",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 9),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 1,
                            bottom: 1,
                            right: 5,
                            left: 5,
                          ),
                          child: Text(
                            ticket?.category == null ? "Unknown" : ticket!.category!.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  )
                ),
                /** Assignee */
                TextButton(
                    onPressed: ticket != null ? ticket?.assistant != null ? () {
                      Get.toNamed('/users/${ticket!.assistant!.id}');
                    } : null : null,
                    child: Container(
                      width: 160,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Padding(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "assigned to",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 9),
                              ),
                            ),
                          ),
                          Container(
                              child: Padding(
                            padding: const EdgeInsets.only(
                              top: 1,
                              bottom: 1,
                              right: 5,
                              left: 5,
                            ),
                            child: Text(
                              ticket?.assistant == null
                                  ? "Unassigned"
                                  : ticket!.assistant!.fullName().length > 30
                                      ? "${ticket!.assistant!.fullName().substring(0, 30)}..."
                                      : ticket!.assistant!.fullName(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                        ],
                      ),
                    )),

                /** Created by */
                if (MediaQuery.of(context).size.width > 1200) TextButton(
                    onPressed: () {
                      Get.toNamed('tickets/${ticket?.id}');
                    },
                    child: Container(
                      width: 200,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Padding(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "created by",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 9),
                              ),
                            ),
                          ),
                          Container(
                              child: Padding(
                            padding: const EdgeInsets.only(
                              top: 1,
                              bottom: 1,
                              right: 5,
                              left: 5,
                            ),
                            child: Text(
                              ticket?.entity == null
                                  ? "Unknown"
                                  : ticket!.entity!.name.length > 23
                                      ? "${ticket!.entity!.name.substring(0, 23)}..."
                                      : ticket!.entity!.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                        ],
                      ),
                    )
                ),
                const Spacer(),
                TextButton(onPressed: () {
                  goToTicket();
                }, child: const Icon(Icons.menu)),
              ],
            ),
          ));
    }
    return Container();
  }
}
