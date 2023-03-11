import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/preview_video_image.dart';

import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';

import 'rating_star_widget.dart';

Widget buildReviewItemWidget(BuildContext context, dynamic data,
    {Function? updateFunction}) {
  final userImgPath = data["comment"]["account"]["avatar_media"]["url"];
  final nameOfUser = data["comment"]["account"]["display_name"] ?? "Anynomous";
  final rating = double.parse(data["rating_point"]);
  final contents = data["comment"]["content"] ?? "Content bi null !!!";
  List<dynamic>? commentImgPath =
      data["comment"]["media_attachments"].isNotEmpty
          ? data["comment"]["media_attachments"].map((element) {
              return element["url"];
            }).toList()
          : null;
  String time = data["comment"]["created_at"] ?? "khong co du lieu";
  return Container(
    margin: const EdgeInsets.only(top: 5),
    child: Column(children: [
      GeneralComponent(
        [
          buildTextContent(nameOfUser, false,
              colorWord: Colors.grey, fontSize: 14),
          buildSpacer(height: 5),
          buildRatingStarWidget(rating, size: 10),
        ],
        prefixWidget: SizedBox(
          height: 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: userImgPath != null
                        ? ImageCacheRender(path: userImgPath)
                        : Image.asset(
                            MarketPlaceConstants.PATH_IMG + "cat_1.png")),
              ),
              const SizedBox()
            ],
          ),
        ),
        suffixFlexValue: 5,
        suffixWidget: Row(children: [
          const Icon(
            FontAwesomeIcons.thumbsUp,
            size: 15,
          ),
          buildSpacer(width: 5),
          buildTextContent("2", false, colorWord: greyColor, fontSize: 12),
          buildSpacer(width: 10),
          GestureDetector(
            onTap: () {
              updateFunction != null ? updateFunction() : null;
            },
            child: const Icon(
              FontAwesomeIcons.ellipsis,
              size: 15,
            ),
          ),
        ]),
        changeBackground: transparent,
        padding: EdgeInsets.zero,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            buildSpacer(height: 5),
            buildTextContent(time, false, fontSize: 11, colorWord: greyColor),
            buildSpacer(height: 10),
            buildTextContent(contents, false, fontSize: 16),
            commentImgPath != null && commentImgPath.isNotEmpty
                ? Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              List.generate(commentImgPath.length, (index) {
                            return InkWell(
                              onTap: () {
                                pushToNextScreen(
                                    context,
                                    PreviewVideoImage(
                                      src: commentImgPath[index],
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: data["comment"]["media_attachments"]
                                            [index]["type"] ==
                                        "image"
                                    ? ImageCacheRender(
                                        path: commentImgPath[index],
                                        height: 100.0,
                                        width: 100.0,
                                      )
                                    : SizedBox(
                                        height: 120.0,
                                        width: 170.0,
                                        child: VideoPlayerRender(
                                          path: commentImgPath[index],
                                        )),
                              ),
                            );
                          }).toList(),
                        )),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      buildSpacer(height: 10),
      buildDivider(height: 10, color: red)
    ]),
  );
}