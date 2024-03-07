import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/helpers/auth_service.dart';
import 'package:chat_app/helpers/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/colors.dart';
import 'home_screen.dart';

class RegistrPage extends StatefulWidget {
  const RegistrPage({super.key});

  @override
  State<RegistrPage> createState() => _RegistrPageState();
}

class _RegistrPageState extends State<RegistrPage> {
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullname = "";
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 180),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .7,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                          child: Image.asset('assets/loginimage.png'),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: iconColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none, // Remove border side
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              fullname = val;
                            });
                          },
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty";
                            }
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: iconColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none, // Remove border side
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          validator: (val) {
                            return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: iconColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none, // Remove border side
                            ),
                          ),
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 46,
                            decoration: ShapeDecoration(
                              shape: StadiumBorder(),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: ButtonGradient,
                              ),
                              shadows: [
                                BoxShadow(
                                  color: ButtonGradient[1].withOpacity(0.15),
                                  blurRadius: 25,
                                  spreadRadius: 10,
                                )
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                register();
                              },
                              child: Text(
                                "SIGN UP",
                                style: TextStyle(
                                  color: fontColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Login now",
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, LoginPage());
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      bool isSussess = await authService.signUp(
        email,
        password,
      );
      if (isSussess) {
        prefs.setString("email", email);
        nextScreenReplace(context, HomeScreen());
      } else {
        showSnackbar(context, Colors.red, "Registration Failed");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
