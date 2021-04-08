import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/screens/authentication/onboarding.dart';
import 'package:nuphonic_front_end/src/views/screens/home/bottom_navigation.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:get/get.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  SharedPrefService _sharedPrefService = SharedPrefService();

  String user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    String value = await _sharedPrefService.read(id: 'user_id');
    setState(() {
      user = value;
    });
  }

  Future<bool> willPop() async {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: darkGreyColor,
          title: Text(
            'Do you want to exit the app?',
            style: titleTextStyle,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: normalFontStyle,
              ),
              onPressed: () {
                Get.back(
                  result: false,
                );
              },
            ),
            RaisedButton(
              color: reddishColor,
              child: Text(
                'Exit',
                style: normalFontStyle,
              ),
              onPressed: () {
                Get.back(
                  result: true,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: user == null ? OnBoarding() : BottomNavigation(),
    );
  }
}
