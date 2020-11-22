import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/screens/wrapper.dart';

void main() {
  runApp(GetMaterialApp(
    home: Main(),
    debugShowCheckedModeBanner: false,
  ));
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrapper();
  }
}

