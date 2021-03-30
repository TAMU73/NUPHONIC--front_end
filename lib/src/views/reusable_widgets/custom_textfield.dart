import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class CustomTextField extends StatelessWidget {
  final String labelName;
  final String hint;
  final Widget icons;
  final bool obSecureText;
  final Function onChanged;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final EdgeInsets contentPadding;
  final int maxLines;
  final double height;

  CustomTextField({
    this.labelName,
    this.height,
    this.hint,
    this.icons,
    this.obSecureText,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction,
    this.keyboardType,
    this.contentPadding,
    this.controller,
    this.focusNode,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelName != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  labelName,
                  style: texFieldLabelStyle,
                ),
              )
            : SizedBox(),
        Container(
          decoration: circularBorder,
          height: height,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: maxLines != null ? maxLines : 1,
                  focusNode: focusNode,
                  controller: controller,
                  obscureText: obSecureText ?? false,
                  cursorHeight: 24,
                  cursorColor: whitishColor,
                  style: texFieldLabelStyle,
                  decoration: InputDecoration(
                    contentPadding: contentPadding != null
                        ? contentPadding
                        : EdgeInsets.fromLTRB(15, 15, 15, 15),
                    fillColor: textFieldColor,
                    filled: true,
                    hintStyle: normalFontStyle.copyWith(
                        color: whitishColor.withOpacity(0.25),
                        fontSize: 13,
                        letterSpacing: 0.5),
                    hintText: hint,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onChanged: onChanged,
                  textInputAction: textInputAction,
                  onEditingComplete: onEditingComplete,
                  keyboardType: keyboardType,
                ),
              ),
              icons != null ? icons : SizedBox(),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
