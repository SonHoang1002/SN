import 'package:flutter/material.dart';

class TextFieldGroup extends StatefulWidget {
  final String label;
  final Widget? suffixIcon;
  final dynamic initialValue;
  final bool? readOnly;
  final bool? enabled;
  const TextFieldGroup(
      {super.key,
      required this.label,
      this.suffixIcon,
      this.initialValue,
      this.readOnly,
      this.enabled});

  @override
  State<TextFieldGroup> createState() => _TextFieldGroupState();
}

class _TextFieldGroupState extends State<TextFieldGroup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: TextFormField(
        key: ValueKey(widget.initialValue),
        readOnly: widget.readOnly ?? false,
        enabled: widget.enabled,
        autofocus: false,
        initialValue: widget.initialValue,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: widget.suffixIcon,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
