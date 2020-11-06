import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/extracted_widgets/error_indicator.dart';
import 'package:nuphonic_front_end/extracted_widgets/eye_indicator.dart';
import 'package:nuphonic_front_end/screens/authentication/validation/validation.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  String email;
  String password;

  bool isOn = true;
  bool isOnR = true; //for retype password

  //0 means error, 1 means success and null means default
  int isErrorR; //for retype password
  int isErrorP; //for password

  Validation validate = Validation();

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
                  label: 'Reset Password',
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'New Password:',
                  hint: '8+ character password',
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
                        child: EyeIndicator(isOn: isOn),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ErrorIndicator(isError: isErrorP),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'Re-type Password',
                  hint: 'Re-type password as above',
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
                        child: EyeIndicator(isOn: isOnR),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ErrorIndicator(isError: isErrorR),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                CustomButton(
                  onPressed: () {
                    if(isErrorP == 1 && isErrorR == 1) {
                      print('success');
                    }
                  },
                  labelName: 'RESET',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
