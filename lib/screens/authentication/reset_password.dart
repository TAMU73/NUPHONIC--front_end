import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
                Text(
                  'New Password:',
                  style: texFieldLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: '6+ character password',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Re-type password:',
                  style: texFieldLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: 'Re-type password as above',
                ),
                SizedBox(
                  height: 30,
                ),
                CustomButton(
                  onPressed: () {},
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
