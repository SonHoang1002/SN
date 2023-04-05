import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class TextFormFieldCustom extends StatefulWidget {
  final String? initialValue;
  final String? helperText;
  final String? errorText;
  final String? label;
  final String? hintText;
  final String? value;
  final bool? isDense;

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
      this.value,
      this.isDense})
      : super(key: key);

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  String content = '';

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Theme.of(context).colorScheme.background,
        child: TextFormField(
          focusNode: widget.focusNode,
          controller: widget.textController,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          initialValue: widget.initialValue,
          autofocus: widget.autofocus,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          cursorColor: Theme.of(context).textTheme.displayLarge?.color,
          onChanged: (value) {
            widget.handleGetValue!(value);
          },
          decoration: InputDecoration(
            isDense: widget.isDense ?? false,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(left: 12),
            suffixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            hintStyle: const TextStyle(fontSize: 14),
            labelText: widget.label,
            focusColor: primaryColor,
            helperText: widget.helperText,
            errorText: widget.errorText,
          ),
        ));
  }
}
