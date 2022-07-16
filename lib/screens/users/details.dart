import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Address.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/Country.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/TicketCategory.dart';


import '../../api_interactions/api_functions.dart';
import '../../models/Auth.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
import '../../models/User.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();


}

class _UserDetailsScreenState  extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isEditMode = false;
  bool loaded = false;
  late User user;



  void saveChanges() async{}

  void load() async {
    User _user;
    String? _id = Get.parameters['id'];
    if(_id == null){
      Get.toNamed('/users');
    }
    if(_id == 'me'){
      _user = await Auth.user();
    }else{
      _user = await User.get(int.parse(_id!) , true);
    }
    setState((){
      user = _user;
      loaded = true;
    });
  }

  @override
  void initState(){
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? AppBar(title: const Text ("Create Entity"), backgroundColor: bgColor) : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const SizedBox(
                width: 200,
                child: SideMenu(),
              ),
            Expanded(
              child: Center(
                child:Column(
                  children:[
                    Container(
                      color: secondColor3,
                      width: MediaQuery.of(context).size.width - 200,
                      height: 128,
                      child: Row(
                        children: [
                          const Icon(Icons.account_circle, size: 128),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8,),
                              if(loaded)Text(user.fullName(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              if(loaded)Text(user.email,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                              if(loaded)Text(user.phoneNumber ?? '',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                              if(loaded)Text(user.phoneNumber ?? '',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ],
                          ),
                          const Spacer()
                        ],
                      )
                    ),
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}