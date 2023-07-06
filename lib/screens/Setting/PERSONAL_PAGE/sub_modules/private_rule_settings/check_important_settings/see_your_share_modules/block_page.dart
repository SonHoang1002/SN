import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../theme/colors.dart';
import '../../../../../../../widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import '../../../../../../../widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import '../../../../../../../widgets/GeneralWidget/general_component.dart';
import '../../../../../../../widgets/GeneralWidget/text_content_widget.dart';
import '../../../../../../../widgets/appbar_title.dart';
import '../../../../../../../widgets/back_icon_appbar.dart';
import '../../../../../setting_constants/general_settings_constants.dart';
import '../all_completed_page.dart';
import 'who_see_share_constants.dart';

class BlockPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  BlockPage({super.key});

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
            AppBarTitle(title: BlockConstants.BLOCK_APPBAR_TITLE),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: buildTextContent(BlockConstants.BLOCK_TITLE, false),
                  ),
                  // default object
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GeneralComponent(
                      [buildTextContent(BlockConstants.BLOCK_TIP, false)],
                      prefixWidget: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 10),
                          child: SvgPicture.asset(
                            BlockConstants.BLOCK_SEE_BLOCK_LIST["icon"],
                            color: Colors.blue,
                          )),
                      changeBackground: Colors.grey[300],
                    ),
                  ),
                  GeneralComponent(
                    [
                      Text(
                        BlockConstants.BLOCK_ADD_TO_BLOCK_LIST["title"],
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                    prefixWidget: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        margin: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                          BlockConstants.BLOCK_SEE_BLOCK_LIST["icon"],
                          color: Colors.blue,
                        )),
                    changeBackground: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GeneralComponent(
                    [
                      buildTextContent(
                          BlockConstants.BLOCK_SEE_BLOCK_LIST["title"], true),
                      buildTextContent(
                          "Bạn đã chặn ${BlockConstants.BLOCK_SEE_BLOCK_LIST["data"].length} người",
                          false),
                    ],
                    prefixWidget: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        margin: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                          BlockConstants.BLOCK_SEE_BLOCK_LIST["icon"],
                          color: Colors.blue,
                        )),
                    changeBackground: Colors.grey[300],
                  ),
                  //////////////////////////////////////////////////////////// xem danh sach chan thi hien ra component ben duoi //////////////////////////////////////////////
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: GeneralComponent(
                      [
                        buildTextContent("Nguyen Van A", false),
                      ],
                      prefixWidget: Container(
                          height: 40,
                          width: 40,
                          // padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              // color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset(
                            SettingConstants.PATH_IMG + "cat_1.png",
                            // color: Colors.blue,
                          )),
                      suffixWidget: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // fixedSize: Size(85, 30),
                            backgroundColor: Colors.blue),
                        onPressed: (() {}),
                        child: buildTextContent("Bo chan", true,
                            colorWord: white, fontSize: 15),
                      ),
                      suffixFlexValue: 10,
                      changeBackground: transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // navigator
          buildBottomNavigatorDotWidget(
              context,
              3,
              3,
              "Tiep tuc",
              AllCompletedPage(
                name: "who_can_see_what_you_share",
              )),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
