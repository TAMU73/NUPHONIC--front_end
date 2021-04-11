import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/error_indicator.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/eye_indicator.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _newPassController = TextEditingController();
  AuthService _auth = AuthService();

  String oldPassword = "";
  String newPassword = "";

  bool isOn = true;
  bool isOnN = true;
  bool isLoading = false;

  //0 means error, 1 means success and null means default password
  int isErrorP;

  void _checkPassword(String val) {
    setState(() {
      isErrorP = val == ""
          ? null
          : val.length >= 8
              ? 1
              : 0;
      if (isErrorP == 1) newPassword = val;
    });
  }

  Future changePassword(String oldPassword, String newPassword) async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _auth.changePassword(oldPassword, newPassword);
    if (result == null) {
      CustomSnackBar().buildSnackBar("Network Error", false);
    } else {
      CustomSnackBar()
          .buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        _oldPassController.clear();
        _newPassController.clear();
        setState(() {
          isErrorP = null;
        });
      }
    }
    setState(() {
      isLoading = false;
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
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomAppBar(
                  label: 'Change Password',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  controller: _oldPassController,
                  labelName: 'Old Password',
                  hint: 'Old or current password',
                  obSecureText: isOnN,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (val) {
                    setState(() {
                      oldPassword = val;
                    });
                  },
                  icons: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() => isOnN = !isOnN);
                        },
                        child: EyeIndicator(isOn: isOnN),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: _newPassController,
                  labelName: 'New Password',
                  hint: '8+ character password',
                  obSecureText: isOn,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (val) {
                    _checkPassword(val);
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
                  height: 30,
                ),
                CustomButton(
                  labelName: 'CHANGE',
                  isLoading: isLoading,
                  onPressed: isErrorP == 1 && oldPassword != ""
                      ? () => changePassword(newPassword, oldPassword)
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
