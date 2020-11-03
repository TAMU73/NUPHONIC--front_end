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
          GestureDetector(
            onTap: onIconTap,
            child: SvgPicture.asset(leadIconPath),
          ),
          SizedBox(
            width: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
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
