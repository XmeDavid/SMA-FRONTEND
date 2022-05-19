import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/api_interactions/api_functions.dart';
import 'package:sma_frontend/consts.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;

  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  final passwordConfirmation = TextEditingController();

  bool authenticated = false;

  @override
  void dispose(){
    emailText.dispose();
    passwordText.dispose();
    super.dispose();
  }

  reset() async{
    dynamic res = await ClientApi.login(emailText.text, passwordText.text);
    if(res.statusCode == 200){
      dynamic json = jsonDecode(res.body);
      GetStorage box = GetStorage();
      box.write('token', json['access_token']);
      box.write('refresh_token', json['refresh_token']);
      Navigator.pushNamed(context, '/');
    }else{
      
    }
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
                'Reset Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailText,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon  : const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordConfirmation,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Confirm your password',
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
                          reset();
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