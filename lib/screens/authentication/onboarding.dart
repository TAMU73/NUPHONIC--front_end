import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuphonic_front_end/models/onboarding_model.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;

  List<OnboardingModel> sliders = [
    OnboardingModel(
        imagePath: "assets/logos/app_logo.svg",
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

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.linearToEaseOut,
        height: 5,
        width: isCurrentPage ? 30 : 9,
        decoration: BoxDecoration(
            color: isCurrentPage ? Colors.white : Colors.white70,
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 700,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < sliders.length; i++)
                currentIndex == i
                    ? pageIndexIndicator(true)
                    : pageIndexIndicator(false),
            ],
          )
        ],
      ),
    );
  }
}

class OnboardingBox extends StatelessWidget {
  final String imagePath;
  final String title;
  final String appName;
  final String subTitle;

  OnboardingBox({this.imagePath, this.title, this.appName, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SvgPicture.asset(imagePath),
          Text(
            title,
            style: GoogleFonts.khula(
                color: Color(0xffe4e4e4),
                textStyle:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 32)),
          ),
          appName != null
              ? Text(
                  appName,
                  style: GoogleFonts.wallpoet(
                      color: Color(0xffe4e4e4),
                      textStyle: TextStyle(fontSize: 32)),
                )
              : SizedBox(),
          Text(
            subTitle,
            style: GoogleFonts.khula(
                color: Color(0xffe4e4e4), textStyle: TextStyle(fontSize: 18)),
          )
        ],
      ),
    );
  }
}
