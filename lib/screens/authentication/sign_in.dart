import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/sliding_panel_appBar.dart';
import 'package:nuphonic_front_end/extracted_widgets/textfield_box.dart';
import 'package:nuphonic_front_end/screens/authentication/sign_up.dart';
import 'package:nuphonic_front_end/shared/shared.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  PanelController _controller = PanelController();

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        controller: _controller,
        backdropEnabled: true,
        color: darkGreyColor,
        minHeight: 83,
        maxHeight: 500,
        borderRadius: bottomPanelBorderRadius,
        collapsed: SlidingPanelAppBar(
          height: 83,
          text: 'SIGN IN TO CONTINUE',
          controller: _controller,
        ),
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlidingPanelAppBar(
              height: 83,
              text: 'SIGN IN WITH EMAIL',
              controller: _controller,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email:',
                        style: texFieldLabelStyle,
                      ),
                      SizedBox(height: 10,),
                      TextFieldBox(hint: "example@example.com",),
                      SizedBox(height: 20,),
                      Text(
                        'Password:',
                        style: texFieldLabelStyle,
                      ),
                      SizedBox(height: 10,),
                      TextFieldBox(hint: "6+ character password",),
                      SizedBox(height: 15,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: texFieldLabelStyle.copyWith(
                              fontSize: 13
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      CustomButton(
                        labelName: 'SIGN IN',
                        onPressed: () {},
                      ),
                      SizedBox(height: 30,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SignUp()
                          ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to ',
                              style: normalFontStyle.copyWith(
                                  color: whitishColor,
                                  fontSize: 14
                              ),
                            ),
                            Text(
                              'NUPHONIC',
                              style: appNameFontStyle.copyWith(
                                  color: whitishColor,
                                  fontSize: 14
                              ),
                            ),
                            Text(
                              '? Sign Up Now',
                              style: normalFontStyle.copyWith(
                                  color: whitishColor,
                                  fontSize: 14
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
