import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/screens/authentication/onboarding.dart';
import 'package:nuphonic_front_end/screens/home/bottom_navigation.dart';
import 'package:nuphonic_front_end/service/shared_preference_service.dart';

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

  Future<void> checkUser() async {
    String value = await SharedPreferenceService().read(id: 'user_id');
    setState(() {
      user = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return user == null ? OnBoarding() : BottomNavigation();
  }
}
