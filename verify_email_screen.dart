import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home/home_screen.dart';
import 'package:flutter_application_1/Util/utils.dart';
import 'package:flutter_application_1/Log/Reg/Login/Main%20Field/field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailCreateState createState() => _VerifyEmailCreateState();
}

class _VerifyEmailCreateState extends State<VerifyEmailScreen> {
  bool isEmaleVerified = false;
  bool canResendEmail = false;
  final currentUser = FirebaseAuth.instance.currentUser;
  Locale? localeLanguage;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmaleVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmaleVerified) {
      sendVerificatedEmail();
      timer = Timer.periodic(
        Duration(seconds: 1),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
    } catch (e) {
      Utils.showSnackBar(e.toString(), false);
    }
    setState(() {
      try {
        isEmaleVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      } catch (e) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Field()));
      }
    });
    if (isEmaleVerified) timer?.cancel();
  }

  Future sendVerificatedEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(
        () => canResendEmail = false,
      );
      await Future.delayed(Duration(seconds: 1));
      setState(
        () => canResendEmail = true,
      );
      Utils.showSnackBar(
          AppLocalizations.of(context)!.emailhasbeensentmessage, true);
    } catch (e) {
      Utils.showSnackBar(
          AppLocalizations.of(context)!.emailalreadysentmessage, false);
    }
  }

  @override
  Widget build(BuildContext context) => isEmaleVerified
      ? HomeScreen()
      : Scaffold(
          body: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 200),
            ),
            Center(
              child: Text(
                AppLocalizations.of(context)!.verificationemailhasbeensent,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onSurface: Colors.white,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: canResendEmail ? sendVerificatedEmail : null,
                  icon: Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.resentemail,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              child: TextButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: () {
                  timer?.cancel();
                  FirebaseAuth.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              ),
            ),
          ]),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 61, 210, 255),
            title: Text(AppLocalizations.of(context)!.verifyemail),
          ),
        );
}
