import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'file:///C:/Users/DELL/Desktop/FYP/NUPHONIC%20-%20front_end/lib/views/wrapper.dart';

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

