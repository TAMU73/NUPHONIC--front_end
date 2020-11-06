import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class CustomAppBar extends StatelessWidget {

  final Function onIconTap;
  final String leadIconPath;
  final String label;

  CustomAppBar({this.onIconTap, this.leadIconPath, this.label});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leadIconPath != null ? GestureDetector(
            onTap: onIconTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SvgPicture.asset(leadIconPath),
            ),
          ) : SizedBox(),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: titleTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
