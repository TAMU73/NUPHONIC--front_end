import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_button.dart';
import 'package:nuphonic_front_end/utils/shared.dart';

class NetworkError extends StatelessWidget {
  final Function onPressed;

  NetworkError({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Connection',
              style: normalFontStyle.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800
              ),
            ),
            SizedBox(height: 15,),
            Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: normalFontStyle.copyWith(
                fontSize: 18,
                color: whitishColor.withOpacity(0.6)
              ),
            ),
            SizedBox(height: 25,),
            CustomButton(
              labelName: 'REFRESH',
              isLoading: false,
              onPressed: onPressed,
            )
          ],
        ),
      ),
    );
  }
}
