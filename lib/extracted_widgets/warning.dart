import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

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
        child: Icon(
          Icons.warning,
          color: warningColor,
        ),
        message: text,
        padding: EdgeInsets.all(10),
        textStyle: normalFontStyle.copyWith(color: backgroundColor),
        decoration: circularBorder.copyWith(
            color: warningColor
        ),
      ),
    );
  }
}
