import 'dart:convert';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/api_interactions/api_functions.dart';
import 'package:sma_frontend/consts.dart';

import '../../models/Auth.dart';
import '../../models/User.dart';

class MfaScreen extends StatefulWidget {
  const MfaScreen({Key? key}) : super(key: key);

  @override
  State<MfaScreen> createState() => _MfaScreenState();
}

class _MfaScreenState extends State<MfaScreen> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;

  final mfaController = TextEditingController();

  bool authenticated = false;

  @override
  void dispose(){
    mfaController.dispose();
    super.dispose();
  }

  mfa() async{
    print('object');
    Auth auth = await Auth.mfa(mfaController.text, GetStorage().read('refreshToken'));
    GetStorage().write('token', auth.accessToken);
    GetStorage().write('refreshToken', auth.refreshToken);
    User user = await Auth.user();
    GetStorage().write('user_id', user.id);
    GetStorage().write('user_full_name', user.fullName());
    GetStorage().write('user_first_name', user.firstName);
    GetStorage().write('user_photo_path', user.imagePath ?? '');
    GetStorage().write('user_entity_id', user.entityId);
    Get.toNamed('/dashboard');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child:Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
              color: secondColor3,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          height: 500,
          width: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'MFA Confirmation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: mfaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid mfa code';
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Enter your mfa confirmation code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          mfa();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}