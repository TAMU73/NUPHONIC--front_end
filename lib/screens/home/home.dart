import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/main.dart';
import 'package:nuphonic_front_end/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isLoading = false;

  signOut() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic key = 'user_id';
    dynamic value;
    prefs.setString(key, value);
    await new Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: CustomButton(
          labelName: 'SIGN OUT',
          isLoading: isLoading,
          onPressed: signOut,
        ),
      ),
    );
  }
}
