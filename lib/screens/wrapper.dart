import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/screens/authentication/onboarding.dart';
import 'package:nuphonic_front_end/screens/home/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  String user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  Future<void> checkUser () async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final value = prefs.getString(key) ?? null;
    setState(() {
      user = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(user==null) {
      return Onboarding();
    } else {
      return BottomNavigation();
    }
  }
}
