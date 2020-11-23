import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class CustomSnackBar {
  Future<void> buildSnackBar(String message, bool success) async {
    Get.rawSnackbar(
      backgroundColor: success ? greenishColor : reddishColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      borderRadius: 10,
      duration: Duration(seconds: success ? 1 : 2),
      animationDuration: Duration(milliseconds: 400),
      messageText: Text(
        message,
        style: normalFontStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    if (success) await Future.delayed(Duration(milliseconds: 1200));
  }
}
