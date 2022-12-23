import 'package:flutter/material.dart';

getGradientColor(stringColor) {
  if (stringColor == 'lineargradient(135deg,rgb(252,87,118),rgb(189,13,42))') {
    return const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(252, 87, 118, 1),
          Color.fromRGBO(189, 13, 42, 1)
        ]);
  } else if (stringColor ==
      'lineargradient(135deg,rgb(255,104,84),rgb(228,30,63))') {
    return const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(255, 104, 84, 1),
          Color.fromRGBO(228, 30, 63, 1)
        ]);
  } else if (stringColor ==
      'lineargradient(135deg,rgb(0,110,95),rgb(24,71,35))') {
    return const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [Color.fromRGBO(0, 110, 95, 1), Color.fromRGBO(24, 71, 35, 1)]);
  } else if (stringColor ==
      'lineargradient(135deg,rgb(50,171,79),rgb(36,133,60))') {
    return const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(50, 171, 79, 1),
          Color.fromRGBO(36, 133, 60, 1)
        ]);
  } else if (stringColor ==
      'lineargradient(135deg,rgb(0,153,230),rgb(49,162,76))') {
    return const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(0, 153, 230, 1),
          Color.fromRGBO(49, 162, 76, 1)
        ]);
  } else if (stringColor ==
      'lineargradient(135deg,rgb(45,136,255),rgb(23,99,207))') {
    return const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(45, 136, 255, 1),
          Color.fromRGBO(23, 99, 207, 1)
        ]);
  } else if (stringColor ==
      'lineargradient(135deg,rgb(23,99,207),rgb(7,49,109))') {
    return const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(23, 99, 207, 1),
          Color.fromRGBO(7, 49, 109, 1)
        ]);
  } else if (stringColor ==
      'lineargradient(135deg,rgb(237,65,165),rgb(23,99,207))') {
    return const LinearGradient(
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        colors: [
          Color.fromRGBO(237, 65, 165, 1),
          Color.fromRGBO(23, 99, 207, 1)
        ]);
  }
}
