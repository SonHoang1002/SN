import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/page_constants.dart';
import 'package:social_network_app_mobile/providers/current_number_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreateModules/screen/settting_page_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/bottom_navigator_with_button_and_chip_widget.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class RequestFriends extends StatefulWidget {
  @override
  State<RequestFriends> createState() => _RequestFriendsState();
}

class _RequestFriendsState extends State<RequestFriends> {
  late double width = 0;
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
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                // color: Colors.pink,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Center(
                              child: Text(
                                RequestFriendPageConstants
                                    .FIRST_WORD_OF_PAGE_NAME,
                                style: TextStyle(
                                  fontSize: 20,
                                  // color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          RequestFriendPageConstants.TITLE_REQUEST[0],
                          style: const TextStyle(
                              // color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(RequestFriendPageConstants.TITLE_REQUEST[1],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                // color: Colors.white,
                                fontSize: 16)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          height: 30,
                          // color: Colors.red,
                          child: Center(
                            child: Stack(
                                children: RequestFriendPageConstants.LIST_DEMO
                                    .map((e) {
                              return Container(
                                margin: EdgeInsets.only(right: width * 0.25),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 23 * e),
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                        // color: Colors.white,
                                      ),
                                      child: Image.asset(
                                        RequestFriendPageConstants
                                                .IMG_PATH_LIST[
                                            int.parse(e.toStringAsFixed(0))],
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                              );
                            }).toList()),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(width * 0.285, 40),
                              backgroundColor: Colors.blue),
                          onPressed: () {},
                          child: Text(
                            RequestFriendPageConstants.TITLE_REQUEST[2],
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            buildBottomNavigatorWithButtonAndChipWidget(
                context: context,
                isPassCondition: true,
                width: width,
                newScreen: SettingsPage(),
                title: "Tiếp",
                currentPage: 6)
          ]),
        ));
  }
}
