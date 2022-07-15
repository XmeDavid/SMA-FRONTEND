import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../consts.dart';
import '../models/Ticket.dart';
import '../responsive.dart';

class BarChartComponent extends StatelessWidget {
  const BarChartComponent({Key? key, required this.tickets}) : super(key: key);
  final List<Ticket> tickets;

  @override
  Widget build(BuildContext context) {
    final double mostRegisteredMonth = getMostRegisteredTicketMonth(tickets);
    return BarChart(
      BarChartData(
          maxY: mostRegisteredMonth,
          borderData: FlBorderData(show: false),
          alignment: BarChartAlignment.spaceBetween,
          axisTitleData:
              FlAxisTitleData(leftTitle: AxisTitle(reservedSize: 20)),
          gridData:
              FlGridData(drawHorizontalLine: true, horizontalInterval: 10),
          titlesData: FlTitlesData(
              leftTitles: SideTitles(
                interval: 5,
                reservedSize: 10,
                getTextStyles: (value) =>
                    const TextStyle(color: Colors.grey, fontSize: 12),
                showTitles: true,
                getTitles: (value) {
                  if (value.toInt() == 0) {
                    return '0';
                  } else {
                    return value.toInt().toString();
                  }
                },
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) =>
                    const TextStyle(color: Colors.grey, fontSize: 10),
                getTitles: (value) {
                  if (value == 0) {
                    return 'JAN';
                  } else if (value == 1) {
                    return 'FEB';
                  } else if (value == 2) {
                    return 'MAR';
                  } else if (value == 3) {
                    return 'APR';
                  } else if (value == 4) {
                    return 'MAY';
                  } else if (value == 5) {
                    return 'JUN';
                  } else if (value == 6) {
                    return 'JUL';
                  } else if (value == 7) {
                    return 'AUG';
                  } else if (value == 8) {
                    return 'SEP';
                  } else if (value == 9) {
                    return 'OCT';
                  } else if (value == 10) {
                    return 'NOV';
                  } else if (value == 11) {
                    return 'DEC';
                  } else {
                    return '';
                  }
                },
              )),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 1),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12])),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 2),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 3),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 4),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 4, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 5),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 5, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 6),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 6, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 7),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 7, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 8),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 8, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 9),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 9, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 10),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 10, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 11),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
            BarChartGroupData(x: 11, barRods: [
              BarChartRodData(
                  y: getTicketsByMonth(tickets, 12),
                  colors: [Colors.white],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  width: Responsive.isDesktop(context) ? 30 : 10,
                  backDrawRodData: BackgroundBarChartRodData(
                      y: mostRegisteredMonth,
                      show: true,
                      colors: [Colors.white12]))
            ]),
          ]),
      swapAnimationDuration: Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }
}

double getTicketsByMonth(List<Ticket> tickets, int month) {
  return tickets
      .where((ticket) => DateTime.parse(ticket.startDate).month == month)
      .length
      .toDouble();
}

/// returns {double} the number of tickets of the most registered month
/// adds + 5 to always have a higher y value inside the bar itself
/// BOTH METHODS WORK, ONE IS IMPLEMENTED BY AND THE OTHER USES .MATH PACKAGE*/
double getMostRegisteredTicketMonth(List<Ticket> tickets) {
  //int newMax = 0;
  //int oldMax = 0;
  List<int> listOfTicketsPerMonth = [];
  for (var month = 1; month <= 12; month++) {
    listOfTicketsPerMonth.add(tickets
        .where((ticket) => DateTime.parse(ticket.startDate).month == month)
        .length);
  }

  return listOfTicketsPerMonth.reduce(max).toDouble() + 5;
/*
  for (var month = 1; month <= 12; month++) {
    newMax = tickets
        .where((ticket) => DateTime.parse(ticket.startDate).month == month)
        .length;
    //if(month == 1)  oldMax = newMax;
    if (oldMax > newMax) {
      continue;
    } else {
      oldMax = newMax;
    }
  }
  return oldMax.toDouble() + 5;*/

}
