import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/screens/CreatePost/MenuBody/checkin.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/date_time_custom.dart';
import 'package:social_network_app_mobile/widgets/text_form_field_custom.dart';

class LifeEventDetail extends StatefulWidget {
  final dynamic event;
  final Function? updateLifeEvent;
  const LifeEventDetail({Key? key, this.event, this.updateLifeEvent})
      : super(key: key);

  @override
  State<LifeEventDetail> createState() => _LifeEventDetailState();
}

class _LifeEventDetailState extends State<LifeEventDetail> {
  String path = '';
  String titleButton = 'Chọn địa điểm';
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    if (!mounted) return;

    if (widget.event != null && widget.event['video_url'] != null) {
      path = widget.event['video_url'][0];
      Future.delayed(Duration.zero, () {
        // widget.updateLifeEvent!('place_id', widget.event['video_url'][0]);
        widget.updateLifeEvent!(
            'default_media_url', widget.event['video_url'][0]);
      });
    }

    flickMultiManager = FlickMultiManager();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        hiddenKeyboard(context);
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 260),
                  color: Theme.of(context).canvasColor,
                  child: path != ''
                      ? FeedVideo(
                          path: path,
                          flickMultiManager: flickMultiManager,
                          image: '')
                      : const Center(
                          child: Text(
                            "Chưa có phương tiện hiển thị",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: SizedBox(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.event['video_url'] != null
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        path = '';
                                      });
                                      widget.updateLifeEvent!(
                                          'default_media_url', null);
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      margin: const EdgeInsets.only(
                                          right: 8.0, left: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          border: Border.all(
                                            width: 0.2,
                                            color: greyColor,
                                          )),
                                      child: const Icon(
                                        FontAwesomeIcons.xmark,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                        widget.event['video_url'].length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                widget.updateLifeEvent!(
                                                    'default_media_url',
                                                    widget.event['video_url']
                                                        [index]);
                                                setState(() {
                                                  path = '';
                                                });
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 200),
                                                    () async {
                                                  setState(() {
                                                    path = widget
                                                            .event['video_url']
                                                        [index];
                                                  });
                                                });
                                              },
                                              child: Container(
                                                width: 35,
                                                height: 35,
                                                margin: const EdgeInsets.only(
                                                    right: 8.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          17.5),
                                                  child: FeedVideo(
                                                      path: widget.event[
                                                          'video_url'][index],
                                                      flickMultiManager:
                                                          flickMultiManager,
                                                      image: ''),
                                                ),
                                              ),
                                            )),
                                  ),
                                ],
                              )
                            : Container(),
                        Container(
                            margin: const EdgeInsets.only(right: 4.0),
                            child: ButtonPrimary(
                                label: "Ảnh/video", handlePress: () {})),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 80,
                      child: TextFormFieldCustom(
                        handleGetValue: (value) {
                          widget.updateLifeEvent!('name', value);
                        },
                        autofocus: true,
                        maxLines: 1,
                        hintText: "Tiêu đề",
                        initialValue: widget.event['name'],
                        helperText:
                            "Ví dụ: thành tích, hoạt động tình nguyện, kĩ năng hoặc bằng cấp mới",
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 46,
                      child: ButtonPrimary(
                        label: titleButton,
                        handlePress: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => CreateModalBaseMenu(
                                      title: "Chọn địa điểm",
                                      body: Checkin(
                                        handleUpdateData: (type, data) {
                                          widget.updateLifeEvent!('place_id',
                                              data != null ? data['id'] : data);
                                          setState(() {
                                            titleButton = data['title'];
                                          });
                                        },
                                        checkin: null,
                                        type: "menu_out",
                                      ),
                                      buttonAppbar: const SizedBox())));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    DateTimeCustom(handleGetDate: (date) {
                      widget.updateLifeEvent!('start_date',
                          '${date.year} - ${date.month} - ${date.day}');
                    })
                  ],
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
