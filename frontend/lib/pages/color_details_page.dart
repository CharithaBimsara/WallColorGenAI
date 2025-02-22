import 'package:flutter/material.dart';

class ColorDetailsPage extends StatefulWidget {
  const ColorDetailsPage({super.key});

  @override
  ColorDetailsPageState createState() => ColorDetailsPageState();
}

class ColorDetailsPageState extends State<ColorDetailsPage> {

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final color = args?['color'] as Color?;
    final colorHex = args?['colorHex'] as String?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(colorHex ?? ''),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 350,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    colorHex ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.favorite_border_rounded),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Colort Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Main color: ${colorHex ?? ''}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Spacer(),
            InkWell(
                splashColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
                onTap: (){}, // Directly call the method
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 51,
                    width: double.maxFinite,
                    child: const Center(
                      child: Text(
                        "View AR",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
               ],
        ),
      ),
    );
  }
}
