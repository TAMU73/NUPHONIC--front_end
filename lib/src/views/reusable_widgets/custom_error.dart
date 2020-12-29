import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class CustomError extends StatelessWidget {
  final Function onPressed;
  final String buttonLabel;
  final String title;
  final String subTitle;

  CustomError({this.onPressed, this.buttonLabel, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title != null ? title : 'No Connection',
              style: normalFontStyle.copyWith(
                  fontSize: 22, fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              subTitle != null ? subTitle : 'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: normalFontStyle.copyWith(
                  fontSize: 18, color: whitishColor.withOpacity(0.6)),
            ),
            SizedBox(
              height: 35,
            ),
            CustomButton(
              labelName: buttonLabel != null ? buttonLabel : 'REFRESH',
              isLoading: false,
              onPressed: onPressed,
            )
          ],
        ),
      ),
    );
  }
}
