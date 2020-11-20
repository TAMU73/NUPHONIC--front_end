import 'package:get/get.dart';
import 'package:nuphonic_front_end/service/auth_service.dart';
import 'package:nuphonic_front_end/views/authentication/confirm_code.dart';
import 'package:nuphonic_front_end/views/authentication/reset_password.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_snackbar.dart';

class ForgotPasswordController extends GetxController {

  var isLinearLoading = false.obs;
  var isConfirmLoading = false.obs;
  var codeValue = "".obs;
  String get code => codeValue.value;

  AuthService _auth = AuthService();

  Future<void> forgotPassword(String email) async {
    isLinearLoading.value = true;
    dynamic result = await _auth.forgotPassword(email);
    isLinearLoading. value = false;
    if (result == null) {
      CustomSnackBar().buildSnackBar(false, "Network Error!!");
    } else {
      CustomSnackBar().buildSnackBar( result.data['success'], result.data['msg']);
      if (result.data['success']) {
        Get.to(ConfirmCode(email: email,));
      }
    }
  }

  Future<void> confirmCode(String email, String code) async {
    isConfirmLoading.value = true;
    var result = await _auth.confirmCode(email, code);
    isConfirmLoading.value = false;
    if (result == null) {
      CustomSnackBar().buildSnackBar(false, "Network Error!!");
    } else {
      print(result.data['msg']);
      CustomSnackBar().buildSnackBar( result.data['success'], result.data['msg']);
      if (result.data['success']) {
        Get.off(ResetPassword(email: email,));
      }
    }
  }

}