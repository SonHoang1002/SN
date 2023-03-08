import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/providers/group/select_private_rule_provider.dart';

import '../../../../constant/group_constants.dart';
import '../../../../helper/push_to_new_screen.dart';
import '../../../../providers/group/hide_group_provider.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/build_stage_navigation_bar.dart';
import '../../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../../widget/appbar_title.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../widgets/addtional_information_group_widget.dart';
import 'request_friends_group_page.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  State<CreateGroupPage> createState() => CreateGroupPageState();
}

class CreateGroupPageState extends State<CreateGroupPage> {
  late double width = 0;
  late String selectPrivateRule = "";
  late TextEditingController _nameController = TextEditingController(text: "");
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
              AppBarTitle(title: CreateGroupConstants.TITLE_APPBAR),
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
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: [
                      // name title
                      Row(
                        children: [
                          Text(
                            CreateGroupConstants.TITLE_LIST[0],
                            style: const TextStyle(
                                // color:  white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // space
                      buildSpacer(
                        height: 10,
                      ),
                      // name input
                      Container(
                        height: 80,
                        child: TextFormField(
                          controller: _nameController,
                          onChanged: ((value) {}),
                          style: const TextStyle(
                              // color:  white
                              ),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    // color: Colors.grey,
                                    width: 0.2),
                              ),
                              hintText:
                                  CreateGroupConstants.PLACEHOLDER_LIST[0],
                              hintStyle: TextStyle(
                                  // color: Colors.grey
                                  ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      // divider
                      Divider(
                        height: 3,
                        color: Colors.grey[800],
                      ),
                      //space
                      buildSpacer(
                        height: 10,
                      ),
                      // private title
                      Row(
                        children: [
                          Text(
                            CreateGroupConstants.TITLE_LIST[1],
                            style: const TextStyle(
                                // color:  white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // space
                      buildSpacer(
                        height: 10,
                      ),
                      // private input
                      Provider.of<SelectionPrivateGroupProvider>(context,
                                      listen: false)
                                  .selection !=
                              ""
                          ? buildFillInput(
                              context: context,
                              iconData:
                                  Provider.of<SelectionPrivateGroupProvider>(
                                                  context)
                                              .selection ==
                                          "Công khai"
                                      ? FontAwesomeIcons.earthAmericas
                                      : FontAwesomeIcons.lock,
                              title: CreateGroupConstants.TITLE_LIST[1],
                              function: () {
                                bottomSheetPrivateRule(context);
                              },
                              content:
                                  Provider.of<SelectionPrivateGroupProvider>(
                                          context)
                                      .selection)
                          : buildFillInput(
                              context: context,
                              title: CreateGroupConstants.PLACEHOLDER_LIST[1],
                              function: () {
                                bottomSheetPrivateRule(context);
                              }),
                      // space
                      buildSpacer(
                        height: 10,
                      ),
                      Provider.of<SelectionPrivateGroupProvider>(context,
                                      listen: false)
                                  .selection ==
                              "Công khai"
                          ? Container(
                              child: AddtionalInformationGroupWidget(
                                  contentWidget: [
                                  Text(
                                    CreateGroupConstants.DEFEND_PUBLIC_RULE[0],
                                    style: TextStyle(
                                        // color: Colors.grey[400],
                                        fontSize: 16),
                                  ),
                                ]))
                          : Container(),
                      Provider.of<SelectionPrivateGroupProvider>(context,
                                      listen: false)
                                  .selection ==
                              "Riêng tư"
                          // hide group component
                          ? Column(
                              children: [
                                // additinal description for private rule
                                AddtionalInformationGroupWidget(contentWidget: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: CreateGroupConstants
                                            .DEFEND_PRIVATE_RULE[0],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        )),
                                    TextSpan(
                                        text: CreateGroupConstants
                                            .DEFEND_PRIVATE_RULE[1],
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ])),
                                ]),
                                buildSpacer(height: 20),
                                //divider
                                Divider(
                                  height: 3,
                                  color: Colors.black,
                                ),
                                // space
                                buildSpacer(height: 10),
                                // hide group title
                                Row(
                                  children: [
                                    Text(
                                      CreateGroupConstants.TITLE_LIST[2],
                                      style: const TextStyle(
                                          // color:  white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                buildSpacer(height: 10),

                                // hide group input
                                buildFillInput(
                                    context: context,
                                    iconData: Provider.of<HideGroupProvider>(
                                                    context,
                                                    listen: false)
                                                .selection ==
                                            "Hiển thị"
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    title: CreateGroupConstants.TITLE_LIST[2],
                                    function: () {
                                      bottomSheetHideGroup(context);
                                    },
                                    content: Provider.of<HideGroupProvider>(
                                            context,
                                            listen: false)
                                        .selection),
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
            // bottom
            buildStageNavigatorBar(
                width: width,
                currentPage: 3,
                isPassCondition: (Provider.of<SelectionPrivateGroupProvider>(
                                context,
                                listen: false)
                            .selection !=
                        "" &&
                    _nameController.text.trim() != ""),
                title: GroupConstants.CREATE_GROUP,
                isHaveStageNavigatorBar: false,
                function: () {
                  if (Provider.of<SelectionPrivateGroupProvider>(context,
                              listen: false)
                          .selection ==
                      "Công khai") {
                    Provider.of<HideGroupProvider>(context, listen: false)
                        .setHideGroupProvider("Hiển thị");
                  }

                  if (Provider.of<SelectionPrivateGroupProvider>(context,
                                  listen: false)
                              .selection !=
                          "" &&
                      _nameController.text.trim() != "") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => RequestFriendsGroupPage()));
                  }
                }),
          ]),
        ));
  }

  Widget buildSelectionInput(
      BuildContext context,
      IconData iconData,
      String title,
      String content,
      String groupValueForRadio,
      String valueForRadio) {
    return GestureDetector(
      onTap: (() {}),
      child: StatefulBuilder(builder: (context, setStateFull) {
        return GestureDetector(
          onTap: () {
            popToPreviousScreen(context);
            switch (title) {
              case "Công khai":
                Provider.of<SelectionPrivateGroupProvider>(context,
                        listen: false)
                    .setSelectionPrivateGroupProvider("Công khai");
                break;
              case "Riêng tư":
                Provider.of<SelectionPrivateGroupProvider>(context,
                        listen: false)
                    .setSelectionPrivateGroupProvider("Riêng tư");
                break;
              case "Hiển thị":
                Provider.of<HideGroupProvider>(context, listen: false)
                    .setHideGroupProvider("Hiển thị");
                break;
              case "Đã ẩn":
                Provider.of<HideGroupProvider>(context, listen: false)
                    .setHideGroupProvider("Đã ẩn");

                break;
            }
            setStateFull(() {});
            setState(() {});
            return;
          },
          child: Container(
            // height: 60,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.grey[700]),
                    child: Icon(
                      iconData,
                      color: white,
                      size: 14,
                    ),
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(title,
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Text(content,
                                  style: TextStyle(color: white, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Radio(
                            value: valueForRadio,
                            groupValue: groupValueForRadio,
                            onChanged: (value) {}),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildFillInput(
      {required BuildContext context,
      IconData? iconData,
      required String title,
      String? content,
      Function? function}) {
    return InkWell(
      onTap: (() {
        function != null ? function() : null;
      }),
      child: Container(
        height: iconData == null ? 60 : null,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            border: Border.all(color: Colors.purple, width: 0.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GeneralComponent(
              [
                buildTextContent(title, false,
                    colorWord: Colors.grey, fontSize: 16),
                content != null
                    ? buildTextContent(content, true,
                        colorWord: Colors.black, fontSize: 16)
                    : Container()
              ],
              suffixWidget: Icon(
                FontAwesomeIcons.caretDown,
                color: Colors.grey[800],
              ),
              prefixWidget: iconData != null
                  ? Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Colors.grey[800]),
                      child: Icon(
                        iconData,
                        color: white,
                        size: 14,
                      ),
                    )
                  : null,
              changeBackground: transparent,
              borderRadiusValue: 5,
              function: () {
                function != null ? function() : null;
              },
            ),
          ],
        ),
      ),
    );
  }

  bottomSheetPrivateRule(context) {
    print("bottomSheetPrivateRule");
    showModalBottomSheet(
        backgroundColor: transparent,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 220,
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Column(children: [
              // drag and drop navbar
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                ),
              ),
              // title
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  children: [
                    Flexible(
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
                      flex: 2,
                    ),
                    Flexible(
                      flex: 10,
                      child: Container(
                          child: Center(
                        child: Text(
                          "Chọn quyền riêng tư",
                          style: TextStyle(color: white, fontSize: 18),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
              // divider
              Divider(
                height: 4,
                color: white,
              ),
              buildSpacer(
                height: 10,
              ),
              buildSelectionInput(
                context,
                FontAwesomeIcons.earthAmericas,
                "Công khai",
                "Bất kỳ ai cũng có thể nhìn thấy mọi người trong nhóm và những gì họ đăng.",
                Provider.of<SelectionPrivateGroupProvider>(context,
                        listen: false)
                    .selection,
                "Công khai",
              ),
              buildSelectionInput(
                context,
                FontAwesomeIcons.lock,
                "Riêng tư",
                "Chỉ thành viên mới nhìn thấy mọi người trong nhóm và những gì họ đăng.",
                Provider.of<SelectionPrivateGroupProvider>(context,
                        listen: false)
                    .selection,
                "Riêng tư",
              )
            ]),
          );
        });
  }

  bottomSheetHideGroup(context) {
    showModalBottomSheet(
        backgroundColor: transparent,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 220,
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Column(children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  children: [
                    Flexible(
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
                      flex: 2,
                    ),
                    Flexible(
                      flex: 10,
                      child: Container(
                          child: Center(
                        child: Text(
                          "Ẩn nhóm",
                          style: TextStyle(color: white, fontSize: 18),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 4,
                color: white,
              ),
              buildSpacer(
                height: 10,
              ),
              buildSelectionInput(
                context,
                FontAwesomeIcons.eye,
                "Hiển thị",
                "Ai cũng có thể nhìn thấy nhóm này",
                Provider.of<HideGroupProvider>(context, listen: false)
                    .selection,
                "Hiển thị",
              ),
              buildSelectionInput(
                context,
                FontAwesomeIcons.eyeSlash,
                "Đã ẩn",
                "Chỉ thành viên mới nhìn tháy nhóm này",
                Provider.of<HideGroupProvider>(context, listen: false)
                    .selection,
                "Đã ẩn",
              )
            ]),
          );
        });
  }
}
