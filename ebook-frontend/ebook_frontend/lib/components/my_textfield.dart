import 'package:flutter/material.dart';

import '../constants/colorconstants.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),

            fillColor: fillColor,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: hintTextColor)),


      ),
    );
  }
}
