import 'package:colornestle/misc/colors.dart';
import 'package:colornestle/widgets/app_large_text.dart';
import 'package:flutter/material.dart';
import '../widgets/app_text.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<Map<String, String>> pages = [
    {
      "image": "welcome-one.png",
      "maintext": "Trips",
      "subtext": "This is a trip",
      "description": "Trip is the main hobby of my life"
    },
    {
      "image": "welcome-two.png",
      "maintext": "Car",
      "subtext": "This is a car",
      "description": "Driving a car gives a sense of freedom"
    },
    {
      "image": "welcome-three.png",
      "maintext": "Cat",
      "subtext": "This is a cat",
      "description": "Cats are wonderful companions"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: pages.length,
        itemBuilder: (_, index) {
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/${pages[index]['image']}"),
                  fit: BoxFit.cover),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 150, right: 20, left: 20),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLargeText(text: pages[index]['maintext']!),
                      AppText(
                        text: pages[index]['subtext']!,
                        size: 30,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 250,
                        child: AppText(
                          text: pages[index]['description']!,
                          color: AppColors.textColor2,
                          size: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //  ResponsiveButton(
                      //   image: Image.asset('assets/icon/home.png'),
                      //   width: 120,
                      // ),
                    ],
                  ),
                  Column(
                    children: List.generate(3, (indexDots){
                      return Container(
                        margin:const EdgeInsets.only(bottom: 2),
                        width: 8,
                        height: index==indexDots?25:8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:index==indexDots?AppColors.mainColor:AppColors.mainColor.withOpacity(0.3)
                        ),

                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
