import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_bar_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import 'selection_default_constants.dart';

class SelectionDefaultObjectPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  SelectionDefaultObjectPage({super.key});
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
  /// chua lam tang tiep cua bajn be ngoai tru va ban be cu the
///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            BackIconAppbar(),
            AppBarTitle(
                title: SelectionDefaultObjectConstants
                    .SELECTION_DEFAULT_OBJECT_APPBAR_TITLE),
            SizedBox(),
          ],
        ),
      ),
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
                  _buildDivider(),
                  buildTextContent(
                      SelectionDefaultObjectConstants
                          .SELECTION_DEFAULT_OBJECT_DESCRIPTION,
                      false,
                      colorWord: Colors.grey[900],
                      fontSize: 14),
                  // selection object
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: buildTextContent(
                        SelectionDefaultObjectConstants
                            .SELECTION_DEFAULT_OBJECT_TITLE,
                        true,
                        fontSize: 18),
                  ),
                  _buildDivider(),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: SelectionDefaultObjectConstants
                          .SELECTION_DEFAULT_OBJECT_CONTENT["data"].length,
                      itemBuilder: ((context, index) {
                        final data = SelectionDefaultObjectConstants
                            .SELECTION_DEFAULT_OBJECT_CONTENT["data"];
                        return _buildSelectionComponent(
                          data[index]["icon"],
                          data[index]["title"],
                          data[index]["subTitle"],
                          iconData: data[index]["iconNext"] ?? null,
                        );
                      }))
                ],
              ),
            ),
          ),
          // navigator
          buildBottomNavigatorBarWidget(context)
        ]),
      ),
    );
  }
}

_buildDivider() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0, top: 5),
    child: Divider(
      height: 10,
      color: Colors.white,
    ),
  );
}

_buildSelectionComponent(String iconPath, String title, String subTitle,
    {IconData? iconData}) {
  return Container(
    // color: Colors.red,
    // padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                child: Radio(
                    value: true, groupValue: true, onChanged: ((value) {})),
              ),
              Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(10),
                child: SvgPicture.asset(
                  iconPath,
                  // color: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildTextContent(
                    title,
                    false,
                    fontSize: 16,
                    // colorWord: Colors.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  buildTextContent(subTitle, false,
                      colorWord: Colors.grey, fontSize: 14)
                ],
              ),
            ],
          ),
          iconData != null
              ? Container(
                  child: Icon(
                    iconData,
                    //  color: Colors.grey
                  ),
                )
              : SizedBox()
        ],
      ),
      _buildDivider()
    ]),
  );
}
