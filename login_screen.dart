import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Log/Reg/Login/Main%20Field/field.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'S',
                      style: TextStyle(
                        color: Color.fromRGBO(66, 133, 244, 1),
                        fontSize: 70,
                      ),
                    ),
                    TextSpan(
                      text: 'e',
                      style: TextStyle(
                        color: Color.fromRGBO(219, 68, 55, 1),
                        fontSize: 70,
                      ),
                    ),
                    TextSpan(
                      text: 'a',
                      style: TextStyle(
                        color: Color.fromRGBO(244, 180, 0, 1),
                        fontSize: 70,
                      ),
                    ),
                    TextSpan(
                      text: 'r',
                      style: TextStyle(
                        color: Color.fromRGBO(66, 133, 244, 1),
                        fontSize: 70,
                      ),
                    ),
                    TextSpan(
                      text: 'c',
                      style: TextStyle(
                        color: Color.fromRGBO(15, 157, 88, 1),
                        fontSize: 70,
                      ),
                    ),
                    TextSpan(
                      text: 'h',
                      style: TextStyle(
                        color: Color.fromRGBO(219, 68, 55, 1),
                        fontSize: 70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: Duration(seconds: 3),
                      animatedTexts: [
                        TyperAnimatedText(
                          'at',
                          textStyle: TextStyle(fontSize: 30),
                          speed: Duration(milliseconds: 200),
                        ),
                        TyperAnimatedText(
                          'meets',
                          textStyle: TextStyle(fontSize: 30),
                          speed: Duration(milliseconds: 200),
                        ),
                        TyperAnimatedText(
                          'ideas',
                          textStyle: TextStyle(fontSize: 30),
                          speed: Duration(milliseconds: 200),
                        ),
                        TyperAnimatedText(
                          'friends',
                          textStyle: TextStyle(fontSize: 30),
                          speed: Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.search,
                    size: 35,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              padding: EdgeInsets.all(15),
              width: double.infinity,
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Field(),
          ],
        ),
      ),
    );
  }
}
