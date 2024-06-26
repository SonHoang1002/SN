import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/providers/setting/choose_object_provider.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/see_your_share_modules/post_and_story_module/post_and_story_page.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/see_your_share_modules/who_see_share_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import '../../../../../../../widgets/GeneralWidget/content_and_status_widget.dart';
import '../../../../../../../widgets/GeneralWidget/text_content_widget.dart';

class InformationOnPersonalPagePage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  final String _selectedBottomNavigator = "Trang chủ";
  final listChooseObject = InformationOnPersonalPageConstants
      .INFORMATION_ON_PERSONAL_PAGE_CHOOSE_PHONE_STATUS
      .map((e) => e["title"])
      .toList();

  InformationOnPersonalPagePage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    // listChooseObject.forEach(
    //   (element) {
    //   },
    // );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            AppBarTitle(
                title: InformationOnPersonalPageConstants
                    .INFORMATION_ON_PERSONAL_PAGE_APPBAR_TITLE),
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
                      InformationOnPersonalPageConstants
                          .INFORMATION_ON_PERSONAL_PAGE_TITLE,
                      false),
                  // phone
                  buildContentAndStatusWidget(
                      InformationOnPersonalPageConstants
                          .INFORMATION_ON_PERSONAL_PAGE_PHONE["title"],
                      contents: InformationOnPersonalPageConstants
                          .INFORMATION_ON_PERSONAL_PAGE_PHONE["data"],
                      function: () {
                    _buildContentForBottomSheet(
                        context,
                        240,
                        "Chọn đối tượng",
                        InformationOnPersonalPageConstants
                            .INFORMATION_ON_PERSONAL_PAGE_CHOOSE_PHONE_STATUS);
                  }),
                  // email
                  buildContentAndStatusWidget(
                      InformationOnPersonalPageConstants
                          .INFORMATION_ON_PERSONAL_PAGE_EMAIL["title"],
                      contents: InformationOnPersonalPageConstants
                          .INFORMATION_ON_PERSONAL_PAGE_EMAIL["data"],
                      function: () {
                    _buildContentForBottomSheet(
                        context,
                        240,
                        "Chọn đối tượng",
                        InformationOnPersonalPageConstants
                            .INFORMATION_ON_PERSONAL_PAGE_CHOOSE_EMAIL_STATUS);
                  }),
                  // birthday 4
                  buildContentAndStatusWidget(
                      InformationOnPersonalPageConstants
                          .INFORMATION_ON_PERSONAL_PAGE_BIRTHDAY["title"],
                      contents: InformationOnPersonalPageConstants
                          .INFORMATION_ON_PERSONAL_PAGE_BIRTHDAY["data"],
                      function: () {
                    _buildContentForBottomSheet(
                        context,
                        270,
                        "Chọn đối tượng",
                        InformationOnPersonalPageConstants
                            .INFORMATION_ON_PERSONAL_PAGE_CHOOSE_BIRTHDAY_STATUS);
                  }),
                  // relationship 3
                  buildContentAndStatusWidget(
                      InformationOnPersonalPageConstants
                              .INFORMATION_ON_PERSONAL_PAGE_RELATIONSHIP_STATUS[
                          "title"],
                      contents: InformationOnPersonalPageConstants
                              .INFORMATION_ON_PERSONAL_PAGE_RELATIONSHIP_STATUS[
                          "data"], function: () {
                    _buildContentForBottomSheet(
                        context,
                        240,
                        "Chọn đối tượng",
                        InformationOnPersonalPageConstants
                            .INFORMATION_ON_PERSONAL_PAGE_CHOOSE_RELATIONSHIP_STATUS);
                  }),
                  buildContentAndStatusWidget(
                      InformationOnPersonalPageConstants
                          .INFORMATION_ON_PERSONAL_PAGE_PROVINCE["title"],
                      contents: InformationOnPersonalPageConstants
                          .INFORMATION_ON_PERSONAL_PAGE_PROVINCE["data"],
                      function: () {
                    _buildContentForBottomSheet(
                        context,
                        240,
                        "Chọn đối tượng",
                        InformationOnPersonalPageConstants
                            .INFORMATION_ON_PERSONAL_PAGE_CHOOSE_PROVINCE_STATUS);
                  }),
                  buildContentAndStatusWidget(
                      InformationOnPersonalPageConstants
                              .INFORMATION_ON_PERSONAL_PAGE_FRIEND_AND_FOLLOW[
                          "title"],
                      contents: InformationOnPersonalPageConstants
                              .INFORMATION_ON_PERSONAL_PAGE_FRIEND_AND_FOLLOW[
                          "data"], function: () {
                    _buildContentForBottomSheet(
                        context,
                        320,
                        "Chọn đối tượng",
                        InformationOnPersonalPageConstants
                            .INFORMATION_ON_PERSONAL_PAGE_CHOOSE_FRIEND_AND_FOLLOW_STATUS);
                  }),
                ],
              ),
            ),
          ),
          // navigator
          buildBottomNavigatorDotWidget(
              context, 3, 1, "Tiep tuc", PostAndStoryPage()),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}

_buildContentForBottomSheet(
  BuildContext context,
  double height,
  String title,
  dynamic data,
) {
  final listChoose = data.map((e) => e["key"]).toList();
  showCustomBottomSheet(context, height, title: "Chọn đối tượng",
      widget: StatefulBuilder(builder: (context, setStateFull) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: ((context, index) {
          return GeneralComponent(
            [
              buildTextContent(data[index]["title"], true),
              buildTextContent(
                data[index]["subTitle"], false,
                fontSize: 15,
                //  colorWord: Colors.grey
              )
            ],
            prefixWidget: Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(5),
              child: SvgPicture.asset(
                data[index]["icon"],
                //  color: Colors.white
              ),
            ),
            suffixWidget: SizedBox(
              height: 30,
              width: 30,
              child: Radio(
                  value: listChoose[index],
                  groupValue: Provider.of<ChooseObjectProvider>(
                    context,
                  ).getChooseObjectProvider,
                  onChanged: ((value) {
                    Provider.of<ChooseObjectProvider>(context, listen: false)
                        .setChooseObjectProvider(
                      value as String,
                    );
                    setStateFull(
                      () {},
                    );
                  })),
            ),
            padding: const EdgeInsets.all(5),
          );
        }));
  }));
}
