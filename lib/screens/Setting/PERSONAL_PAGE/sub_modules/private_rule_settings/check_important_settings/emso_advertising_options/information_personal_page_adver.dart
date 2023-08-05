import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/bottom_navigator_dot_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import 'emso_advertising_options_constants.dart';
import 'interact_on_social_network.dart';

class InformationOnPersonalAdverPagePage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  InformationOnPersonalAdverPagePage({super.key});
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
            AppBarTitle(
                title: InformationOnPersonalAdverConstants
                    .INFORMATION_ON_Emso_ADVER_APPBAR_TITLE),
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
          _buildDivider(),
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
                    InformationOnPersonalAdverConstants
                        .INFORMATION_ON_Emso_ADVER_TITLE,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.grey[300]
                  ),
                  _buildDivider(),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: InformationOnPersonalAdverConstants
                        .INFORMATION_ON_Emso_ADVER_CONTENTS["data"].length,
                    itemBuilder: ((context, index) {
                      final data = InformationOnPersonalAdverConstants
                          .INFORMATION_ON_Emso_ADVER_CONTENTS["data"];
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Column(
                              children: [
                                GeneralComponent(
                                  [
                                    buildTextContent(data[index]['title'], true)
                                  ],
                                  suffixWidget: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Checkbox(
                                      value: true,
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  changeBackground: Colors.transparent,
                                ),
                                index == 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, bottom: 5),
                                        child: buildTextContent(
                                            data[index]["content"], false),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          _buildDivider()
                        ],
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GeneralComponent(
                      [
                        buildTextContent(
                          InformationOnPersonalAdverConstants
                              .INFORMATION_ON_Emso_TIP,
                          false,
                          fontSize: 16,
                          // colorWord: Colors.grey[300]
                        )
                      ],
                      prefixWidget: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(7),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: SvgPicture.asset(
                          "${SettingConstants.PATH_ICON}bell_icon.svg",
                          color: Colors.blue,
                        ),
                      ),
                      changeBackground: Colors.grey[300],
                    ),
                  )
                ],
              ),
            ),
          ),
          // navigator
          buildBottomNavigatorDotWidget(
              context, 3, 2, "Tiếp", InteractOnSocialNetworksPage()),
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}

_buildDivider() {
  return const Padding(
    padding: EdgeInsets.only(bottom: 0),
    child: Divider(
      height: 10,
      // color: Colors.white,
    ),
  );
}
