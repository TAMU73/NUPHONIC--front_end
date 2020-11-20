import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/controllers/wrapper_controller.dart';
import 'package:nuphonic_front_end/views/authentication/onboarding.dart';
import 'package:nuphonic_front_end/views/home/bottom_navigation.dart';

class Wrapper extends StatelessWidget {

  final userController = Get.put(WrapperController());

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      userController.checkUser();
      return userController.userID.value.userID == null ? OnBoarding() : BottomNavigation();
    });
  }
}
