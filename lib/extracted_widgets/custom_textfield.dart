import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class CustomTextField extends StatelessWidget {

  final String labelName;
  final String hint;
  final Widget icons;
  final bool obsecureText;
  final Function onChanged;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final TextInputType keyboardType;

  CustomTextField({this.labelName, this.hint, this.icons, this.obsecureText, this.onChanged, this.onEditingComplete, this.textInputAction, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelName != null ? Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            labelName,
            style: texFieldLabelStyle,
          ),
        ) : SizedBox(),
        Container(
          decoration: circularBorder,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  obscureText: obsecureText ?? false,
                  cursorHeight: 24,
                  cursorColor: whitishColor,
                  style: texFieldLabelStyle,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    fillColor: textFieldColor,
                    filled: true,
                    hintStyle: normalFontStyle.copyWith(
                        color: whitishColor.withOpacity(0.25),
                        fontSize: 13,
                        letterSpacing: 0.5
                    ),
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
              SizedBox(width: 10,),
            ],
          ),
        ),
      ],
    );
  }
}
