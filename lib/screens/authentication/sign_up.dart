import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/extracted_widgets/error_indicator.dart';
import 'package:nuphonic_front_end/extracted_widgets/eye_indicator.dart';
import 'package:nuphonic_front_end/service/auth_service.dart';
import 'package:nuphonic_front_end/service/validation.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  AuthService _auth = AuthService();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _resetPasswordController = TextEditingController();
  Validation validate = Validation();

  String fullName = "";
  String username = "";
  String email;
  String password;
  String retypePassword;

  bool isOn = true;
  bool isOnR = true; //for retype password

  bool isLoading = false;

  //0 means error, 1 means success and null means default
  int isErrorE; //for email
  int isErrorP; //for password
  int isErrorR; //for retype password

  void checkEmail(String val) {
    bool emailC = validate.isEmail(val);
    setState(() {
      isErrorE = val == ""
          ? null
          : emailC
              ? 1
              : 0;
      if (isErrorE == 1) email = val;
    });
  }

  void checkPassword(String val) {
    setState(() {
      isErrorP = val == ""
          ? null
          : val.length >= 8
              ? 1
              : 0;
      if (isErrorP == 1) password = val;
    });
  }

  void checkRetypePassword(String val) {
    setState(() {
      isErrorR = val == ""
          ? null
          : val == password
              ? 1
              : 0;
      if (isErrorR == 1) retypePassword = val;
    });
  }

  Future<void> signUp(
      String fullName, String username, String email, String password, String retypePassword) async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _auth.signUp(fullName, username, email, password, retypePassword);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      await CustomSnackBar().buildSnackBar("Network Error!!", false);
    } else {
      print(result.data['msg']);
      await CustomSnackBar().buildSnackBar(result.data['msg'], result.data['success']);
      if(result.data['success']) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    Get.back();
                  },
                  label: 'Create an Account',
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'Full Name',
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
                  labelName: 'Username',
                  hint: "Unique username",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onChanged: (val) {
                    setState(() {
                      username = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'Email',
                  hint: "example@example.com",
                  icons: ErrorIndicator(isError: isErrorE),
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
                  labelName: 'Password',
                  hint: "8+ character password",
                  obSecureText: isOn,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (val) {
                    checkPassword(val);
                    setState(() {
                      _resetPasswordController.clear();
                      isErrorR =null;
                    });
                  },
                  icons: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => isOn = !isOn);
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
                  controller: _resetPasswordController,
                  labelName: 'Re-type Password',
                  hint: "Re-type password as above",
                  obSecureText: isOnR,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (val) {
                    checkRetypePassword(val);
                  },
                  icons: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => isOnR = !isOnR);
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
                  height: 40,
                ),
                CustomButton(
                  labelName: 'SIGN UP',
                  isLoading: isLoading,
                  onPressed: fullName != "" &&
                          username != "" &&
                          isErrorP == 1 &&
                          isErrorE == 1 &&
                          isErrorR == 1
                      ? () => signUp(fullName, username, email, password, retypePassword)
                      : null,
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
