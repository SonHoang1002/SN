import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchInput extends StatefulWidget {
  final Function? handleSearch;
  final Function? handleUpdateFocus;

  const SearchInput({
    super.key,
    this.handleSearch,
    this.handleUpdateFocus,
  });

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
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
            controller: controller,
            onChanged: (value) {
              widget.handleSearch != null ? widget.handleSearch!(value) : () {};
            },
            cursorColor: Theme.of(context).textTheme.displayLarge?.color,
            decoration: InputDecoration(
                hintText: "Tìm kiếm",
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                prefixIcon: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: Theme.of(context).textTheme.displayLarge?.color,
                  size: 17,
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
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              shape: BoxShape.circle),
                          child: const Icon(
                            FontAwesomeIcons.xmark,
                            size: 15,
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
