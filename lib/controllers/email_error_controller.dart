import 'package:get/get.dart';

class EmailErrorController extends GetxController {

  var email = "".obs;
  String get emailValue => email.value;
  var isEmailError = 0.obs;

  bool isEmail(String email) {
    String compare =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(compare);
    return regExp.hasMatch(email);
  }

  checkEmail(String val) {
    bool emailC = isEmail(val);
    isEmailError.value = val == ""
        ? isEmailError.value = 0
        : emailC
            ? isEmailError.value = 2
            : isEmailError.value = 1;
    if (isEmailError.value == 2) email.value = val;
  }
}
