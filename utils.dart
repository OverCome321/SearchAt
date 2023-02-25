import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text, bool setColor) {
    if (text == null) return;
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );
    if (setColor == true) {
      final snackBar = SnackBar(
        content: Text(text),
        backgroundColor: Colors.green,
      );
      messengerKey.currentState!
        ..removeCurrentMaterialBanner()
        ..showSnackBar(snackBar);
    }
    if (setColor == false) {
      final snackBar = SnackBar(
        content: Text(text),
        backgroundColor: Colors.red,
      );
      messengerKey.currentState!
        ..removeCurrentMaterialBanner()
        ..showSnackBar(snackBar);
    }
  }
}
