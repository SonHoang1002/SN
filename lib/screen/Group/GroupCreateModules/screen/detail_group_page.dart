import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/group_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/build_stage_navigation_bar_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import 'target_group_page.dart';

class DetailGroupPage extends StatefulWidget {
  const DetailGroupPage({super.key});

  @override
  State<DetailGroupPage> createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends State<DetailGroupPage> {
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
            children: [
              BackIconAppbar(),
              SizedBox(),
              GestureDetector(
                  onTap: () {
                    popToPreviousScreen(
                      context,
                    );
                  },
                  child: AppBarTitle(title: GroupConstants.CONTINUE_AFTER)),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                          DescriptionGroupConstants.TITLE[0],
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
                    Text(DescriptionGroupConstants.SUBTITLE[0],
                        style: const TextStyle(
                            // color:  white,
                            fontSize: 15)),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 120,
                      child: TextFormField(
                        // controller: namePageState.namePageModel.nameController,
                        onChanged: ((value) {}),
                        maxLines: 10,
                        style: const TextStyle(
                            // color:  white
                            ),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            hintText:
                                DescriptionGroupConstants.PLACEHOLDER_LIST[0],
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // bottom
            buildStageNavigatorBar(
                width: width,
                currentPage: 2,
                isPassCondition: true,
                title: GroupConstants.NEXT,
                function: () {
                  pushToNextScreen(context, TargetGroupPage());
                })
          ]),
        ));
  }
}
