// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/Formik/lib/lo_form.dart';

import '../../../widgets/appbar_title.dart';

class TextFieldEdit extends StatefulWidget {
  final String field;
  final String? initialValue;
  final Function onChange;
  final String? label;
  final String? hintText;
  final String? title;
  final List<LoFieldBaseValidator<String>>? validators;
  final TextInputType? keyboardType;

  const TextFieldEdit(
      {super.key,
      required this.field,
      required this.onChange,
      this.hintText,
      this.keyboardType,
      this.initialValue,
      this.title,
      this.validators,
      required this.label});
  @override
  State<TextFieldEdit> createState() => _TextFieldEditState();
}

class _TextFieldEditState extends State<TextFieldEdit> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
          child: LoForm<String>(
            submittableWhen: (status) => status.isValid || status.isSubmitted,
            validators: [
              LoFormValidator(
                (values) {
                  widget.onChange(values[widget.field]);
                  return null;
                },
              ),
            ],
            onSubmit: (values, setErrors) async {
              return null;
            },
            builder: (form) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: LoTextField(
                      loKey: widget.field,
                      initialValue: widget.initialValue,
                      validators: widget.validators,
                      props: TextFieldProps(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          border: InputBorder.none,
                          labelText: widget.label,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
