import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/textfield_box.dart';
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
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/icons/back_icon.svg'),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Create an Account',
                          style: normalFontStyle.copyWith(
                              color: whitishColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
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
                TextFieldBox(
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
                TextFieldBox(
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
                TextFieldBox(
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
                TextFieldBox(
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
                TextFieldBox(
                  hint: "Re-type password as above",
                ),
                SizedBox(
                  height: 30,
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
