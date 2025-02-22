import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final VoidCallback onTap;

  const CustomButton({super.key, 
    required this.text,
    required this.height,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.redAccent,
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 2, color: Colors.black),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          height: height,
          width: width,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: "Lato",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
