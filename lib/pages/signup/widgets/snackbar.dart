import 'package:flutter/material.dart';

class CustomSnackbar
{

  static showCustomSnackbar(BuildContext context,String text) {
     final snackdemo = SnackBar(
      content: Text(text),

    );
    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
  }
}