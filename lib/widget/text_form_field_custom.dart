import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class TextFormFieldCustom extends StatelessWidget {
  final String? initialValue;
  final String? helperText;
  final String? errorText;
  final String? label;
  final String? hintText;

  final bool autofocus;
  final int? minLines;
  final int? maxLines;

  const TextFormFieldCustom(
      {Key? key,
      this.initialValue,
      this.helperText,
      required this.autofocus,
      this.minLines,
      this.maxLines,
      this.errorText,
      this.label,
      this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      initialValue: initialValue,
      autofocus: autofocus,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          focusColor: primaryColor,
          helperText: helperText,
          errorText: errorText,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: secondaryColor),
              borderRadius: BorderRadius.circular(15.0)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: greyColor),
              borderRadius: BorderRadius.circular(15.0))),
    );
  }
}
