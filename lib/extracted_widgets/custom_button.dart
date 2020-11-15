import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class CustomButton extends StatelessWidget {

  final String labelName;
  final Function onPressed;
  final bool isLoading;

  const CustomButton({this.labelName, this.onPressed, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
        ),
        child: isLoading ? loading : MaterialButton(
          onPressed: onPressed,
          height: 50,
          color: mainColor,
          disabledColor: mainColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 3,left: 15, right: 15),
            child: Text(
              labelName,
              style: normalFontStyle.copyWith(
                  letterSpacing: 1.5,
                  color: onPressed == null ? whitishColor.withOpacity(0.4):whitishColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800
              ),
            ),
          ),
        ),
      ),
    );
  }
}
