import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class CustomButton extends StatelessWidget {

  final String labelName;
  final Function onPressed;

  const CustomButton({this.labelName, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[
              // BoxShadow(
              //   color: mainColor.withOpacity(0.1),
              //   blurRadius: 10,
              //   offset: Offset(0, 10),
              // ),
            ]
        ),
        child: MaterialButton(
          onPressed: onPressed,
          height: 50,
          color: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 3,left: 15, right: 15),
            child: Text(
              labelName,
              style: normalFontStyle.copyWith(
                  letterSpacing: 1.5,
                  color: whitishColor,
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
