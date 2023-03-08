import 'package:flutter/material.dart';

import 'package:social_network_app_mobile/constant/page_constants.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_button_chip.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double width = 0;
  List<bool> listSwitch = [false, false];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
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
                // color: Colors.black87,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            SettingsPageConstants.TITLE_SETTINGS[0],
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
                      //description
                      Text(SettingsPageConstants.TITLE_SETTINGS[1],
                          style: const TextStyle(
                              // color:  white,
                              fontSize: 17)),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children:
                            SettingsPageConstants.COUNTER_CONTENT.map((index) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(children: [
                              Flexible(
                                flex: 8,
                                child: Column(children: [
                                  // content title
                                  Wrap(
                                    children: [
                                      Text(
                                        SettingsPageConstants
                                            .TITLE_CONTENT[index],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            // color:  white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // content subtitle
                                  Text(
                                      SettingsPageConstants
                                          .SUBTITLE_CONTENT[index],
                                      style: TextStyle(
                                          // color: Colors.grey,
                                          fontSize: 15)),
                                ]),
                              ),
                              Flexible(
                                  flex: 2,
                                  child: Switch(
                                    value: listSwitch[index],
                                    onChanged: ((value) {
                                      setState(() {
                                        listSwitch[index] = !listSwitch[index];
                                      });
                                    }),
                                  )),
                            ]),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            buildBottomNavigatorWithButtonAndChipWidget(
                context: context,
                width: width,
                // newScreen: SizedBox(),
                isPassCondition: true,
                title: "Xong",
                currentPage: 7)
          ]),
        ));
  }
}
