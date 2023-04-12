import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextReadMore extends StatefulWidget {
  final String description;
  final bool isReadMore;
  final dynamic onTap;
  final fontSize;

  const TextReadMore(
      {Key? key,
      required this.description,
      required this.isReadMore,
      this.fontSize,
      required this.onTap})
      : super(key: key);
  @override
  State<TextReadMore> createState() => _TextReadMoreState();
}

class _TextReadMoreState extends State<TextReadMore> {
  String firstHalf = '';
  String secondHalf = '';
  @override
  void initState() {
    super.initState();
    if (widget.description.length > 100) {
      firstHalf = widget.description.substring(0, 100);
      secondHalf = widget.description.substring(100, widget.description.length);
    } else {
      firstHalf = widget.description;
      secondHalf = "";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(firstHalf)
          : Column(
              children: [
                RichText(
                  key: ValueKey(widget.description),
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                      text: widget.isReadMore
                          ? ("$firstHalf...")
                          : (firstHalf + secondHalf),
                      style: TextStyle(
                        fontSize: widget.fontSize ?? 12.0,
                        color: const Color(0xFF212121),
                      ),
                      children: <InlineSpan>[
                        widget.isReadMore
                            ? TextSpan(
                                text: ' Đọc thêm',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = widget.onTap)
                            : const TextSpan()
                      ]),
                ),
              ],
            ),
    );
  }
}
