import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class CustomAppBar extends StatelessWidget {
  final Function onIconTap;
  final String leadIconPath;
  final String label;
  final TextStyle labelTextStyle;
  final String secondLabel;
  final TextStyle secondLabelTextStyle;
  final Widget endChild;

  CustomAppBar(
      {this.onIconTap,
      this.leadIconPath,
      this.label,
      this.endChild,
      this.secondLabel,
      this.labelTextStyle,
      this.secondLabelTextStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leadIconPath != null
              ? InkWell(
                  onTap: onIconTap,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SvgPicture.asset(leadIconPath),
                  ),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      labelTextStyle != null ? labelTextStyle : titleTextStyle,
                ),
                secondLabel != null
                    ? Text(
                        secondLabel,
                        style: secondLabelTextStyle != null
                            ? secondLabelTextStyle
                            : titleTextStyle,
                      )
                    : SizedBox()
              ],
            ),
          ),
          Spacer(),
          endChild != null ? endChild : SizedBox()
        ],
      ),
    );
  }
}
