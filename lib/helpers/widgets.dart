import 'package:chat_app/helpers/colors.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'glassmorphism.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}

logotcodedialog(BuildContext context) {
  AuthService authService = AuthService();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          // backgroundColor: Color(0xFF1E1F38),
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          children: <Widget>[
            Glassorphism(
              blur: 5,
              opacity: 0.08,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.72,
                height: MediaQuery.of(context).size.height * 0.16,
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          height: MediaQuery.of(context).size.height * 0.029,
                          child: Text(
                            "Are You sure want logout",
                            style: TextStyle(
                              color: fontColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Divider(thickness: 2,color: Colors.black26,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.32,
                              height:
                                  MediaQuery.of(context).size.height * 0.049,
                              // color: Colors.redAccent,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: alertGradient,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  await authService.signOut();

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ));

                                  // Navigator.of(context).pop();
                                },
                                child: Text(
                                  "ok",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                /*  child: Text(
                                      'OK',
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          color: white,
                                          fontSize: fontSize * .9,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),*/
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.32,
                              height:
                                  MediaQuery.of(context).size.height * 0.049,
                              // color: Colors.redAccent,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: cancelGradient,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).pop();
                                },
                                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                                child: Text("Cancel",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      });
}
