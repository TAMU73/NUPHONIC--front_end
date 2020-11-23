import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class OnBoardingBox extends StatelessWidget {
  final String imagePath;
  final String title;
  final String appName;
  final String subTitle;

  OnBoardingBox({this.imagePath, this.title, this.appName, this.subTitle});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: height - 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: SvgPicture.asset(imagePath),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: normalFontStyle.copyWith(
                          color: whitishColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3),
                    ),
                    appName != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 25),
                            child: Text(appName,
                                style: appNameFontStyle.copyWith(
                                    color: whitishColor, fontSize: 32)),
                          )
                        : SizedBox(height: 15),
                    Text(subTitle,
                        textAlign: TextAlign.center,
                        style: normalFontStyle.copyWith(
                            color: whitishColor.withOpacity(0.5),
                            fontSize: 18,
                            letterSpacing: 0.3))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
