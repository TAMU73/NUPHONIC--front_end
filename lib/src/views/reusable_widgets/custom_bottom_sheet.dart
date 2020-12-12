import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/sliding_panel_app_bar.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomBottomSheet extends StatelessWidget {
  final PanelController controller;
  final String titleName;
  final String labelName;
  final String hintName;
  final String buttonName;
  final Function onPressed;
  final bool isLoading;

  CustomBottomSheet({this.controller, this.titleName, this.labelName, this.hintName, this.buttonName, this.onPressed, this.isLoading});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlidingUpPanel(
        color: Colors.transparent,
        backdropEnabled: true,
        controller: controller,
        minHeight: 0,
        maxHeight: 325,
        panel: Column(
          children: [
            SlidingPanelAppBar(
              height: 83,
              text: titleName,
              controller: controller,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(20,0,20,65),
                color: darkGreyColor,
                child: Column(
                  children: [
                    CustomTextField(
                      labelName: labelName,
                      hint: hintName,
                    ),
                    SizedBox(height: 20,),
                    CustomButton(
                      labelName: buttonName,
                      isLoading: isLoading,
                      onPressed: onPressed,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
