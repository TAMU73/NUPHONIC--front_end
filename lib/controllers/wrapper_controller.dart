import 'package:get/get.dart';
import 'package:nuphonic_front_end/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WrapperController extends GetxController {

  var userID = User(userID: null).obs;

  Future<void> checkUser() async {
    dynamic prefs = await SharedPreferences.getInstance();
    dynamic key = 'user_id';
    dynamic value = prefs.getString(key) ?? null;
    userID.value = User(userID: value);
  }

}
