import 'package:flutter/material.dart';

const white = Color(0xFFFFFFFF);
const online = Color(0xFF66BB6A);
const primaryColor = Color(0xFFF4802F);
final primaryColorSelected = const Color(0xFFF4802F).withOpacity(0.1);

const secondaryColor = Color(0xFF7165E0);
final secondaryColorSelected = const Color(0xFF7165E0).withOpacity(0.1);

const greyColor = Colors.grey;
const red = Colors.red;
const blueColor = Colors.blue;
const blackColor = Colors.black;
const transparent = Colors.transparent;

List colorsGradient = [
  {
    "color": 'linear-gradient(135deg, rgb(252, 87, 118), rgb(189, 13, 42))',
    "gradient": const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(252, 87, 118, 1),
          Color.fromRGBO(189, 13, 42, 1)
        ])
  },
  {
    "color": 'linear-gradient(135deg, rgb(255, 104, 84), rgb(228, 30, 63))',
    "gradient": const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(255, 104, 84, 1),
          Color.fromRGBO(228, 30, 63, 1)
        ])
  },
  {
    "color": 'linear-gradient(135deg, rgb(0, 110, 95), rgb(24, 71, 35))',
    "gradient": const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [Color.fromRGBO(0, 110, 95, 1), Color.fromRGBO(24, 71, 35, 1)])
  },
  {
    "color": 'linear-gradient(135deg, rgb(50, 171, 79), rgb(36, 133, 60))',
    "gradient": const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(50, 171, 79, 1),
          Color.fromRGBO(36, 133, 60, 1)
        ])
  },
  {
    "color": 'linear-gradient(135deg, rgb(0, 153, 230), rgb(49, 162, 76))',
    "gradient": const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(0, 153, 230, 1),
          Color.fromRGBO(49, 162, 76, 1)
        ])
  },
  {
    "color": 'linear-gradient(135deg, rgb(45, 136, 255), rgb(23, 99, 207))',
    "gradient": const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(45, 136, 255, 1),
          Color.fromRGBO(23, 99, 207, 1)
        ])
  },
  {
    "color": 'linear-gradient(135deg, rgb(23, 99, 207), rgb(7, 49, 109))',
    "gradient": const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [Color.fromRGBO(23, 99, 207, 1), Color.fromRGBO(7, 49, 109, 1)])
  },
  {
    "color": 'linear-gradient(135deg, rgb(237, 65, 165), rgb(23, 99, 207))',
    "gradient": const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(237, 65, 165, 1),
          Color.fromRGBO(23, 99, 207, 1)
        ])
  }
];
