import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/event_constants.dart';
import '../../../helper/push_to_new_screen.dart';
import '../../../theme/colors.dart';
import '../../../widget/GeneralWidget/build_stage_navigation_bar_widget.dart';
import '../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/appbar_title.dart';
import '../../../widget/back_icon_appbar.dart';
import 'description_event_page.dart';
import 'detail_event_page.dart';
import 'location_event_page.dart';
import 'setting_event_page.dart';

class ReviewEventPage extends StatefulWidget {
  @override
  State<ReviewEventPage> createState() => _ReviewEventPageState();
}

class _ReviewEventPageState extends State<ReviewEventPage> {
  late double width = 0;
  bool isPrivateSelection = true;
  File? _pickedImage;
  XFile? _xFile;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(
              title: ReviewEventConstants.REVIEW_EVENT_APPBAR_TITLE,
            ),
            GestureDetector(
                onTap: () {
                  popToPreviousScreen(
                    context,
                  );
                },
                child: const AppBarTitle(title: EventConstants.CANCEL)),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            Expanded(
              child: Column(
                children: [
                  // add cover image
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                          ),
                          child: _pickedImage != null
                              ? Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.fitWidth,
                                )
                              : Container(),
                        ),
                        Container(
                          height: 200,
                          child: GestureDetector(
                            onTap: (() {
                              getCoverImage();
                            }),
                            child: Center(
                                child: Container(
                                    width: 130,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[700],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Row(
                                      children: [
                                        buildSpacer(
                                          width: 10,
                                        ),
                                        const Icon(
                                          FontAwesomeIcons.layerGroup,
                                          color: white,
                                          size: 13,
                                        ),
                                        buildSpacer(
                                          width: 10,
                                        ),
                                        const Text(
                                          "Thêm ảnh bìa",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 13,
                                          ),
                                        )
                                      ],
                                    ))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildSpacer(
                    height: 10,
                  ),

                  // detail component
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => DetailEventPage()));
                      },
                      child: GeneralComponent(
                        [
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                const Text(
                                  ReviewEventConstants.TIME_EVENT,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                const Text(
                                  ReviewEventConstants.NAME_EVENT,
                                  style: TextStyle(
                                      // color:  white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(children: [
                              Container(
                                // width: 30,
                                // height: 30,
                                margin: const EdgeInsets.only(right: 8),
                                child: const Center(
                                  child: Icon(
                                    FontAwesomeIcons.lock,
                                    // color:  white,
                                    size: 14,
                                  ),
                                ),
                              ),
                              const Text(ReviewEventConstants.RANGE_EVENT,
                                  style: TextStyle(
                                    // color: Colors.grey,
                                    fontSize: 14,
                                    // fontWeight: FontWeight.bold,
                                  )),
                              const Text(ReviewEventConstants.ORGANIZE_PERSON,
                                  style: TextStyle(
                                    // color:  white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ]),
                          )
                        ],
                        padding: const EdgeInsets.all(5),
                        suffixWidget: Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(right: 10),
                          child: const Icon(
                            EventConstants.ICON_DATA_NEXT,
                            // color:  white,
                            size: 15,
                          ),
                        ),
                        changeBackground: transparent,
                      ),
                    ),
                  ),

                  // description, location and event settings
                  Container(
                    // height: 160,
                    margin: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: ReviewEventConstants
                            .REVIEW_EVENT_CONTENT_LIST.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              switch (ReviewEventConstants
                                  .REVIEW_EVENT_CONTENT_LIST[index][1]) {
                                case "Mô tả":
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => DescriptionEventPage()));
                                  break;
                                case "Vị trí":
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => LocationEventPage()));
                                  break;
                                default:
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => SettingEventPage()));
                                  break;
                              }
                            },
                            child: GeneralComponent(
                              [
                                Text(
                                    ReviewEventConstants
                                        .REVIEW_EVENT_CONTENT_LIST[index][1],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      // color:  white
                                    )),
                                ReviewEventConstants.REVIEW_EVENT_CONTENT_LIST[
                                                index][2] ==
                                            "" ||
                                        ReviewEventConstants
                                                    .REVIEW_EVENT_CONTENT_LIST[
                                                index][2] ==
                                            null
                                    ? Container()
                                    : Column(
                                        children: [
                                          buildSpacer(
                                            height: 5,
                                          ),
                                          Text(
                                              ReviewEventConstants
                                                      .REVIEW_EVENT_CONTENT_LIST[
                                                  index][2],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                // color: Colors.grey
                                              ))
                                        ],
                                      ),
                              ],
                              prefixWidget: Container(
                                  height: 40,
                                  width: 40,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[700],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: ReviewEventConstants
                                              .REVIEW_EVENT_CONTENT_LIST[index]
                                          [0] is String
                                      ? SvgPicture.asset(
                                          ReviewEventConstants
                                                  .REVIEW_EVENT_CONTENT_LIST[
                                              index][0],
                                          color: white,
                                        )
                                      : Icon(
                                          ReviewEventConstants
                                                  .REVIEW_EVENT_CONTENT_LIST[
                                              index][0],
                                          color: white,
                                          size: 15,
                                        )),
                              changeBackground: transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              suffixWidget: Container(
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.only(right: 10),
                                child: const Icon(
                                  EventConstants.ICON_DATA_NEXT,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ),
                            ),
                          );
                        })),
                  )
                ],
              ),
            ),
            // bottom navigate
            buildStageNavigatorBar(
                width: width,
                currentPage: 4,
                isPassCondition: true,
                title: "Tạo sự kiện",
                function: () {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (_) => ReviewEventPage()));
                })
          ]),
        ),
      ),
    );
  }

  Future<void> getCoverImage() async {
    _xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = File(_xFile!.path);
    });
  }
}
