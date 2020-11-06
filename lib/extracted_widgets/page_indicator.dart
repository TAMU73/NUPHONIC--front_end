import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class PageIndicator extends StatelessWidget {
  final bool isCurrentPage;

  PageIndicator({this.isCurrentPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 700),
        curve: Curves.linearToEaseOut,
        height: 1.5,
        width: isCurrentPage ? 30 : 9,
        decoration: BoxDecoration(
            color: isCurrentPage ? mainColor : whitishColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
