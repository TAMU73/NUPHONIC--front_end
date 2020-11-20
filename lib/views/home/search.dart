import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/views/extracted_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/utils/shared.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20,),
                CustomAppBar(
                  label: 'Search',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
