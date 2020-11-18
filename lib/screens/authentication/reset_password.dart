import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/extracted_widgets/error_indicator.dart';
import 'package:nuphonic_front_end/extracted_widgets/eye_indicator.dart';
import 'package:nuphonic_front_end/extracted_widgets/warning.dart';
import 'file:///C:/Users/DELL/Desktop/FYP/NUPHONIC%20-%20front_end/lib/service/validation.dart';
import 'package:nuphonic_front_end/service/auth_service.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class ResetPassword extends StatefulWidget {

  final String email;

  ResetPassword({this.email});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  AuthService _auth = AuthService();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _resetPasswordController = TextEditingController();
  GlobalKey _toolTipKey = GlobalKey();

  String password;

  bool isLoading = false;

  bool isOn = true;
  bool isOnR = true; //for retype password

  //0 means error, 1 means success and null means default
  int isErrorR; //for retype password
  int isErrorP; //for password

  Validation validate = Validation();

  void _checkPassword(String val) {
    setState(() {
      isErrorP = val == ""
          ? null
          : val.length >= 8
          ? 1
          : 0;
      if(isErrorP==1) password = val;
    });
  }

  void _checkRetypePassword(String val) {
    setState(() {
      isErrorR = val == ""
          ? null
          : val == password
          ? 1
          : 0;
    });
  }

  Widget customSnackBar(bool success, String msg) {
    return SnackBar(
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
    );
  }

  showSnackBar(String msg, bool success) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
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
        )
    );
  }

  Future resetPassword(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _auth.resetPassword(email, password);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      showSnackBar("Network Error", false);
    } else {
      print(result.data['msg']);
      showSnackBar(result.data['msg'], result.data['success']);
      await new Future.delayed(const Duration(seconds : 1));
      _scaffoldKey.currentState.hideCurrentSnackBar();
      Navigator.pop(context);
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
                  label: 'Reset Password',
                  endChild: Warning(
                    toolTipKey: _toolTipKey,
                    text: "Going back is not recommended.\nPlease complete the process.",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  labelName: 'New Password',
                  hint: '8+ character password',
                  obsecureText: isOn,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (val) {
                    _checkPassword(val);
                    setState(() {
                      _resetPasswordController.clear();
                      isErrorR =null;
                    });
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
                  controller: _resetPasswordController,
                  labelName: 'Re-type Password',
                  hint: 'Re-type password as above',
                  obsecureText: isOnR,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (val) {
                    _checkRetypePassword(val);
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
                  labelName: 'RESET',
                  isLoading: isLoading,
                  onPressed: isErrorP == 1 && isErrorR == 1 ? () => resetPassword(widget.email, password) : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
