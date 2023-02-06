import 'package:flutter/material.dart';

import '../../widget/back_icon_appbar.dart';
import '../../widget/search_input.dart';

class CreateSearchBaseMenu extends StatelessWidget {
  final String placeHolder;
  final Widget body;
  final Widget suffixWidget;

  const CreateSearchBaseMenu(
      {Key? key,
      required this.placeHolder,
      required this.body,
      required this.suffixWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            Expanded(
                child: SearchInput(
                  title: placeHolder,
              handleSearch: abc,
            )),
            suffixWidget
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: body,
    );
  }
}

abc() {}
