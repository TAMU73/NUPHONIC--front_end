import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';

class BackBlank extends StatelessWidget {
  final Widget child;

  BackBlank({this.child});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: CustomAppBar(
            leadIconPath: 'assets/icons/back_icon.svg',
            onIconTap: () {
              Get.back();
            },
            label: "",
          ),
        ),
        child,
      ],
    );
  }
}
