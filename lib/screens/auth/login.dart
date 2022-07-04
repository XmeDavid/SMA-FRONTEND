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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;

  final emailText = TextEditingController();
  final passwordText = TextEditingController();

  bool authenticated = false;

  @override
  void dispose(){
    emailText.dispose();
    passwordText.dispose();
    super.dispose();
  }

  login() async{
    Auth auth = await Auth.login(emailText.text, passwordText.text);
    GetStorage().write('token', auth.accessToken);
    GetStorage().write('refreshToken', auth.refreshToken);
    if(auth.needsMfa ?? false){
      Get.toNamed('/auth/mfa');
    }else{
      User user = await Auth.user();
      GetStorage().write('user_id', user.id);
      GetStorage().write('user_full_name', user.fullName());
      GetStorage().write('user_first_name', user.firstName);
      GetStorage().write('user_photo_path', user.imagePath ?? '');
      Get.toNamed('/');
    }
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
                'Sign in',
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
                      height: 10,
                    ),
                    Row(
                      children: [
                        TextButton(onPressed: (){
                          Get.toNamed("/password/recovery");
                        }, child: const Text("Forgot your password?",style: TextStyle(color: Colors.blue),)),
                        const Spacer()
                      ],
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

                    CheckboxListTile(
                      title: const Text("Remember me"),
                      contentPadding: EdgeInsets.zero,
                      value: rememberValue,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (newValue) {
                        setState(() {
                          rememberValue = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      ),
                      child: const Text(
                        'Sign in',
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