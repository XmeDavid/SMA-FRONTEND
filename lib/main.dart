import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'consts.dart';

void main() {
  runApp(const SMA());
}

class SMA extends StatelessWidget {
  const SMA({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMA - Support Management Application',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: bgColor,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key,}) : super(key: key);

  @override
  State<LoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> {
  /**
   * Search later, something to do with the state
   * Might be usefull to define the user state after login idk
   *
  int _stateVariable = 0;
  void _loginFunction() {
    setState(() {
      _stateVariable++;
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: LoginContainer(),
        ),
      )
    );

  }
}

class LoginContainer extends StatelessWidget{
  const LoginContainer({Key? key,}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondColor3,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      height: 364,
      width: 512,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text("Login",style: Theme.of(context).textTheme.titleLarge,),
          ),
          const Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: InputField(hintText: "Username", isPassword: false,),
          ),
          const Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: InputField(hintText: "Password",isPassword: true,),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Center(
              widthFactor: 10,
              heightFactor: 1,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(secondColor3),
                  backgroundColor: MaterialStateProperty.all(firstColor),
                  fixedSize: MaterialStateProperty.all(Size(160,60)),
                ),
                child: Text("Login",style: Theme.of(context).textTheme.titleLarge,),
                onPressed: (){},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    Key? key, required this.hintText, required this.isPassword
  }) : super(key: key);

  final String hintText;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: black10p,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
