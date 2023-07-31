// ignore_for_file: unused_local_variable

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

import '../../../widgets/appbar_title.dart';
import '../../../widgets/button_primary.dart';

class TextFieldEdit extends StatefulWidget {
  final String field;
  final String? initialValue;
  final Function onChange;
  final String? label;
  final String? hintText;
  final String? title;
  final Function? validateInput;

  final TextInputType? keyboardType;

  const TextFieldEdit(
      {super.key,
      required this.field,
      required this.onChange,
      this.hintText,
      this.validateInput,
      this.keyboardType,
      this.initialValue,
      this.title,
      required this.label});
  @override
  State<TextFieldEdit> createState() => _TextFieldEditState();
}

class _TextFieldEditState extends State<TextFieldEdit> {
  final TextEditingController controller = TextEditingController();
  bool errorText = false;
  String valueText = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleTextChanged(String value) async {
    if (value.isEmpty) {
      widget.onChange(widget.label);
      setState(() {
        errorText = false;
      });
    } else {
      EasyDebounce.debounce(
        'errorTextDebounce', // A unique identifier for the debounce
        const Duration(milliseconds: 500), // Debounce duration
        () async {
          setState(() {
            valueText = value;
          });
          if (widget.validateInput != null) {
            bool isValid = await widget.validateInput!(value);

            setState(() {
              errorText = isValid;
            });
          } else {
            setState(() {
              errorText = false;
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: AppBarTitle(title: widget.title ?? ""),
        ),
        body: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: errorText ? Colors.red : Colors.grey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: TextFormField(
                    maxLines: widget.field == 'description' ? 5 : 1,
                    initialValue: widget.initialValue,
                    onChanged: _handleTextChanged,
                    keyboardType: widget.keyboardType ?? TextInputType.text,
                    decoration: InputDecoration(
                      labelText: widget.label,
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.warning,
                          color: errorText ? Colors.red : Colors.transparent),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(widget.hintText ?? ""),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Divider(
                          height: 20,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: errorText || valueText == ""
                                    ? const ButtonPrimary(
                                        label: 'Lưu',
                                        handlePress: null,
                                        colorButton: Color(0xff808080),
                                      )
                                    : ButtonPrimary(
                                        label: 'Lưu',
                                        handlePress: () {
                                          widget.onChange(valueText);
                                          Navigator.pop(context);
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ButtonPrimary(
                                  label: 'Xoá, gỡ',
                                  isGrey: true,
                                  handlePress: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
