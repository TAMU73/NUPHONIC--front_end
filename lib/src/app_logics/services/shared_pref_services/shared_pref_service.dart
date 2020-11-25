import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  Future<void> save({String id, String data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = id;
    String value = data;
    prefs.setString(key, value);
  }

  Future<String> read({String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = id;
    String value = prefs.getString(key);
    return value;
  }
}
