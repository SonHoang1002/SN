import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings_modules/private_rule_shortcut_modules/check_important_settings_modules/who_can_see_what_you_share_modules/block_page.dart';
import 'package:social_network_app_mobile/screen/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import '../../../../../../../../../widget/GeneralWidget/bottom_navigator_bar_widget.dart';
import '../../../../../../../../../widget/GeneralWidget/content_and_status_widget.dart';
import '../../../../../../../../../widget/GeneralWidget/show_bottom_sheet_widget.dart';
import '../../../../../../../../../widget/GeneralWidget/text_content_widget.dart';
import '../who_can_see_what_you_share_commons.dart';
import 'selection_for_post_and_story_modules/selection_default_object_page.dart';
import 'selection_for_post_and_story_modules/selection_private_rule_of_story_page.dart';

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
            AppBarTitle(title: PostAndStoryCommons.POST_AND_STORY_APPBAR_TITLE),
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
                padding: EdgeInsets.symmetric(vertical: 5),
                children: [
                  // title
                  buildTextContent(
                      PostAndStoryCommons.POST_AND_STORY_TITLE, false),
                  // default object
                  buildContentAndStatusWidget(
                      PostAndStoryCommons
                          .POST_AND_STORY_DEFAULT_OBJECT["title"],
                      contents: PostAndStoryCommons
                          .POST_AND_STORY_DEFAULT_OBJECT["data"], function: () {
                    pushToNextScreen(context, SelectionDefaultObjectPage());
                  }),
                  buildContentAndStatusWidget(
                      PostAndStoryCommons.POST_AND_STORY_STORY["title"],
                      contents: PostAndStoryCommons
                          .POST_AND_STORY_STORY["data"], function: () {
                    pushToNextScreen(
                        context, SelectionPrivateRuleOfStoryPage());
                  }),
                  buildContentAndStatusWidget(
                      PostAndStoryCommons
                          .POST_AND_STORY_OLD_STORY_LIMITATION["title"],
                      contents: PostAndStoryCommons
                          .POST_AND_STORY_OLD_STORY_LIMITATION["data"]),
                  ElevatedButton(
                    onPressed: () {
                      showBottomSheetCheckImportantSettings(
                          context, 200, "Giới hạn tất cả ?",
                          widget: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(children: [
                              buildTextContent(
                                  PostAndStoryCommons
                                      .POST_AND_STORY_LIMITATION_DESCRIPTION,
                                  false),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Giới hạn",
                                  style: TextStyle(
                                      // color: Colors.white,
                                      fontSize: 17),
                                ),
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(width, 40),
                                    backgroundColor: Colors.grey[800]),
                              )
                            ]),
                          ));
                    },
                    child: Text(
                      "Giới hạn",
                      style: TextStyle(
                          // color: Colors.white,
                          fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 0.9, 40),
                        backgroundColor: Colors.grey[600]),
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
