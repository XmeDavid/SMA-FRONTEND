import 'package:flutter/material.dart';


class TicketState{

  static const String ALL = "All";
  static const String PENDING = "Pending";
  static const String ASSIGNED = "Assigned";
  static const String ON_GOING = "On going";
  static const String PENDING_CLIENT = "Pending Client";
  static const String VALIDATION = "Validation";
  static const String SOLVED = "Solved";

  String _state = TicketState.PENDING;


  TicketState(this._state);

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  static List<String> get values => [ALL, PENDING, ASSIGNED, ON_GOING, PENDING_CLIENT, VALIDATION, SOLVED];




}