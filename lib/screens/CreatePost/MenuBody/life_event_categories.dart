import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/widgets/snack_bar_custom.dart';

import '../../../data/life_event_categories.dart';
import '../../../providers/create_feed/feed_draft_provider.dart';
import '../../../theme/colors.dart';
import '../../../widgets/button_primary.dart';
import '../CreateNewFeed/create_new_feed.dart';
import '../create_modal_base_menu.dart';
import 'life_event_detail.dart';

class LifeEventCategories extends ConsumerStatefulWidget {
  final List? listLifeEvent;
  final dynamic eventSelected;
  final Function handleUpdateData;
  final String? type;
  final bool? edit;
  final String? school;

  const LifeEventCategories({
    Key? key,
    this.listLifeEvent,
    this.eventSelected,
    required this.handleUpdateData,
    this.type,
    this.edit,
    this.school,
  }) : super(key: key);

  @override
  _LifeEventCategoriesState createState() => _LifeEventCategoriesState();
}

class _LifeEventCategoriesState extends ConsumerState<LifeEventCategories> {
  dynamic lifeEvent = {
    // "default_media_url": '',
    // "life_event_category_id": '',
    // "name": "",
    // "place_id": null,
    // "start_date": ""
  };
  String? selectedValue;
  List friendSelected = [];
  Widget body = const SizedBox();
  Widget buttonAppbar = const SizedBox();

  handlePress(event, lifeEventCategoryId) {
    if (event['children'] != null && event['children'].isNotEmpty) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => CreateModalBaseMenu(
                  title: event['name'],
                  body: LifeEventCategories(
                    type: 'children',
                    eventSelected: event,
                    listLifeEvent: event['children'],
                    handleUpdateData: widget.handleUpdateData,
                    edit: widget.edit,
                  ),
                  buttonAppbar: const SizedBox())));
    } else {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => CreateModalBaseMenu(
                  title: event['name'] ?? '',
                  body: LifeEventDetail(
                      event: event,
                      updateLifeEvent: (type, value) {
                        if (mounted) {
                          setState(() {
                            lifeEvent = {
                              ...lifeEvent,
                              "life_event_category_id": lifeEventCategoryId,
                              "school_type": widget.school,
                              type: value
                            };
                          });
                        }
                      }),
                  buttonAppbar: ButtonPrimary(
                    label: "Xong",
                    handlePress: () {
                      if (lifeEvent['place_id'] != null) {
                        widget.handleUpdateData('updateLifeEvent', lifeEvent);
                        if (widget.type != null && widget.type == 'children') {
                          ref
                              .read(draftFeedController.notifier)
                              .saveDraftFeed(DraftFeed(lifeEvent: lifeEvent));
                          if (widget.edit == true) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: ((context) => const CreateNewFeed(
                                          edit: true,
                                        ))));
                          } else {
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pop();
                          }
                        } else {
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                        }
                      } else {
                        buildSnackBar(context, "Vui lòng chọn địa điểm");
                      }
                    },
                  ))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    List listData = widget.listLifeEvent ?? lifeEventCategories;
    return SingleChildScrollView(
      child: Column(
        children: [
          widget.listLifeEvent != null
              ? InkWell(
                  onTap: () {
                    handlePress({}, {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.2, color: greyColor),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.eventSelected['name'],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.pen,
                              size: 16,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "Nhập tiêu đề",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const Text(
                          "Ví dụ: bạn cùng phòng mới, cải tạo nhà cửa, mua xe hơi,...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: greyColor),
                        )
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      width: size.width,
                      child: Image.asset('assets/live_event.png'),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text(
                      "Sự kiện trong đời",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 4, bottom: 12.0, left: 10.0, right: 10.0),
                      child: const Text(
                        "Chia sẻ và ghi nhớ những khoảnh khắc quan trọng trong đời.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: greyColor),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 8.0),
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: widget.listLifeEvent != null ? 1 : 3,
                  childAspectRatio: widget.listLifeEvent != null ? 5 : 1),
              itemCount: listData.length,
              itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      handlePress(listData[index], listData[index]["id"]);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        listData[index]['url'] != null
                            ? SvgPicture.network(
                                listData[index]['url'],
                                width: 24.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              )
                            : const SizedBox(),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 4.0, left: 4.0, right: 4.0),
                          child: Text(
                            listData[index]['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ))
        ],
      ),
    );
  }
}
