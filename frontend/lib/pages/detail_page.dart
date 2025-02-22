import 'package:colornestle/misc/colors.dart';
import 'package:colornestle/widgets/app_large_text.dart';
import 'package:colornestle/widgets/app_text.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int gottenStars=3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 350,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/image1.png"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 50,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 320,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child:  Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLargeText(text: "Yosemite", color:Colors.black ),
                          AppLargeText(text: "\$ 250", color: AppColors.mainColor,),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      const Row(
                        children: [
                          Icon(Icons.location_on, color:AppColors.mainColor),
                          SizedBox(width: 5),
                          AppText(text: "USA, Califonia", color:AppColors.textColor1),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Wrap(
                            children: List.generate(5, (index){
                              return  Icon(Icons.star, color:index<gottenStars?AppColors.starColor:AppColors.textColor2);
                            }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const AppText(text: "(4.0)", color:AppColors.textColor2)
                        ],
                      ),
                      const SizedBox(
                            height: 25,
                          ),
                          AppLargeText(text: "People", color:Colors.black.withOpacity(0.8)),
                          const SizedBox(
                            height: 10,
                          ),
                          const AppText(text: "Number of People in your group", color:AppColors.mainTextColor),
                        
                    ],
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
