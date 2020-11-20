import 'package:get/get.dart';

class PasswordErrorController extends GetxController {

  var password = "".obs;
  String get passwordValue => password.value;
  var isPasswordError = 0.obs;

  void checkPassword(String val) {
    isPasswordError.value = val == ""
        ? isPasswordError.value = 0
        : val.length >= 8
        ? isPasswordError.value = 2
        : isPasswordError.value = 1;
    if (isPasswordError.value == 2) password.value = val;
  }

}