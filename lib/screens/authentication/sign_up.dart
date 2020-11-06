import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/screens/authentication/validation/validation.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String fullName = "";
  String username = "";
  String email;
  String password;

  bool isOn = true;
  bool isOnR = true; //for retype password

  //0 means error, 1 means success and null means default
  int isErrorE; //for email
  int isErrorP; //for password
  int isErrorR; //for retype password

  Widget eyeIndicator(bool isOn) {
    String icon = isOn ? 'eye_off_icon.svg' : 'eye_on_icon.svg';
    return SvgPicture.asset('assets/icons/$icon');
  }

  Widget errorIndicator(int isError) {
    Color iconColor = isError == null
        ? Color(0xff656565)
        : isError == 1
        ? greenishColor
        : reddishColor;
    return SvgPicture.asset(
      'assets/icons/check_icon.svg',
      color: iconColor,
    );
  }

  Validation validate = Validation();

  checkEmail(String val) {
    bool emailC = validate.isEmail(val);
    setState(() {
      isErrorE = val == ""
          ? null
          : emailC
          ? 1
          : 0;
      if(isErrorE==1) email = val;
    });
  }

  checkPassword(String val) {
    setState(() {
      isErrorP = val == ""
          ? null
          : val.length >= 8
          ? 1
          : 0;
      if(isErrorP==1) password = val;
    });
  }

  checkRetypePassword(String val) {
    setState(() {
      isErrorR = val == ""
          ? null
          : val == password
          ? 1
          : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomAppBar(
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Navigator.pop(context);
                  },
                  label: 'Create an Account',
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'Full Name:',
                  hint: "Your full name",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'Username:',
                  hint: "Unique username",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onChanged: (val) {
                    username = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'Email:',
                  hint: "example@example.com",
                  icons: errorIndicator(isErrorE),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (val) {
                    checkEmail(val);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'Password:',
                  hint: "8+ character password",
                  obsecureText: isOn,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onChanged: (val) {
                    checkPassword(val);
                  },
                  icons: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(()=>isOn=!isOn);
                        },
                        child: eyeIndicator(isOn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      errorIndicator(isErrorP),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'Re-type Password:',
                  hint: "Re-type password as above",
                  obsecureText: isOnR,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (val) {
                    checkRetypePassword(val);
                  },
                  icons: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(()=>isOnR=!isOnR);
                        },
                        child: eyeIndicator(isOnR),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      errorIndicator(isErrorR),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                CustomButton(
                  onPressed: () {
                    if(fullName != "" && username != "" && isErrorP == 1 && isErrorE == 1 && isErrorR == 1) {
                      print('success');
                    }
                  },
                  labelName: 'SIGN UP',
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
