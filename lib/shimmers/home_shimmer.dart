import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/extracted_widgets/page_indicator.dart';
import 'package:nuphonic_front_end/shared/shared.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      child: shimmerBody(),
      baseColor: darkGreyColor,
      highlightColor: Color(0xff262626),
    );
  }

  Widget shimmerBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 180,
            decoration: circularBorder,
          ),
        ),
        Container(
          height: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 5; i++)
                PageIndicator(
                  isCurrentPage: true,
                )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 25,
            width: 100,
            decoration: circularBorder,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < 6; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 10,
                        width: 80,
                        decoration: circularBorder,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 10,
                        width: 35,
                        decoration: circularBorder,
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 25,
            width: 100,
            decoration: circularBorder,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Column(
          children: [
            for (int i = 0; i < 6; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: Container(
                  height: 95,
                  decoration: circularBorder,
                ),
              ),
          ],
        ),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
}
