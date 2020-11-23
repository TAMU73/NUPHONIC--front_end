import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/error_indicator.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/eye_indicator.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/sliding_panel_app_bar.dart';
import 'package:nuphonic_front_end/src/views/screens/authentication/confirm_code.dart';
import 'package:nuphonic_front_end/src/views/screens/authentication/sign_up.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:nuphonic_front_end/src/views/utils/validation.dart';
import 'package:nuphonic_front_end/src/views/wrapper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email;
  String password;

  AuthService _auth = AuthService();
  PanelController _controller = PanelController();
  Validation validate = Validation();

  bool isOn = true;

  bool isLoading = false;
  bool isLinearLoading = false;

  //0 means error, 1 means success and null means default
  int isErrorE; //for email
  int isErrorP; //for password

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

  Future<void> signIn(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _auth.signIn(email, password);
    if (result == null) {
      await CustomSnackBar().buildSnackBar("Network Error", false);
    } else {
      if (result.data['success']) {
        dynamic result1 = await _auth.getUserInfo(result.data['id']);
        await SharedPrefService().save(id: 'user_id', data: result.data['id']);
        await SharedPrefService().save(
            id: 'first_name',
            data: result1.data['user']['full_name'].split(" ")[0]);
        setState(() {
          isLoading = false;
        });
        await CustomSnackBar()
            .buildSnackBar(result.data['msg'], result.data['success']);
        Get.offAll(Wrapper());
      } else {
        setState(() {
          isLoading = false;
        });
        await CustomSnackBar()
            .buildSnackBar(result.data['msg'], result.data['success']);
      }
    }
  }

  Future<void> forgotPassword(String email) async {
    setState(() {
      isLinearLoading = true;
    });
    dynamic result = await _auth.forgotPassword(email);
    setState(() {
      isLinearLoading = false;
    });
    if (result == null) {
      await CustomSnackBar().buildSnackBar("Network Error", false);
    } else {
      print(result.data['msg']);
      await CustomSnackBar()
          .buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        Get.to(ConfirmCode(
          email: email,
        ));
      }
    }
  }

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
                  CustomTextField(
                      labelName: 'Email',
                      hint: 'example@example.com',
                      icons: ErrorIndicator(isError: isErrorE),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onChanged: (val) {
                        checkEmail(val);
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    labelName: 'Password',
                    obSecureText: isOn,
                    hint: '8+ character password',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onChanged: (val) {
                      checkPassword(val);
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
                    height: isLinearLoading ? 33 : 15,
                  ),
                  isLinearLoading
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
                            onTap: () async {
                              isErrorE == 1
                                  ? forgotPassword(email)
                                  : await CustomSnackBar().buildSnackBar(
                                      "Need a valid Email!!", false);
                            },
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    labelName: 'SIGN IN',
                    isLoading: isLoading,
                    onPressed: isErrorE == 1 && isErrorP == 1
                        ? () => signIn(email, password)
                        : null,
                  ),
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
