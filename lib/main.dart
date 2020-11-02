import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/screens/authentication/onboarding.dart';

void main() {
  runApp(MaterialApp(
    home: Main(),
  ));
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Onboarding();
  }
}

