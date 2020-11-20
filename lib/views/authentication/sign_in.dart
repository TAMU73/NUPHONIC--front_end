import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/controllers/sign_in_controller.dart';
import 'package:nuphonic_front_end/controllers/email_error_controller.dart';
import 'package:nuphonic_front_end/controllers/eye_controller.dart';
import 'package:nuphonic_front_end/controllers/forgot_password_controller.dart';
import 'package:nuphonic_front_end/controllers/password_error_controller.dart';
import 'package:nuphonic_front_end/utils/shared.dart';
import 'package:nuphonic_front_end/views/authentication/sign_up.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/error_indicator.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/eye_indicator.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/sliding_panel_appBar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final signInController = SignInController();
  final eyeController = EyeController();
  final emailErrorController = EmailErrorController();
  final passwordErrorController = PasswordErrorController();
  final forgotPasswordController = Get.put(ForgotPasswordController());
  final _controller = PanelController();

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: _controller,
      backdropEnabled: true,
      color: darkGreyColor,
      minHeight: 83,
      maxHeight: 480,
      borderRadius: bottomPanelBorderRadius,
      collapsed: SlidingPanelAppBar(
        height: 83,
        text: 'SIGN IN TO CONTINUE',
        controller: _controller,
      ),
      panel: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlidingPanelAppBar(
              height: 83,
              text: 'SIGN IN WITH EMAIL',
              controller: _controller,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return CustomTextField(
                      labelName: 'Email',
                      hint: 'example@example.com',
                      icons: ErrorIndicator(
                          isError: emailErrorController.isEmailError.value),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onChanged: (val) {
                        emailErrorController.checkEmail(val);
                      },
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return CustomTextField(
                      labelName: 'Password',
                      obsecureText: eyeController.isOn.value,
                      hint: '8+ character password',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onChanged: (val) {
                        passwordErrorController.checkPassword(val);
                      },
                      icons: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              eyeController.toggle();
                            },
                            child: EyeIndicator(isOn: eyeController.isOn.value),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ErrorIndicator(
                              isError: passwordErrorController
                                  .isPasswordError.value),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    return SizedBox(
                      height: forgotPasswordController.isLinearLoading.value
                          ? 33
                          : 15,
                    );
                  }),
                  Obx(() {
                    return forgotPasswordController.isLinearLoading.value
                        ? Container(height: 2, child: linearLoading)
                        : Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              child: Container(
                                height: 20,
                                child: Text(
                                  'Forgot Password?',
                                  style: texFieldLabelStyle,
                                ),
                              ),
                              onTap: () {
                                if (emailErrorController.isEmailError.value ==
                                    2) {
                                  forgotPasswordController.forgotPassword(
                                      emailErrorController.email.value);
                                } else {
                                  CustomSnackBar().buildSnackBar(
                                      false, "Need a valid email!!");
                                }
                              },
                            ),
                          );
                  }),
                  SizedBox(
                    height: 30,
                  ),
                  Obx(() {
                    return CustomButton(
                      labelName: 'SIGN IN',
                      isLoading: signInController.isLoading.value,
                      onPressed: emailErrorController.isEmailError.value == 2 &&
                              passwordErrorController.isPasswordError.value == 2
                          ? () => signInController.signIn(
                              emailErrorController.emailValue,
                              passwordErrorController.passwordValue)
                          : null,
                    );
                  }),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(SignUp());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New to ',
                          style: signUpLabelStyle,
                        ),
                        Text(
                          'NUPHONIC',
                          style: appNameFontStyle,
                        ),
                        Text(
                          '? Sign Up Now',
                          style: signUpLabelStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
