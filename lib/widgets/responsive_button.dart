import 'package:flutter/material.dart';
// Replace with your color file

class ResponsiveButton extends StatelessWidget {
  final bool? isResponsive;
  final double? width;
  final double? height;
  final String text;
  final Icon icon;
  final double textSize;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;

  const ResponsiveButton({
    super.key,
    this.isResponsive = false,
    this.width,
    this.height,
    required this.text,
    required this.icon,
    required this.textSize,
    required this.textColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
     
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.green, // Example color from your AppColors
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap, // Execute custom onTap callback
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: 20),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: textSize,
                    fontWeight: FontWeight.bold, // Example text style
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
