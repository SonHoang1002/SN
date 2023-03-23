import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class TextFormFieldCustom extends StatefulWidget {
  final String? initialValue;
  final String? helperText;
  final String? errorText;
  final String? label;
  final String? hintText;
  final String? value;

  final Function? handleGetValue;
  final TextEditingController? textController;
  final FocusNode? focusNode;

  final bool autofocus;
  final int? minLines;
  final int? maxLines;

  final Widget? suffixIcon;

  const TextFormFieldCustom(
      {Key? key,
      this.initialValue,
      this.helperText,
      required this.autofocus,
      this.minLines,
      this.maxLines,
      this.errorText,
      this.label,
      this.hintText,
      this.suffixIcon,
      this.handleGetValue,
      this.textController,
      this.focusNode,
      this.value})
      : super(key: key);

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  String content = '';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.textController,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      initialValue: widget.initialValue,
      autofocus: widget.autofocus,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.multiline,
      cursorColor: Theme.of(context).textTheme.displayLarge?.color,
      onChanged: (value) {
        widget.handleGetValue!(value);
      },
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: secondaryColor),
            borderRadius: BorderRadius.circular(12.0)),
        contentPadding:
            const EdgeInsets.only(left: 5, bottom: 0, top: 0, right: 0),
        suffixIcon: widget.suffixIcon,
        fillColor: Colors.red,
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontSize: 13),
        labelText: widget.label,
        focusColor: primaryColor,
        helperText: widget.helperText,
        errorText: widget.errorText,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: secondaryColor),
            borderRadius: BorderRadius.circular(12.0)),
      ),
    );
  }
}
