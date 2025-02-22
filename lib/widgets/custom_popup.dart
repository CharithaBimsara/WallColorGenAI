import 'package:flutter/material.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final String content;
  final String buttonOneText;
  final String buttonTwoText;
  final VoidCallback onButtonOnePressed;
  final VoidCallback onButtonTwoPressed;

  const CustomPopup({super.key, 
    required this.title,
    required this.content,
    required this.buttonOneText,
    required this.buttonTwoText,
    required this.onButtonOnePressed,
    required this.onButtonTwoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onButtonOnePressed,
          child: Text(buttonOneText),
        ),
        TextButton(
          onPressed: onButtonTwoPressed,
          child: Text(buttonTwoText),
        ),
      ],
    );
  }
}
