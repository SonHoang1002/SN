
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/all_completed_page.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/how_find_you_modules/how_find_you_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class SearchToolPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  SearchToolPage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            AppBarTitle(title: SearchToolConstants.SEARCH_TOOL_APPBAR_TITLE),
            SizedBox(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: (() {
          FocusManager.instance.primaryFocus!.unfocus();
        }),
        child: Column(children: [
          // main content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              // color: Colors.grey[900],
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 5),
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  // title
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: SearchToolConstants.SEARCH_TOOL_TITLE.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: buildTextContent(
                          SearchToolConstants.SEARCH_TOOL_TITLE[index], false,
                          fontSize: 16,
                          //  colorWord: Colors.grey[200]
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 8,
                        child: buildTextContent(
                          SearchToolConstants.SEARCH_TOOL_LINK_PERSONAL_PAGE,
                          false,
                          fontSize: 16,
                          // colorWord: Colors.grey[200]
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: CupertinoSwitch(
                              value: true, onChanged: ((value) {})))
                    ],
                  )
                ],
              ),
            ),
          ),

          buildBottomNavigatorDotWidget(
              context,
              3,
              3,
              PhoneAndEmailConstants.ADD_FRIEND_REQUEST_NEXT,
              AllCompletedPage(name: "how_people_can_find_you_on_Emso")),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
