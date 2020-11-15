import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/main.dart';
import 'package:nuphonic_front_end/service/auth_service.dart';
import 'package:nuphonic_front_end/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AuthService _auth = AuthService();

  bool isLoading = false;
  bool homeLoading = true;

  String name;
  String greeting;

  showSnackBar(String msg, bool success) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(20),
      elevation: 0,
      duration: Duration(seconds: 3),
      backgroundColor: success ? greenishColor : reddishColor,
      content: Text(
        msg,
        style: normalFontStyle.copyWith(
            fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.3),
      ),
    ));
  }

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

  _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_id';
    final value = prefs.getString(key);
    dynamic result = await _auth.getUserInfo(value);
    if(result==null) {
      showSnackBar("Network Error", false);
    } else {
      setState(() {
        name = result.data['user']['full_name'].split(" ")[0];
        homeLoading = false;
      });
    }
  }

  _getGreeting() {
    int hour = DateTime.now().hour;
    String _greeting = hour < 12 ? "Morning" : hour < 17 ? "Afternoon" : "Evening";
    setState(() {
      greeting = _greeting;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
    _getGreeting();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: homeLoading ? Center(child: loading) : SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomAppBar(
                  label: 'Good $greeting\n$name,',
                  endChild: SvgPicture.asset('assets/logos/app_logo_mini.svg', height: 40,),
                ),
                SizedBox(height: 100,),
                CustomButton(
                  labelName: 'SIGN OUT',
                  isLoading: isLoading,
                  onPressed: signOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
