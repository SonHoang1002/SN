import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/see_your_share_modules/block_page.dart';

import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/see_your_share_modules/who_see_share_constants.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import '../../../../../../../../widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import '../../../../../../../../widgets/GeneralWidget/content_and_status_widget.dart';
import '../../../../../../../../widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import '../../../../../../../../widgets/GeneralWidget/text_content_widget.dart';

import 'selection_post_story/selection_default_object_page.dart';
import 'selection_post_story/rule_of_story_page.dart';

class PostAndStoryPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  String _selectedBottomNavigator = "Trang chủ";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            BackIconAppbar(),
            AppBarTitle(
                title: PostAndStoryConstants.POST_AND_STORY_APPBAR_TITLE),
            SizedBox(),
          ],
        ),
      ),
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
                  // title
                  buildTextContent(
                      PostAndStoryConstants.POST_AND_STORY_TITLE, false),
                  // default object
                  buildContentAndStatusWidget(
                      PostAndStoryConstants
                          .POST_AND_STORY_DEFAULT_OBJECT["title"],
                      contents: PostAndStoryConstants
                          .POST_AND_STORY_DEFAULT_OBJECT["data"], function: () {
                    pushToNextScreen(context, SelectionDefaultObjectPage());
                  }),
                  buildContentAndStatusWidget(
                      PostAndStoryConstants.POST_AND_STORY_STORY["title"],
                      contents: PostAndStoryConstants
                          .POST_AND_STORY_STORY["data"], function: () {
                    pushToNextScreen(
                        context, SelectionPrivateRuleOfStoryPage());
                  }),
                  buildContentAndStatusWidget(
                      PostAndStoryConstants
                          .POST_AND_STORY_OLD_STORY_LIMITATION["title"],
                      contents: PostAndStoryConstants
                          .POST_AND_STORY_OLD_STORY_LIMITATION["data"]),
                  ElevatedButton(
                    onPressed: () {
                      showCustomBottomSheet(context, 200,title: "Giới hạn tất cả ?",
                          widget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(children: [
                              buildTextContent(
                                  PostAndStoryConstants
                                      .POST_AND_STORY_LIMITATION_DESCRIPTION,
                                  false,
                                  colorWord: Colors.grey[300]),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                  "Giới hạn",
                                  style: TextStyle(
                                      // color: Colors.white,
                                      fontSize: 17),
                                ),
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(width, 40),
                                    backgroundColor: Colors.grey[400]),
                              )
                            ]),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 0.9, 40),
                        backgroundColor: Colors.grey[600]),
                    child: const Text(
                      "Giới hạn",
                      style: TextStyle(
                          // color: Colors.white,
                          fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          ),
          // navigator
          buildBottomNavigatorDotWidget(context, 3, 2, "Tiep tuc", BlockPage()),

          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
