import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/controllers/forgot_password_controller.dart';
import 'package:nuphonic_front_end/service/auth_service.dart';
import 'package:nuphonic_front_end/utils/shared.dart';
import 'package:nuphonic_front_end/views/authentication/reset_password.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/warning.dart';

class ConfirmCode extends StatelessWidget {
  final String email;
  final GlobalKey _toolTipKey = GlobalKey();
  final forgotPasswordController = ForgotPasswordController();

  ConfirmCode({this.email});

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
                  label: 'Confirm Code',
                  endChild: Warning(
                    toolTipKey: _toolTipKey,
                    text:
                        "Going back is not recommended.\nPlease complete the process.",
                  ),
                ),
                SizedBox(
                  height: 30,
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
                    'Code has been sent to your email address \n $email',
                    textAlign: TextAlign.center,
                    style: normalFontStyle.copyWith(
                      color: whitishColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Enter your code here',
                  style: texFieldLabelStyle,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  hint: 'Code here...',
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    forgotPasswordController.codeValue.value = val;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Obx(() {
                  return CustomButton(
                    labelName: 'CONFIRM',
                    isLoading: forgotPasswordController.isConfirmLoading.value,
                    onPressed: forgotPasswordController.code == ""
                        ? null
                        : () => forgotPasswordController.confirmCode(
                            email,
                            forgotPasswordController.code),
                  );
                }),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
