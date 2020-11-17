import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class NetworkError extends StatelessWidget {
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
          ],
        ),
      ),
    );
  }
}
