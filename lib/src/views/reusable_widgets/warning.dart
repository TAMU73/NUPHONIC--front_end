import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class Warning extends StatelessWidget {
  final GlobalKey toolTipKey;
  final String text;

  Warning({this.toolTipKey, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final dynamic tooltip = toolTipKey.currentState;
        tooltip.ensureTooltipVisible();
      },
      child: Tooltip(
        key: toolTipKey,
        child: SvgPicture.asset('assets/icons/warning.svg'),
        message: text,
        padding: EdgeInsets.all(10),
        textStyle: normalFontStyle.copyWith(color: backgroundColor),
        decoration: circularBorder.copyWith(color: warningColor),
      ),
    );
  }
}
