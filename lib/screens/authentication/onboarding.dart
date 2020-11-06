import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/extracted_widgets/onboarding_box.dart';
import 'package:nuphonic_front_end/extracted_widgets/page_indicator.dart';
import 'package:nuphonic_front_end/models/onboarding_model.dart';
import 'package:nuphonic_front_end/screens/authentication/sign_in.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;

  List<OnboardingModel> sliders = [
    OnboardingModel(
        imagePath: "assets/logos/app_logo_mini.svg",
        title: "Welcome to",
        appName: "NUPHONIC",
        subTitle: "ANYTIME, ANYWHERE"),
    OnboardingModel(
        imagePath: "assets/illustrations/music_environment.svg",
        title: "Listen any music",
        subTitle: "Find your favourite music and enjoy without paying"),
    OnboardingModel(
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
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: height - 145,
                  child: PageView.builder(
                    onPageChanged: (val) {
                      setState(() {
                        currentIndex = val;
                      });
                    },
                    itemCount: sliders.length,
                    itemBuilder: (context, index) {
                      return OnboardingBox(
                        imagePath: sliders[index].imagePath,
                        title: sliders[index].title,
                        appName: sliders[index].appName,
                        subTitle: sliders[index].subTitle,
                      );
                    },
                  ),
                ),
                Container(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < sliders.length; i++)
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
