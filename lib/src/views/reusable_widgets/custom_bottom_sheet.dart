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
  final String secondLabelName;
  final String secondHintName;
  final TextEditingController textController;
  final TextEditingController secondTextController;
  final Function onChanged;
  final Function secondOnChanged;

  CustomBottomSheet(
      {this.controller,
      this.titleName,
      this.labelName,
      this.hintName,
      this.buttonName,
      this.onPressed,
      this.isLoading,
      this.secondHintName,
      this.secondLabelName,
      this.secondTextController,
      this.textController,
      this.onChanged,
      this.secondOnChanged});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlidingUpPanel(
        color: Colors.transparent,
        backdropEnabled: true,
        controller: controller,
        minHeight: 0,
        maxHeight:
            secondLabelName != null && secondHintName != null ? 570 : 320,
        panel: Container(
          decoration: BoxDecoration(
            color: darkGreyColor,
            borderRadius: bottomPanelBorderRadius,
          ),
          child: Column(
            children: [
              SlidingPanelAppBar(
                height: 83,
                text: titleName,
                controller: controller,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 65),
                  color: darkGreyColor,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: textController,
                        labelName: labelName,
                        hint: hintName,
                        onChanged: onChanged,
                      ),
                      secondLabelName != null && secondHintName != null
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  controller: secondTextController,
                                  maxLines: 6,
                                  labelName: secondLabelName,
                                  hint: secondHintName,
                                  onChanged: secondOnChanged,
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        labelName: buttonName,
                        isLoading: isLoading,
                        onPressed: onPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
