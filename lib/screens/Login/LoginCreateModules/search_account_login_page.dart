import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../helper/push_to_new_screen.dart';
import '../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../widgets/GeneralWidget/text_content_widget.dart';
import '../../../widgets/back_icon_appbar.dart';
import '../../../widgets/search_input.dart';
import 'confirm_login_page.dart';

class SearchAccountLoginPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  SearchAccountLoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            Expanded(
                child: SearchInput(
              handleSearchClick: () {
                pushToNextScreen(context, const ConfirmLoginPage());
              },
              title: "Số điện thoại hoặc email",
            ))
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          // main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: 80,
              ),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color:
                              Theme.of(context).textTheme.displayLarge?.color,
                          size: 17,
                        ),
                        buildSpacer(height: 15),
                        buildTextContent("Hãy tìm tài khoản của bạn", true,
                            fontSize: 17,
                            colorWord: Colors.purple,
                            isCenterLeft: false),
                        buildSpacer(height: 10),
                        buildTextContent(
                            "Vui lòng nhập số điện thoại hoặc email để tìm kiếm tài khoản của bạn",
                            false,
                            fontSize: 15,
                            colorWord: Colors.grey,
                            isCenterLeft: false)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
