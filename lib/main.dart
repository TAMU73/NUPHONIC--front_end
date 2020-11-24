import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/views/wrapper.dart';

void main() {
  runApp(GetMaterialApp(
    home: Main(),
    debugShowCheckedModeBanner: false,
  ));
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: Wrapper(),
      ),
    );
  }
}
