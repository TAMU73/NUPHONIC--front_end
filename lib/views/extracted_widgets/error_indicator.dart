import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/utils/shared.dart';

class ErrorIndicator extends StatelessWidget {
  //0 means default, 1 means error and 2 means success
  final int isError;

  ErrorIndicator({Key key, this.isError});

  @override
  Widget build(BuildContext context) {
    Color iconColor = isError == 0
        ? Color(0xff656565)
        : isError == 2
            ? greenishColor
            : reddishColor;
    return SvgPicture.asset(
      'assets/icons/check_icon.svg',
      color: iconColor,
    );
  }
}
