import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const COLOR_BLACK = Color.fromRGBO(48, 47, 48, 1.0);
const COLOR_GREY = Color(0xFF5C6378);
const COLOR_WINE_RED = Color.fromRGBO(40, 11, 17, 1.0);
const COLOR_WINE_RED_LIGHT = Color.fromRGBO(79, 23, 34, 1.0);
const COLOR_WHITE = Color(0xFFEDF2F4);
const COLOR_ACCENT = Color(0xFF63bd49);
const COLOR_DARK_BLUE = Color(0xFF2b2d42);
const COLOR_DARK_BLUE_SHADE_DARK = Color.fromRGBO(17, 30, 45, 1.0);
const COLOR_DARK_BLUE_SHADE_LIGHT = Color.fromRGBO(44, 55, 78, 1.0);

const COVER_IMAGES = {
  0: "morning.jpg",
  1: "morning2.jpg",
  2: "morning3.jpg",
  3: "midday.jpg",
  4: "midday2.jpg",
  5: "midday3.jpg",
  6: "nighttime.jpg",
  7: "nighttime2.jpg",
  8: "nighttime3.jpg",
};

const TextTheme TEXT_THEME_DEFAULT = TextTheme(
    headline1: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 26),
    headline2: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 22),
    headline3: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 20),
    headline4: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 16),
    headline5: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 14),
    headline6: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 12),
    bodyText1: TextStyle(
        color: COLOR_WHITE,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5),
    bodyText2: TextStyle(
        color: COLOR_GREY,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5),
    subtitle1: TextStyle(
        color: COLOR_WHITE, fontSize: 12, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: COLOR_GREY, fontSize: 12, fontWeight: FontWeight.w400));

const TextTheme TEXT_THEME_SMALL = TextTheme(
    headline1: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 22),
    headline2: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 20),
    headline3: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 18),
    headline4: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 14),
    headline5: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 12),
    headline6: TextStyle(
        color: COLOR_WHITE, fontWeight: FontWeight.w700, fontSize: 10),
    bodyText1: TextStyle(
        color: COLOR_WHITE,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5),
    bodyText2: TextStyle(
        color: COLOR_GREY,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5),
    subtitle1: TextStyle(
        color: COLOR_WHITE, fontSize: 10, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: COLOR_GREY, fontSize: 10, fontWeight: FontWeight.w400));
