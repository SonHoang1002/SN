import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/group_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/group/select_target_group_provider.dart';
import 'package:social_network_app_mobile/screen/Group/GroupCreateModules/screen/create_post_group_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/build_stage_navigation_bar_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class TargetGroupPage extends StatefulWidget {
  @override
  State<TargetGroupPage> createState() => _TargetGroupPageState();
}

class _TargetGroupPageState extends State<TargetGroupPage> {
  late double width = 0;
  late double height = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              SizedBox(),
              AppBarTitle(title: GroupConstants.CONTINUE_AFTER),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Column(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                // color: Colors.black87,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          TargetGroupConstants.TITLE[0],
                          style: const TextStyle(
                              // color:  white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(TargetGroupConstants.SUBTITLE[0],
                        style: const TextStyle(
                            // color:  white,
                            fontSize: 15)),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 366,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return Container(
                                child: _buildFlexibleComponent(
                                    context,
                                    Icon(TargetGroupConstants
                                        .ICON_DATA_LIST[index]),
                                    [TargetGroupConstants.CONTENT_LIST[index]],
                                    Checkbox(
                                        value: Provider.of<
                                                    SelectTargetGroupProvider>(
                                                context,
                                                listen: false)
                                            .list[index],
                                        onChanged: (value) {
                                          List<bool> listSelected = Provider.of<
                                                      SelectTargetGroupProvider>(
                                                  context,
                                                  listen: false)
                                              .list;
                                          listSelected[index] =
                                              !listSelected[index];
                                          context
                                              .read<SelectTargetGroupProvider>()
                                              .setSelectTargetGroupProvider(
                                                  listSelected);
                                          setState(() {});
                                        })));
                          }),
                    )
                  ],
                ),
              ),
            ),
            // bottom
            buildStageNavigatorBar(
                width: width,
                currentPage: 3,
                isPassCondition: true,
                title: GroupConstants.NEXT,
                function: () {
                  pushToNextScreen(context, CreatePostGroupPage());
                })
          ]),
        ));
  }
}

Widget _buildFlexibleComponent(BuildContext context, Widget prefixWidget,
    List<String> listContent, Widget suffixWidget) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(right: 15),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.grey[300]),
            child: prefixWidget,
          ),
        ),
        Flexible(
          flex: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    margin: EdgeInsets.only(),
                    child: Text(listContent[0],
                        style: TextStyle(
                            // color:  white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              suffixWidget,
            ],
          ),
        ),
      ],
    ),
  );
}
