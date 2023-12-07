import 'package:ebook_frontend/constants/colorconstants.dart';
import 'package:ebook_frontend/constants/defaults.dart';
import 'package:flutter/material.dart';


class CategoryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? color;

  CategoryButton({required this.title, required this.onPressed,this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
      style: ElevatedButton.styleFrom(
        textStyle: defaultfont(textStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.bold)),
        backgroundColor: color?? Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        side: BorderSide(color: primaryColor, width: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}