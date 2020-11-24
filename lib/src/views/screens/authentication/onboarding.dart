import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/app_logics/models/onboarding_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/onboarding_box.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/page_indicator.dart';
import 'package:nuphonic_front_end/src/views/screens/authentication/sign_in.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {

  int currentIndex = 0;

  List<OnBoardingModel> _sliders = [
    OnBoardingModel(
        imagePath: "assets/logos/app_logo_mini.svg",
        title: "Welcome to",
        appName: "NUPHONIC",
        subTitle: "ANYTIME, ANYWHERE"),
    OnBoardingModel(
        imagePath: "assets/illustrations/music_environment.svg",
        title: "Listen any song",
        subTitle: "Find your favourite music and enjoy without paying"),
    OnBoardingModel(
        imagePath: "assets/illustrations/upload.svg",
        title: "Upload your song",
        subTitle: "Make your own music and upload without paying"),
    OnBoardingModel(
        imagePath: "assets/illustrations/support_bucket.svg",
        title: "Support any artist",
        subTitle: "Find your favourite artist and support them financially"),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: height - 125,
                  child: PageView.builder(
                    onPageChanged: (val) {
                      setState(() {
                        currentIndex = val;
                      });
                    },
                    itemCount: _sliders.length,
                    itemBuilder: (context, index) {
                      return OnBoardingBox(
                        imagePath: _sliders[index].imagePath,
                        title: _sliders[index].title,
                        appName: _sliders[index].appName,
                        subTitle: _sliders[index].subTitle,
                      );
                    },
                  ),
                ),
                Container(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < _sliders.length; i++)
                        currentIndex == i
                            ? PageIndicator(
                                isCurrentPage: true,
                              )
                            : PageIndicator(
                                isCurrentPage: false,
                              ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SignIn(),
            )
          ],
        ),
      ),
    );
  }
}
