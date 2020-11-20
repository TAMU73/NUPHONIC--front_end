import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/controllers/onboarding_controller.dart';
import 'package:nuphonic_front_end/utils/shared.dart';
import 'package:nuphonic_front_end/views/authentication/sign_in.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/onboarding_box.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/page_indicator.dart';

class OnBoarding extends StatelessWidget {

  final onBoardingController = Get.put(OnBoardingController());

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
                SizedBox(height: 15,),
                Obx((){
                  return Container(
                    height: height - 125,
                    child: PageView.builder(
                      onPageChanged: (val) {
                        onBoardingController.currentIndex.value = val;
                      },
                      itemCount: onBoardingController.length,
                      itemBuilder: (context, index) {
                        return OnBoardingBox(
                          imagePath: onBoardingController.sliders[index].imagePath,
                          title: onBoardingController.sliders[index].title,
                          appName: onBoardingController.sliders[index].appName,
                          subTitle: onBoardingController.sliders[index].subTitle,
                        );
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Container(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < onBoardingController.length; i++)
                          onBoardingController.currentIndex.value == i
                              ? PageIndicator(
                            isCurrentPage: true,
                          )
                              : PageIndicator(
                            isCurrentPage: false,
                          ),
                      ],
                    ),
                  );
                }),
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
