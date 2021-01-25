import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const backgroundColor = Color(0xff000000);
const mainColor = Color(0xff7B4BFF);
const whitishColor = Color(0xffE4E4E4);
const darkGreyColor = Color(0xff191919);
const lightGreyColor = Color(0xff817E7D);
const textFieldColor = Color(0xff292929);
const reddishColor = Color(0xffF05959);
const greenishColor = Color(0xff2DCC70);
const warningColor = Color(0xffFFC61C);

const loading = Center(
  child: SpinKitFadingCube(
    color: Color(0xff7B4BFF),
    duration: Duration(milliseconds: 800),
    size: 50,
  ),
);

const linearLoading = LinearProgressIndicator(
  backgroundColor: backgroundColor,
  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
);

const bottomPanelBorderRadius = BorderRadius.only(
  topRight: Radius.circular(30),
  topLeft: Radius.circular(30),
);

const textButtonStyle = TextStyle(
  fontFamily: "Proxima Nova",
  color: mainColor,
  fontSize: 18,
  fontWeight: FontWeight.w600
);

const normalFontStyle = TextStyle(
  fontFamily: "Proxima Nova",
  color: whitishColor,
  fontSize: 14,
  letterSpacing: 0.5,
);

const appNameFontStyle = TextStyle(
  fontFamily: "Wallpoet",
  color: whitishColor,
  fontSize: 14,
  letterSpacing: 1,
);

const texFieldLabelStyle = TextStyle(
  fontFamily: "Proxima Nova",
  color: whitishColor,
  fontSize: 15,
  letterSpacing: 0.5,
);

const titleTextStyle = TextStyle(
  fontFamily: "Proxima Nova",
  color: whitishColor,
  fontSize: 24,
  letterSpacing: 1,
  fontWeight: FontWeight.w800,
);

const signUpLabelStyle = TextStyle(
    fontFamily: "Gilroy",
    color: whitishColor,
    fontSize: 14,
    letterSpacing: 0.5);

const circularBorder = BoxDecoration(
    color: textFieldColor, borderRadius: BorderRadius.all(Radius.circular(10)));
