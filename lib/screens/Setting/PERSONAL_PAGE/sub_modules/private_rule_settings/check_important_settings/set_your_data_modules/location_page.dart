// ApplicationAndWebsitePage

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/all_completed_page.dart';
import 'package:social_network_app_mobile/screens/Setting/PERSONAL_PAGE/sub_modules/private_rule_settings/check_important_settings/set_your_data_modules/set_your_data_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import '../../../../../../../widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import '../../../../../../../widgets/GeneralWidget/text_content_widget.dart';

class LocationPage extends StatelessWidget {
  late double width = 0;

  late double height = 0;

  LocationPage({super.key});
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
            AppBarTitle(title: LocationConstants.LOCATION_APPBAR_TITLE),
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
          const Padding(
            padding: EdgeInsets.all(5.0),
            child: Divider(
              height: 10,
              // color:  white,
            ),
          ),
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
                    LocationConstants.LOCATION_TITLE, false,
                    fontSize: 17,
                    //  colorWord: Colors.grey[300]
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Divider(
                      height: 10,
                      // color:  white,
                    ),
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount:
                          LocationConstants.LOCATION_CONTENTS["data"].length,
                      itemBuilder: ((context, index) {
                        final data =
                            LocationConstants.LOCATION_CONTENTS["data"];
                        return Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: GeneralComponent(
                            [
                              buildTextContent(data[index]["title"], true,
                                  // colorWord: Colors.grey[300],
                                  fontSize: 16),
                              const SizedBox(
                                height: 2,
                              ),
                              buildTextContent(data[index]["subTitle"], false,
                                  // colorWord: Colors.grey[300],
                                  fontSize: 16),
                            ],
                            changeBackground: Colors.grey[300],
                            padding: const EdgeInsets.all(5),
                          ),
                        );
                      })),

                  // button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          fixedSize: Size(width * 0.9, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          )),
                      onPressed: (() {}),
                      child: buildTextContent(
                          LocationConstants.LOCATION_GO_TO_SETTING, true,
                          fontSize: 17, isCenterLeft: false),
                    ),
                  ),

                  // tip
                  GeneralComponent(
                    [
                      buildTextContent(
                          LocationConstants.LOCATION_TIP["content"], false,
                          // colorWord: Colors.grey[300],
                          fontSize: 16)
                    ],
                    prefixWidget: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        LocationConstants.LOCATION_TIP["icon"],
                        color: Colors.blue,
                        // height: 40,
                      ),
                    ),
                    changeBackground: Colors.grey[300],
                    padding: const EdgeInsets.all(5),
                    borderRadiusValue: 7,
                  )
                ],
              ),
            ),
          ),

          buildBottomNavigatorDotWidget(
              context,
              2,
              2,
              LocationConstants.LOCATION_NEXT,
              AllCompletedPage(name: "how_people_can_find_you_on_Emso")),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}
