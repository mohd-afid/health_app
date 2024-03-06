import 'package:chat_app/helpers/colors.dart';
import 'package:chat_app/screens/register_page.dart';

import 'package:chat_app/helpers/auth_service.dart';
import 'package:chat_app/helpers/database_service.dart';
import 'package:chat_app/helpers/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoding = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: _isLoding
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 200),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .6,
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
                        // Place your image widget here
                        SizedBox(
                          height: 150,
                          child: Image.asset('assets/loginimage.png'),
                        ),
                        SizedBox(height: 20),

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
                                login(context);
                              },
                              //  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              //  shape: const StadiumBorder(),
                              child: Text(
                                "SIGN IN",
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
                            text: "Don't have an account?",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: " Sign Up",
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, RegistrPage());
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

  login(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoding = true;
      });
      bool isSussess = await authService.signIn(email, password);
      if (isSussess) {
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email);

        prefs.setString("email", email);

        nextScreenReplace(context, HomeScreen());
      } else {
        showSnackbar(context, Colors.red, "Login Failed");
        setState(() {
          _isLoding = false;
        });
      }
    }
  }
}
