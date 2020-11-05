import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EyeIndicator extends StatelessWidget {

  final bool isOn;

  EyeIndicator({this.isOn});

  @override
  Widget build(BuildContext context) {
    String icon = isOn ? 'eye_off_icon.svg' : 'eye_on_icon.svg';
    return SvgPicture.asset('assets/icons/$icon');
  }
}
