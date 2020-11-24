import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class ErrorIndicator extends StatelessWidget {
  //0 means error, 1 means success and null means default
  final int isError;

  ErrorIndicator({Key key, this.isError});

  @override
  Widget build(BuildContext context) {
    Color iconColor = isError == null
        ? Color(0xff656565)
        : isError == 1
            ? greenishColor
            : reddishColor;
    return SvgPicture.asset(
      'assets/icons/check_icon.svg',
      color: iconColor,
    );
  }
}
