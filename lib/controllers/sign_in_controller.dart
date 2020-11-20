import 'package:get/get.dart';
import 'package:nuphonic_front_end/service/auth_service.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInController extends GetxController {
  AuthService _auth = AuthService();

  var isLoading = false.obs;

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    var result = await _auth.signIn(email, password);
    if (result == null) {
      CustomSnackBar().buildSnackBar(false, "Network Error");
      isLoading.value = false;
    } else {
      //saving user id
      isLoading.value = false;
      CustomSnackBar().buildSnackBar(result.data['success'], result.data['msg']);
      if (result.data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final result1 = await _auth.getUserInfo(result.data['id']);
        final key1 = 'first_name';
        final value1 = result1.data['user']['full_name'].split(" ")[0];
        prefs.setString(key1, value1);
        final key = 'user_id';
        final value = result.data['id'];
        prefs.setString(key, value);
        //saving user first name
      }
    }
  }
}
