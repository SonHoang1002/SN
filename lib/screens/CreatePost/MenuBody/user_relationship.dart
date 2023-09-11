// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/widgets/snack_bar_custom.dart';

import '../../../constant/common.dart';
import '../../../data/life_event_categories.dart';
import '../../../providers/create_feed/feed_draft_provider.dart';
import '../../../theme/colors.dart';
import '../../../widgets/avatar_social.dart';
import '../../../widgets/button_primary.dart';
import '../../../widgets/text_description.dart';
import '../CreateNewFeed/create_new_feed.dart';
import '../create_modal_base_menu.dart';
import 'friend_tag.dart';
import 'life_event_categories.dart';
import 'life_event_detail.dart';

class Relationship extends ConsumerStatefulWidget {
  final List? listLifeEvent;
  final dynamic eventSelected;
  final Function handleUpdateData;
  final String? type;
  final bool? edit;
  final String? school;
  final dynamic relationship;
  Relationship(
      {Key? key,
      this.listLifeEvent,
      this.eventSelected,
      required this.handleUpdateData,
      this.type,
      this.edit,
      this.school,
      this.relationship})
      : super(key: key);

  @override
  _RelationshipState createState() => _RelationshipState();
}

class _RelationshipState extends ConsumerState<Relationship> {
  dynamic lifeEvent = {
    // "default_media_url": '',
    // "life_event_category_id": 35,
    // "name": "",
    // "place_id": null,
    // "start_date": ""
  };
  String? selectedValue;
  List friendSelected = [];
  Widget body = const SizedBox();
  Widget buttonAppbar = const SizedBox();
  dynamic inforRelationship;
  bool check = false;
  bool checkRelationship = false;

  @override
  void initState() {
    super.initState();
    if (widget.relationship != null) {
      selectedValue = widget.relationship["relationship_category"]["name"];
      if (widget.relationship["relationship_category"]["id"] == 0 ||
          widget.relationship["relationship_category"]["id"] == 2 ||
          widget.relationship["relationship_category"]["id"] == 8) {
        setState(() {
          checkRelationship = false;
        });
      } else {
        setState(() {
          checkRelationship = true;
        });
      }
    }
  }

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

    return SizedBox(
      height: size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    InkWell(
                        onTap: () {
                          showBarModalBottomSheet(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            context: context,
                            builder: (context) => Container(
                              margin:
                                  const EdgeInsets.only(left: 8.0, top: 15.0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Column(
                                children: [
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: typeVisibility.length,
                                    itemBuilder: ((context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0, bottom: 13.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                typeVisibility[index]['icon'],
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                width: 12.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      typeVisibility[index]
                                                          ['label'],
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  const SizedBox(
                                                    height: 4.0,
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width -
                                                        110,
                                                    child: TextDescription(
                                                        description:
                                                            typeVisibility[
                                                                    index]
                                                                ['subLabel']),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: size.width * 0.28,
                            height: 37,
                            decoration: BoxDecoration(
                                // color: const Color.fromARGB(189, 202, 202, 202),
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(width: 0.6, color: greyColor)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Công Khai",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 3),
                                  child:
                                      Icon(FontAwesomeIcons.sortDown, size: 14),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                    onTap: () {
                      showBarModalBottomSheet(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        context: context,
                        builder: (context) => Container(
                          margin: const EdgeInsets.only(left: 8.0, top: 15.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Column(
                            children: [
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listData.length,
                                itemBuilder: ((context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = listData[index]["name"];
                                        if (listData[index]["name"] ==
                                                "Độc thân" ||
                                            listData[index]["name"] ==
                                                "Tình trạng mối quan hệ" ||
                                            listData[index]["name"] ==
                                                "Ly thân") {
                                          setState(() {
                                            checkRelationship = false;
                                          });
                                        } else {
                                          setState(() {
                                            checkRelationship = true;
                                          });
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, bottom: 13.0),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(listData[index]["name"],
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 37,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(189, 202, 202, 202),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(width: 0.2, color: greyColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$selectedValue",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 3),
                            child: Icon(FontAwesomeIcons.sortDown, size: 14),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                checkRelationship
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: InkWell(
                          child: Row(
                            children: [
                              AvatarSocial(
                                  width: 40,
                                  height: 40,
                                  object: widget.relationship,
                                  path: check == false
                                      ? widget.relationship["partner"]
                                                  ['avatar_media'] !=
                                              null
                                          ? widget.relationship["partner"]
                                              ['avatar_media']['preview_url']
                                          : linkAvatarDefault
                                      : inforRelationship != null
                                          ? inforRelationship[0]['avatar_media']
                                              ['preview_url']
                                          : linkAvatarDefault),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                check
                                    ? inforRelationship[0]['display_name']
                                    : widget.relationship["partner"]
                                            ['display_name'] ??
                                        "Chọn bạn đời ...",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          onTap: () async {
                            body = FriendTag(
                                friendsPrePage: friendSelected,
                                handleUpdateData: widget.handleUpdateData);
                            buttonAppbar = ButtonPrimary(
                              label: "Xong",
                              handlePress: () {
                                Navigator.of(context).pop();
                              },
                            );
                            inforRelationship = await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => CreateModalBaseMenu(
                                        title: "Gắn thẻ ai đó",
                                        body: body,
                                        buttonAppbar: buttonAppbar)));
                            if (inforRelationship != null) {
                              setState(() {
                                check = true;
                              });
                            }
                          },
                        ))
                    : const SizedBox(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.46, 35),
                        backgroundColor: greyColor),
                    child: Text("Xóa, gỡ")),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width * 0.46, 35),
                    ),
                    child: Text("Lưu"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
