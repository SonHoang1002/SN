import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../constant/group_constants.dart';
import '../../../../providers/group/hide_group_provider.dart';
import '../../../../theme/colors.dart';
import '../../../../widgets/GeneralWidget/general_component.dart';
import '../../../../widgets/GeneralWidget/spacer_widget.dart';
import '../../../../widgets/appbar_title.dart';
import '../widgets/additional_information_request_friend.dart';
import '../widgets/addtional_information_group_widget.dart';
import 'cover_image_group_page.dart';

class RequestFriendsGroupPage extends StatefulWidget {
  const RequestFriendsGroupPage({super.key});

  @override
  State<RequestFriendsGroupPage> createState() =>
      _RequestFriendsGroupPageState();
}

class _RequestFriendsGroupPageState extends State<RequestFriendsGroupPage> {
  late double width = 0;
  late double height = 0;
  late bool isSuggestSelection = true;
  late bool isLocationSelection = false;
  late bool isGeneralGroupSelection = false;

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
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              AppBarTitle(title: RequestFriendsGroupConstants.TITLE_APPBAR),
              SizedBox(),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: ListView(children: [
            Expanded(
              child: Container(
                // color: Colors.black87,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: [
////////////////////////////////// public and private unhide group /////////////////////////////////////

                      Provider.of<HideGroupProvider>(context, listen: false)
                                  .selection !=
                              "Đã ẩn"
                          ? Column(
                              children: [
                                // build share widget
                                GeneralComponent(
                                  const [
                                    Text(
                                      "Chia sẻ",
                                      style: TextStyle(
                                          // color:  white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                  padding: EdgeInsets.zero,
                                  prefixWidget: GestureDetector(
                                    onTap: (() {
                                      _showBottomSheetForShareComponent(
                                          context);
                                    }),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 10),
                                      // padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Colors.grey[300]),
                                      child: const Icon(
                                        FontAwesomeIcons.share,
                                        // color:  white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  changeBackground: transparent,
                                ),
                                buildSpacer(
                                  height: 5,
                                ),
                                // build email widget
                                GeneralComponent(
                                  [
                                    const Text(
                                      RequestFriendsGroupConstants
                                          .EMAIL_REQUEST_TITLE,
                                      style: TextStyle(
                                          // color:  white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(),
                                      child: const Text(
                                          RequestFriendsGroupConstants
                                              .EMAIL_REQUEST_SUBTITLE,
                                          style: TextStyle(
                                              // color:  white,
                                              fontSize: 13)),
                                    ),
                                  ],
                                  padding: EdgeInsets.zero,
                                  prefixWidget: GestureDetector(
                                    onTap: () {
                                      _showBottomSheetForRequestFriendByEmail(
                                          context, height);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 10),

                                      // padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Colors.grey[300]),
                                      child: const Icon(
                                        FontAwesomeIcons.envelope,
                                        // color:  white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  changeBackground: transparent,
                                ),
                                buildSpacer(
                                  height: 10,
                                ),

                                //suggest example, include suggest, location, general group
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            isSuggestSelection = true;
                                            isGeneralGroupSelection = false;
                                            isLocationSelection = false;
                                          });
                                        }),
                                        child: _buildExampleComponent(
                                            "Gợi ý", isSuggestSelection),
                                      ),
                                      GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            isSuggestSelection = false;
                                            isGeneralGroupSelection = false;
                                            isLocationSelection = true;
                                          });
                                        }),
                                        child: _buildExampleComponent(
                                            'Hà Nội', isLocationSelection,
                                            icon: FontAwesomeIcons.city),
                                      ),
                                      GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            isSuggestSelection = false;
                                            isGeneralGroupSelection = true;
                                            isLocationSelection = false;
                                          });
                                        }),
                                        child: _buildExampleComponent(
                                            'Nhóm chung',
                                            isGeneralGroupSelection,
                                            icon: FontAwesomeIcons.peopleGroup),
                                      )
                                    ],
                                  ),
                                ),
                                isLocationSelection
                                    ? const AdditionalInformationForSelectionOfRequestFriendWidget(
                                        title: "Hà Nội",
                                        subTile:
                                            "Bạn bè sống cùng tỉnh/ thành phố với bạn")
                                    : Container(),
                                isGeneralGroupSelection
                                    ? Column(
                                        children: [
                                          const AdditionalInformationForSelectionOfRequestFriendWidget(
                                              title: "Nhóm chung",
                                              subTile:
                                                  "Lọc theo bạn bè ở chung nhóm với bạn"),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: ElevatedButton(
                                                onPressed: (() {
                                                  _showBottomSheetSelectionGroupForRequestFriend(
                                                      context, width);
                                                }),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                        "Đã chọn 0 nhóm"),
                                                    Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 5),
                                                        child: const Icon(
                                                            FontAwesomeIcons
                                                                .caretDown,
                                                            size: 14,
                                                            color: white)),
                                                  ],
                                                )),
                                          )
                                        ],
                                      )
                                    : Container()
                              ],
                            )

////////////////////////////////// private and hide group /////////////////////////////////////
                          : Column(
                              children: [
                                // build email widget
                                GeneralComponent(
                                  [
                                    const Text(
                                      RequestFriendsGroupConstants
                                          .EMAIL_REQUEST_TITLE,
                                      style: TextStyle(
                                          // color:  white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(),
                                      child: const Text(
                                          RequestFriendsGroupConstants
                                              .EMAIL_REQUEST_SUBTITLE,
                                          style: TextStyle(
                                              // color:  white,
                                              fontSize: 13)),
                                    ),
                                  ],
                                  prefixWidget: Container(
                                    height: 40,
                                    width: 40,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    // padding: const EdgeInsets.all(10),
                                    child: const Icon(
                                      FontAwesomeIcons.envelope,
                                      color: white,
                                      // size: 17,
                                    ),
                                  ),
                                  changeBackground: transparent,
                                ),
                                buildSpacer(
                                  height: 10,
                                ),
                                // request friend title 1
                                Row(
                                  children: [
                                    Text(
                                      RequestFriendsGroupConstants
                                          .PRIVATE_TITLE[0],
                                      style: const TextStyle(
                                          // color:  white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                buildSpacer(
                                  height: 10,
                                ),
                                // request friend subtitle
                                Text(
                                    RequestFriendsGroupConstants
                                        .PRIVATE_SUB_TITLE[0],
                                    style: const TextStyle(
                                        // color:  white,
                                        fontSize: 21)),
                                buildSpacer(
                                  height: 20,
                                ),
                                // request friend title 2
                                Row(
                                  children: [
                                    Text(
                                      RequestFriendsGroupConstants
                                          .PRIVATE_TITLE[1],
                                      style: const TextStyle(
                                          // color:  white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                buildSpacer(
                                  height: 10,
                                ),
                                // request friend subtitle 2
                                Text(
                                    RequestFriendsGroupConstants
                                        .PRIVATE_SUB_TITLE[1],
                                    style: const TextStyle(
                                        // color:  white,
                                        fontSize: 16)),
                                buildSpacer(
                                  height: 16,
                                ),
                                // share link
                                AddtionalInformationGroupWidget(
                                  contentWidget: [
                                    RichText(
                                        text: const TextSpan(children: [
                                      TextSpan(
                                          text: RequestFriendsGroupConstants
                                              .PRIVATE_LINK_EXAMPLE,
                                          style: TextStyle(
                                              // color: Colors.grey[400],
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ])),
                                    buildSpacer(
                                      height: 10,
                                    ),
                                    RichText(
                                        text: const TextSpan(children: [
                                      TextSpan(
                                          text: RequestFriendsGroupConstants
                                              .PRIVATE_DESCRIPTION_FOR_LINK_EXAMPLE,
                                          style: TextStyle(
                                            // color: Colors.grey[400],
                                            fontSize: 13,
                                          )),
                                    ])),
                                  ],
                                  prefixWidget: GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(const ClipboardData(
                                          text: RequestFriendsGroupConstants
                                              .PRIVATE_LINK_EXAMPLE));
                                    },
                                    child: Container(
                                      height: 75,
                                      padding: const EdgeInsets.only(
                                        right: 10,
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.link,
                                            color: white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),

/////////////////////////////////////////////////////  GENERAL ///////////////////////////////////////////////////
                      // search
                      SizedBox(
                        height: 35,
                        child: TextFormField(
                          onChanged: ((value) {}),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              // color:  white
                              ),
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FontAwesomeIcons.search,
                                color: Colors.grey,
                                size: 13,
                              ),
                              // fillColor: Colors.grey[800],
                              // filled: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              hintText: RequestFriendsGroupConstants
                                  .PLACEHOLDER_LIST[0],
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(17)))),
                        ),
                      ),
                      buildSpacer(
                        height: 10,
                      ),
                      // build friend listview
                      Row(
                        children: [
                          Text(
                            RequestFriendsGroupConstants.PUBLIC_TITLE[3],
                            style: const TextStyle(
                                // color:  white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      buildSpacer(
                        height: 10,
                      ),
                      // friend listView
                      Container(
                        child: isGeneralGroupSelection
                            ? SizedBox(
                                height: 300,
                                child: Column(children: [
                                  Container(
                                    height: 100,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Image.asset(
                                        "${GroupConstants.PATH_IMG}cat_1.png",
                                        fit: BoxFit.fitWidth),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: const Text(
                                      "Không tìm thấy kết quả nào",
                                      style: TextStyle(
                                          // color:  white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: const Text(
                                      "Thử tìm tên khác",
                                      style: TextStyle(
                                        // color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]),
                              )
                            : SizedBox(
                                height: 400,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: 7,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          // margin: EdgeInsets.symmetric(vertical: 5),
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 5),
                                        child: GeneralComponent(
                                          [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  // color: Colors.red,
                                                  width: 200,
                                                  child: Text(
                                                    "People $index",
                                                    style: const TextStyle(
                                                        // color:  white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          // fixedSize: Size(200, 40),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              side:
                                                                  const BorderSide())),
                                                  onPressed: () {},
                                                  child: const Center(
                                                    child: Text(
                                                      "Mời",
                                                      style: TextStyle(
                                                          color: white,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                          prefixWidget: Container(
                                              height: 40,
                                              width: 40,
                                              margin: const EdgeInsets.only(
                                                  right: 10),

                                              // padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  color: Colors.grey[800]),
                                              child: Image.asset(
                                                  RequestFriendsGroupConstants
                                                      .IMG_PATH_LIST[index])),
                                          padding: EdgeInsets.zero,
                                          changeBackground: transparent,
                                        ),
                                      ));
                                    }),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            /// bottom
            SizedBox(
              height: 70,
              // color: Colors.black87,
              child: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 0.9, 40),
                        backgroundColor: Colors.orange),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CoverImageGroupPage()));
                    },
                    child: const Text(GroupConstants.NEXT)),
              ),
            )
          ]),
        ));
  }
}

_showBottomSheetForShareComponent(BuildContext context) {
  showModalBottomSheet(
      backgroundColor: transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 230,
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          child: Column(children: [
            // drag and drop navbar
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                height: 4,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
              ),
            ),
            // title
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: (() {
                        Navigator.of(context).pop();
                        FocusManager.instance.primaryFocus!.unfocus();
                      }),
                      child: Icon(
                        Icons.close,
                        color: white,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: Container(
                        child: const Center(
                      child: Text(
                        "Chia sẻ",
                        style: TextStyle(color: white, fontSize: 18),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            // divider
            const Divider(
              height: 4,
              color: white,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              // height: 100,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: RequestFriendsGroupConstants
                      .SHARE_BOTTOM_SHEET_CONTENT_LIST.length,
                  itemBuilder: ((context, index) {
                    return GeneralComponent(
                      [
                        Text(
                          RequestFriendsGroupConstants
                              .SHARE_BOTTOM_SHEET_CONTENT_LIST[index][1],
                          style: const TextStyle(
                              color: white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                      prefixWidget: Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(right: 10),

                        // padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.grey[800]),
                        child: Icon(
                          RequestFriendsGroupConstants
                              .SHARE_BOTTOM_SHEET_CONTENT_LIST[index][0],
                          color: white,
                          size: 14,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      // changeBackground: transparent,
                    );
                  })),
            )
          ]),
        );
      });
}

// tạo ra thành phần gồm prefix, nội dung, suffix
Widget _buildExampleComponent(String title, bool isSelected, {IconData? icon}) {
  return Flex(
    direction: Axis.horizontal,
    children: [
      Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
        height: 35,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: isSelected ? Colors.blue : Colors.grey[800]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null
                ? Row(
                    children: [
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: Center(
                            child: Icon(
                          icon,
                          size: 13,
                          color: white,
                        )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                : Container(),
            Text(
              title,
              style: const TextStyle(
                color: white,
                fontSize: 13,
              ),
            )
          ],
        ),
      )
    ],
  );
}

_showBottomSheetSelectionGroupForRequestFriend(
    BuildContext context, double width) {
  showModalBottomSheet(
      backgroundColor: transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 460,
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                height: 4,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: const Center(
                    child: Text(
                      "Nhóm của bạn",
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                  )),
                ],
              ),
            ),
            //divider
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: const Divider(
                height: 2,
                color: white,
              ),
            ),
            // content listView

            Expanded(
              child: ListView.builder(
                  itemCount: RequestFriendsGroupConstants
                      .SELECTION_FOR_CHOOSE_GROUP_GROUP.length,
                  itemBuilder: ((context1, index) {
                    return GeneralComponent(
                      [
                        Text(
                          RequestFriendsGroupConstants
                              .SELECTION_FOR_CHOOSE_GROUP_GROUP[index][1],
                          style: const TextStyle(
                              color: white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          RequestFriendsGroupConstants
                              .SELECTION_FOR_CHOOSE_GROUP_GROUP[index][2],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                      prefixWidget: Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Image.asset(
                          RequestFriendsGroupConstants
                              .SELECTION_FOR_CHOOSE_GROUP_GROUP[index][0],
                        ),
                      ),
                      suffixWidget: Container(
                        // height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 7),
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: const Center(
                          child: Text(
                            "Thêm",
                            style: TextStyle(color: white, fontSize: 15),
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                    );
                  })),
            ),
          ]),
        );
      });
}

_showBottomSheetForRequestFriendByEmail(BuildContext context, double height) {
  showModalBottomSheet(
      backgroundColor: transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: height,
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                height: 4,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
              ),
            ),
            // title
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (() {
                      Navigator.of(context).pop();
                      FocusManager.instance.primaryFocus!.unfocus();
                    }),
                    child: const Icon(
                      Icons.close,
                      color: white,
                    ),
                  ),
                  Container(
                      child: const Center(
                    child: Text(
                      "Chia sẻ",
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                  )),
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Center(
                        child: Text(
                          "Gửi",
                          style: TextStyle(color: white, fontSize: 18),
                        ),
                      )),
                ],
              ),
            ),
            // divider
            const Divider(
              height: 4,
              color: white,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(
                      bottom: 5,
                    ),
                    child: const Center(
                      child: Text(
                        "Nhập địa chỉ email để mời ai đó",
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 80,
              child: TextFormField(
                onChanged: ((value) {}),
                style: const TextStyle(color: white),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    hintText: "Địa chỉ Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            GeneralComponent(
              const [
                Text(
                  "Tin nhắn mới",
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
                Text(
                  "Xin chào! Mời bạn tham gia nhóm của tôi nhé. Bạn có thể tham gia qua liên kết trong email này!",
                  style: TextStyle(color: white, fontSize: 17),
                ),
              ],
              changeBackground: Colors.grey[800],
            )
          ]),
        );
      });
}
