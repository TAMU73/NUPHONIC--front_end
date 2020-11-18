import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/main.dart';
import 'package:nuphonic_front_end/screens/home/network_error.dart';
import 'package:nuphonic_front_end/service/auth_service.dart';
import 'package:nuphonic_front_end/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthService _auth = AuthService();

  bool isLoading = false;
  bool homeLoading = true;
  bool networkError = false;

  String name;
  String greeting;

  Future<void> _signOut() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //setting user id to null after sign out
    dynamic key = 'user_id';
    dynamic value;
    prefs.setString(key, value);
    //setting user's first name to null after sign out
    dynamic key1 = 'first_name';
    dynamic value1;
    prefs.setString(key1, value1);
    await new Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic key = 'user_id';
    dynamic value = prefs.getString(key);
    dynamic result = await _auth.getUserInfo(value);
    if (result == null) {
      setState(() {
        networkError = true;
        homeLoading = false;
      });
    } else {
      dynamic key = 'first_name';
      dynamic value = result.data['user']['full_name'].split(" ")[0];
      prefs.setString(key, value);
      setState(() {
        name = value;
        homeLoading = false;
      });
    }
  }

  Future<void> _getGreeting() async {
    int hour = DateTime.now().hour;
    String _greeting = hour < 12
        ? "Morning"
        : hour < 17
            ? "Afternoon"
            : "Evening";
    setState(() {
      greeting = _greeting;
    });
  }

  Future<void> _savedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic key = 'first_name';
    dynamic firstName = prefs.getString(key);
    setState(() {
      name = firstName;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGreeting(); //checking greetings
    _savedData(); //checking saved user's first name
    _getUserInfo(); //updating users info
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      body: networkError ? NetworkError(): SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CustomAppBar(
                        label: 'Good $greeting',
                        labelTextStyle: titleTextStyle.copyWith(
                          fontSize: 24,
                        ),
                        secondLabel: '$name,',
                        secondLabelTextStyle: normalFontStyle.copyWith(
                          fontSize: 20,
                        ),
                        endChild: SvgPicture.asset(
                          'assets/logos/app_logo_mini.svg',
                          height: 33,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      homeLoading
                          ? Center(child: loading)
                          : CustomButton(
                        labelName: 'SIGN OUT',
                        isLoading: isLoading,
                        onPressed: _signOut,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
