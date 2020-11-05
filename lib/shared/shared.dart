import 'package:flutter/material.dart';

const backgroundColor = Colors.black;
const mainColor = Color(0xff7B4BFF);
const whitishColor = Color(0xffE4E4E4);
const darkGreyColor = Color(0xff191919);
const textFieldColor = Color(0xff292929);
const reddishColor = Color(0xffF05959);
const greenishColor = Color(0xff2DCC70);

const bottomPanelBorderRadius = BorderRadius.only(
  topRight: Radius.circular(30),
  topLeft: Radius.circular(30),
);

const normalFontStyle = TextStyle(
  fontFamily: "Gilroy",
  color: whitishColor,
  fontSize: 14,
  fontWeight: FontWeight.w400
);

const appNameFontStyle = TextStyle(
  fontFamily: "Wallpoet",
  color: whitishColor,
  fontSize: 14,
  letterSpacing: 1
);

const texFieldLabelStyle = TextStyle(
  fontFamily: "Gilroy",
  color: whitishColor,
  fontSize: 15,
  letterSpacing: 0.5,
);

const titleTextStyle = TextStyle(
    fontFamily: "Gilroy",
    color: whitishColor,
    fontSize: 28,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w700,
);

const signUpLabelStyle = TextStyle(
  fontFamily: "Gilroy",
    color: whitishColor,
    fontSize: 14,
    letterSpacing: 0.5
);

const circularBorder = BoxDecoration(
    color: textFieldColor,
    borderRadius: BorderRadius.all(Radius.circular(10))
);
