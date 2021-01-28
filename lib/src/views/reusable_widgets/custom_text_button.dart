import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class CustomTextButton extends StatelessWidget {
  final bool isLoading;
  final Function onPressed;
  final String label;

  CustomTextButton({this.isLoading, this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? SpinKitFadingCube(
              color: Color(0xff7B4BFF),
              duration: Duration(milliseconds: 800),
              size: 20,
            )
          : InkWell(
              onTap: onPressed,
              child: Text(
                label,
                style: textButtonStyle,
              ),
            ),
    );
  }
}
