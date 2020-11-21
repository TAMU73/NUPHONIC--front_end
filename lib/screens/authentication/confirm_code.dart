import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/extracted_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/extracted_widgets/warning.dart';
import 'package:nuphonic_front_end/screens/authentication/reset_password.dart';
import 'package:nuphonic_front_end/service/auth_service.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class ConfirmCode extends StatefulWidget {
  final String email;

  ConfirmCode({this.email});

  @override
  _ConfirmCodeState createState() => _ConfirmCodeState();
}

class _ConfirmCodeState extends State<ConfirmCode> {
  AuthService _auth = AuthService();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _toolTipKey = GlobalKey();

  String code = "";

  bool isLoading = false;


  Future<void> _confirmCode(String email, String code) async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _auth.confirmCode(email, code);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      await CustomSnackBar().buildSnackBar("Network Error", false);
    } else {
      print(result.data['msg']);
      await CustomSnackBar().buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        Get.off(ResetPassword(email: email));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    'Code has been sent to your email address \n ${widget.email}',
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
                    setState(() {
                      code = val;
                    });
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                CustomButton(
                  labelName: 'CONFIRM',
                  isLoading: isLoading,
                  onPressed:
                      code == "" ? null : () => _confirmCode(widget.email, code),
                ),
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
