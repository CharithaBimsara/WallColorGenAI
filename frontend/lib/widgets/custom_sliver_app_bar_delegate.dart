import 'package:flutter/material.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  CustomSliverAppBarDelegate({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double percentage = shrinkOffset / expandedHeight;
    final double fontSizeTitle = 30 - (25 - 18) * percentage;
    final double fontSizeSubtitle = 20 - (20 - 14) * percentage;

 

    return Stack(
      fit: StackFit.expand,
    
        children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 234, 233, 233),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(
                MediaQuery.of(context).size.width,
                expandedHeight * 0.3 * (1 - percentage),
              ),
            ),
          ),
        ),

        Container(
          
          child: Column(
            children: [
              Text(
                'Capture a room',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Lato',
                  fontSize: fontSizeTitle,
                ),
              ),
              Text(
                'to redecorate',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Lato',
                  fontSize: fontSizeSubtitle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight+20;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}