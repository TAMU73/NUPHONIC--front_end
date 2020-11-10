import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/screens/authentication/reset_password.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class ConfirmCode extends StatefulWidget {
  @override
  _ConfirmCodeState createState() => _ConfirmCodeState();
}

class _ConfirmCodeState extends State<ConfirmCode> {
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
                  label: 'Confirm Code',
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child:
                      SvgPicture.asset('assets/illustrations/confirm_code.svg'),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'Code has been sent to your email \n example@example.com',
                    textAlign: TextAlign.center,
                    style: normalFontStyle.copyWith(
                      color: whitishColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Text(
                  'Enter your code here',
                  style: texFieldLabelStyle,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  hint: 'Code here...',
                ),
                SizedBox(
                  height: 40,
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ResetPassword()
                    ));
                  },
                  labelName: 'CONFIRM',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
