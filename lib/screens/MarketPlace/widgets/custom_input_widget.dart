import 'package:flutter/material.dart';
import 'package:market_place/theme/colors.dart';

Widget buildCustomMarketInput(
    TextEditingController controller, double width, String hintText,
    {double? height,
    IconData? iconData,
    TextInputType? keyboardType,
    void Function(String)? onChangeFunction}) {
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 5,
    ),
    height: height ?? 40,
    width: width,
    child: TextFormField(
      controller: controller,
      maxLines: null,
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            )),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: red),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            )),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            )),
        hintText: hintText,
      ),
    ),
  );
}
