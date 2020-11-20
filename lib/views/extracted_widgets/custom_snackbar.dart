import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/utils/shared.dart';

class CustomSnackBar {
  void buildSnackBar(bool success, String message) {
    Get.rawSnackbar(
        backgroundColor: success ? greenishColor : reddishColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        borderRadius: 15,
        duration: Duration(seconds: 2),
        animationDuration: Duration(milliseconds: 400),
        messageText: Text(
          message,
          style: normalFontStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ));
  }
}
