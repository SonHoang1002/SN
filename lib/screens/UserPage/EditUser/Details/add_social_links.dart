// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../apis/post_api.dart';
import '../../../../constant/common.dart';
import '../../../../data/life_event_categories.dart';
import '../../../../theme/colors.dart';
import '../../../../widgets/avatar_social.dart';
import '../../../../widgets/button_primary.dart';
import '../../../../widgets/date_time_custom.dart';
import '../../../../widgets/text_description.dart';
import '../../../CreatePost/create_modal_base_menu.dart';
import '../../../CreatePost/MenuBody/friend_tag.dart';

class SocialLinks extends ConsumerStatefulWidget {
  final List? listLifeEvent;
  final dynamic eventSelected;
  final Function handleUpdateData;
  final String? type;
  final bool? edit;
  final String? school;
  final dynamic relationship;
  final String? idUser;
  SocialLinks({
    Key? key,
    this.listLifeEvent,
    this.eventSelected,
    required this.handleUpdateData,
    this.type,
    this.edit,
    this.school,
    this.relationship,
    this.idUser,
  }) : super(key: key);

  @override
  _SocialLinksState createState() => _SocialLinksState();
}

class _SocialLinksState extends ConsumerState<SocialLinks> {
  dynamic lifeEvent = {
    // "default_media_url": '',
    // "life_event_category_id": 35,
    // "name": "",
    // "place_id": null,
    // "start_date": ""
  };
  dynamic selectedValue;
  List friendSelected = [];
  Widget body = const SizedBox();
  Widget buttonAppbar = const SizedBox();
  dynamic inforRelationship;
  bool check = false;
  bool checkRelationship = false;
  var visibility = {};
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    if (widget.relationship != null) {
      visibility['key'] = widget.relationship["visibility"];
      selectedValue = widget.relationship["relationship_category"];
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

  void handleCreateRelationship() async {
    var data = {
      "relationship_category_id": selectedValue["id"],
      "visibility": visibility['key'],
      "start_date": formattedDate
    };
    if (widget.relationship != null) {
      data = {
        ...data,
        'partner_id': inforRelationship == null
            ? widget.idUser
            : inforRelationship[0]['id']
      };
    }
    var response = await PostApi().createRelationship(data);
    if (response != null) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    }
  }

  void handleDate(DateTime selectedDate) {
    formattedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(selectedDate);
    // formattedDate sẽ có định dạng "2022-02-22T17:00:00.000Z"
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    List listData = widget.listLifeEvent ?? lifeEventCategories[11];

    return SizedBox(
      height: size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
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
                                        selectedValue = listData[index];

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
                            selectedValue["name"],
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
                    ? SizedBox(
                        height: 45.0,
                        child: CupertinoTextField(
                          style: TextStyle(color: colorWord(context)),
                          placeholder: "Nhập url trang web ...",
                          placeholderStyle: TextStyle(
                            color: colorWord(context),
                            fontSize: 16.5,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      )
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
                    onPressed: () {
                      handleCreateRelationship();
                    },
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
