import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                Text(
                  'Full Name:',
                  style: texFieldLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: "Your full name",
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Username:',
                  style: texFieldLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: "Unique username",
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Email:',
                  style: texFieldLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: "example@example.com",
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Password:',
                  style: texFieldLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: "6+ character password",
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Re-type Password:',
                  style: texFieldLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: "Re-type password as above",
                ),
                SizedBox(
                  height: 40,
                ),
                CustomButton(
                  onPressed: () {},
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
