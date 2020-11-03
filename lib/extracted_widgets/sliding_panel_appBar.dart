import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/shared/shared.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelAppBar extends StatelessWidget {
  final double height;
  final String text;
  final PanelController controller;

  SlidingPanelAppBar({this.height, this.text, this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: darkGreyColor,
        borderRadius: bottomPanelBorderRadius,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 14,
          ),
          SvgPicture.asset('assets/icons/slide_icon.svg'),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  controller.open();
                },
                child: Text(
                  text,
                  style: normalFontStyle.copyWith(
                      color: mainColor,
                      letterSpacing: 1.5,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
