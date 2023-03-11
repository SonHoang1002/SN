import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/colors.dart';

class SearchInput extends StatefulWidget {
  final Function? handleSearch;
  final Function? handleUpdateFocus;
  final Function? handleSearchClick;
  String? title = "Tìm kiếm";

  SearchInput(
      {super.key,
      this.handleSearch,
      this.handleUpdateFocus,
      this.title,
      this.handleSearchClick});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.only(top: 2, left: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(width: 0.2, color: greyColor),
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
            controller: controller,
            onChanged: (value) {
              widget.handleSearch != null ? widget.handleSearch!(value) : () {};
            },
            cursorColor: Theme.of(context).textTheme.displayLarge?.color,
            decoration: InputDecoration(
                hintText: widget.title ?? 'Tìm kiếm', 
                hintStyle: const TextStyle(fontSize: 13),
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
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    size: 17,
                  ),
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          widget.handleSearch!('');
                          controller.clear();
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              color: transparent, shape: BoxShape.circle),
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
    controller.dispose();
    super.dispose();
  }
}
