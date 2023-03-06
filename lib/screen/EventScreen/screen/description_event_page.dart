import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/event_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/EventScreen/screen/review_event_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/build_stage_navigation_bar.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class DescriptionEventPage extends StatelessWidget {
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
                  child: AppBarTitle(title: "Hủy")),
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
                          DescriptionEventConstants.DESCRIPTION_EVENT_TITLE,
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
                    Text(DescriptionEventConstants.DESCRIPTION_EVENT_SUBTITLE,
                        style: const TextStyle(
                            // color: Colors.grey,
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
                                DescriptionEventConstants.PLACEHOLDER_EVENT,
                            // labelText: DescriptionEventConstants.PLACEHOLDER_EVENT,
                            hintStyle: TextStyle(color: Colors.grey),
                            // labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            buildStageNavigatorBar(
                width: width,
                currentPage: 3,
                isPassCondition: true,
                title: EventConstants.NEXT,
                function: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ReviewEventPage()));
                })
          ]),
        ));
  }
}
