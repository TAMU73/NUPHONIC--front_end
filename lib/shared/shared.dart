import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const backgroundColor = Colors.black;
const mainColor = Color(0xff7B4BFF);
const whitishColor = Color(0xffE4E4E4);
const darkGreyColor = Color(0xff191919);
const textFieldColor = Color(0xff3C3C3C);

const bottomPanelBorderRadius = BorderRadius.only(
  topRight: Radius.circular(30),
  topLeft: Radius.circular(30),
);

var normalFontStyle = GoogleFonts.khula();

var appNameFontStyle = GoogleFonts.wallpoet();

var texFieldLabelStyle = normalFontStyle.copyWith(
  color: whitishColor,
  fontSize: 18,
);

var titleTextStyle = normalFontStyle.copyWith(
  color: whitishColor,
  fontSize: 30,
  fontWeight: FontWeight.w700,
);
