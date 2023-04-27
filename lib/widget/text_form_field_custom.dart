import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class TextFormFieldCustom extends StatefulWidget {
  final String? initialValue;
  final String? helperText;
  final String? errorText;
  final String? label;
  final String? hintText;
  final String? value;
  final bool? isDense;
  final String? type;

  final Function? handleGetValue;
  final TextEditingController? textController;
  final FocusNode? focusNode;

  final bool autofocus;
  final int? minLines;
  final int? maxLines;

  final Widget? suffixIcon;

  const TextFormFieldCustom(
      {Key? key,
      this.type,
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
  Size? getTextSize(String text) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 14)),
      maxLines: 5,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width * 0.5);

    // if ((painter.size / 16) % 2 == 0) {
    //   return Size(painter.size.width, painter.size.height + 30.0);
    // }
    return Size(painter.size.width, painter.size.height + 20.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Stack(alignment: AlignmentDirectional.bottomEnd, children: [
          TextFormField(
            focusNode: widget.focusNode,
            controller: widget.textController,
            textCapitalization: TextCapitalization.words,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.multiline,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            initialValue: widget.initialValue,
            autofocus: widget.autofocus,
            cursorColor: Theme.of(context).textTheme.displayLarge?.color,
            onChanged: (value) {
              widget.handleGetValue!(value);
            },
            // inputFormatters: [
            //   // TextInputFormatter.withFunction()
            //   // FilteringTextInputFormatter(RegExp("abc"),
            //   //     allow: true, replacementString: "dfgdfgdf"),
            // ],
            decoration: InputDecoration(
              labelText: widget.label,
              focusColor: primaryColor,
              helperText: widget.helperText,
              errorText: widget.errorText,
              isDense: true,
              border: InputBorder.none,
              hintText: widget.hintText,
              contentPadding:
                  const EdgeInsets.only(right: 40, top: 10, bottom: 10),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 8),
            child: widget.suffixIcon,
          ),
        ]),
      ),
    );
  }
}
