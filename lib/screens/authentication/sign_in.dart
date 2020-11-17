import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/extracted_widgets/error_indicator.dart';
import 'package:nuphonic_front_end/extracted_widgets/eye_indicator.dart';
import 'package:nuphonic_front_end/extracted_widgets/sliding_panel_appBar.dart';
import 'package:nuphonic_front_end/screens/authentication/confirm_code.dart';
import 'package:nuphonic_front_end/screens/authentication/sign_up.dart';
import 'package:nuphonic_front_end/screens/authentication/validation/validation.dart';
import 'package:nuphonic_front_end/screens/wrapper.dart';
import 'package:nuphonic_front_end/service/auth_service.dart';
import 'package:nuphonic_front_end/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool isOn = true;

  bool isLoading = false;
  bool isLinearLoading = false;

  //0 means error, 1 means success and null means default
  int isErrorE; //for email
  int isErrorP; //for password

  Validation validate = Validation();

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

  void showSnackBar(String msg, bool success) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
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
    ));
  }

  Future<void> signIn(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _auth.signIn(email, password);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      showSnackBar("Network Error", false);
    } else {
      print(result.data['msg']);
      showSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        dynamic key = 'user_id';
        dynamic value = result.data['id'];
        prefs.setString(key, value);
        await new Future.delayed(const Duration(seconds: 1));
        Scaffold.of(context).hideCurrentSnackBar();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
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
      showSnackBar("Network Error", false);
    } else {
      print(result.data['msg']);
      showSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        await new Future.delayed(const Duration(seconds: 1));
        Scaffold.of(context).hideCurrentSnackBar();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmCode(email: email),
          ),
        );
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
                    obsecureText: isOn,
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
                            onTap: () {
                              if (isErrorE == 1) {
                                forgotPassword(email);
                              } else {
                                showSnackBar("Need a valid Email!!", false);
                              }
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      );
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
