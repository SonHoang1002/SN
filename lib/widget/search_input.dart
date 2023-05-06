import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';

// ignore: must_be_immutable
class SearchInput extends StatefulWidget {
  final Function? handleSearch;
  final Function? handleUpdateFocus;
  final Function? handleSearchClick;
  final String? type;
  final String? initValue;

  String? title = "Tìm kiếm";

  SearchInput(
      {super.key,
      this.type,
      this.handleSearch,
      this.handleUpdateFocus,
      this.title,
      this.initValue,
      this.handleSearchClick});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController controller = TextEditingController();

  Timer? _debounce;

  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.handleSearch != null ? widget.handleSearch!(text) : () {};
    });
  }

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    controller.text = widget.initValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.only(top: 2, left: 5, bottom: 5),
        decoration: BoxDecoration(
            color: widget.type == postWatch
                ? Colors.black
                : Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
            focusNode: _focusNode,
            autofocus: true,
            controller: controller,
            onChanged: (value) {
              _onTextChanged(value);
            },
            cursorColor: Theme.of(context).textTheme.displayLarge?.color,
            decoration: InputDecoration(
                hintText: widget.title ?? 'Tìm kiếm',
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: widget.type == postWatch ? Colors.white : null),
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                prefixIcon: InkWell(
                  onTap: () {
                    widget.handleSearchClick != null
                        ? widget.handleSearchClick!()
                        : null;
                  },
                  child: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: widget.type == postWatch
                        ? Colors.white
                        : Theme.of(context).textTheme.displayLarge?.color,
                    size: 17,
                  ),
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          widget.handleSearch!('');
                          controller.clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                          child: Icon(
                            FontAwesomeIcons.xmark,
                            size: 15,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      )
                    : const SizedBox())));
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _debounce?.cancel();
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
