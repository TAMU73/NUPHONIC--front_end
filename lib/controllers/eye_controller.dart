import 'package:get/get.dart';

class EyeController extends GetxController {
  var isOn = true.obs;

  void toggle() {
    isOn.toggle();
  }
}