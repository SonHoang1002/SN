import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constant/group_constants.dart';
import '../../../../theme/colors.dart';
import '../../../../widgets/GeneralWidget/build_stage_navigation_bar.dart';
import '../../../../widgets/GeneralWidget/divider_widget.dart';
import '../../../../widgets/GeneralWidget/information_component_widget.dart';
import '../../../../widgets/back_icon_appbar.dart';

class CreatePostGroupPage extends StatefulWidget {
  @override
  State<CreatePostGroupPage> createState() => _CreatePostGroupPageState();
}

class _CreatePostGroupPageState extends State<CreatePostGroupPage> {
  late double width = 0;
  late double height = 0;
  late TextEditingController _postController = TextEditingController(text: "");

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
              // AppBarTitle(title: GroupConstants.CONTINUE_AFTER),
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
                    Row(
                      children: [
                        Text(
                          CreatePostGroupConstants.TITLE[0],
                          style: const TextStyle(
                              // color:  white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(CreatePostGroupConstants.SUBTITLE[0],
                        style: const TextStyle(
                            // color:  white,
                            fontSize: 18)),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            enableDrag: true,
                            context: context,
                            isScrollControlled: true,
                            barrierColor: transparent,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10))),
                            builder: ((context) {
                              return Container(
                                height: height,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: _createPostWidget(context, true),
                              );
                            }));
                        // icon, .....
                        showModalBottomSheet(
                            backgroundColor: transparent,
                            enableDrag: true,
                            context: context,
                            isScrollControlled: true,
                            barrierColor: transparent,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10))),
                            builder: ((context) {
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: Column(
                                  children: [
                                    //drag icon
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
                                      height: 490,
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: 12,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              child: GeneralComponent(
                                                [
                                                  Text(
                                                    CreatePostGroupConstants
                                                        .CONTENT_LIST[index],
                                                    style: TextStyle(
                                                        // color:  white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                                prefixWidget: Container(
                                                  height: 20,
                                                  width: 20,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: SvgPicture.asset(
                                                    CreatePostGroupConstants
                                                        .ICON_PATH_LIST[index],
                                                    color:
                                                        CreatePostGroupConstants
                                                            .COLOR_LIST[index],
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                                changeBackground: transparent,
                                              ),
                                            );
                                          })),
                                    ),
                                  ],
                                ),
                              );
                            }));
                      },
                      child: _createPostWidget(context, false),
                    )
                  ],
                ),
              ),
            ),
            // bottom
            buildStageNavigatorBar(
                width: width,
                currentPage: 4,
                isPassCondition: true,
                title: GroupConstants.DONE,
                function: () {
                  // pushToNextScreen(context, CreatePostGroupPage());
                })
          ]),
        ));
  }

  Widget _createPostWidget(BuildContext context, bool inSheet) {
    return Column(
      children: [
        inSheet
            ? Container(
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  FontAwesomeIcons.close,
                                  // color:  white,
                                ))
                          ]),
                        ),
                        Text(
                          CreatePostGroupConstants.TITLE[1],
                          style: TextStyle(
                              // color:  white,
                              fontSize: 18),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400]),
                            onPressed: () {},
                            child: Text(
                              "Đăng",
                              style: TextStyle(color: white, fontSize: 15),
                            ),
                          ),
                        )
                      ],
                    ),
                    // buildSpacer(height: 20),
                    buildDivider(color: Colors.red)
                  ],
                ),
              )
            : Container(),
        Container(
          height: inSheet ? height * 0.85 : 500,
          decoration: inSheet
              ? null
              : BoxDecoration(
                  color: transparent,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: GeneralComponent(
                  [
                    Text(
                      CreatePostGroupConstants.USER_EXAMPLE[0],
                      style: TextStyle(
                          // color:  white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    inSheet
                        ? Container(
                            // height: 20,
                            // color: Colors.red,
                            // width: 200,
                            margin: EdgeInsets.only(top: 5),
                            // padding: EdgeInsets.only(right: 5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.userGroup,
                                        // color:  white,
                                        size: 10,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        CreatePostGroupConstants
                                            .USER_EXAMPLE[1],
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      width: 150,
                                      child: Divider(height: 3, color: white))
                                ]),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    // color:  white,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child:
                                Text(CreatePostGroupConstants.USER_EXAMPLE[1],
                                    style: TextStyle(
                                      // color:  white,
                                      fontSize: 13,
                                    )),
                          ),
                  ],
                  prefixWidget: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(right: 10),

                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.grey[800]),
                    child: Image.asset(
                      GroupConstants.PATH_IMG + "cat_1.png",
                      // color:  white,
                    ),
                  ),
                  changeBackground: transparent,
                ),
              ),
              Container(
                height: 50,
                child: TextFormField(
                  // maxLines: 2,
                  controller: _postController,
                  onTap: (() {
                    if (!inSheet) {}
                  }),
                  readOnly: !inSheet,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  style: TextStyle(
                      // color:  white,
                      overflow: TextOverflow.visible),
                  decoration: InputDecoration(
                      hintText: CreatePostGroupConstants.PLACEHOLDER_LIST[0],
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      border: InputBorder.none,
                      fillColor: transparent,
                      filled: true),
                ),
              ),

              // nếu có đăng ảnh vào đây
              // Container(
              //     // height: 400,
              //     width: width,
              //     color:  white,
              //     child: Image.asset(
              //       ConstantsGroup.PATH_IMG + "back_1.jpg",
              //       fit: BoxFit.fitWidth,
              //     )),
            ],
          ),
        ),
      ],
    );
  }
}
