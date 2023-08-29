import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/data/background_post.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateNewFeed/create_feed_status_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/box_mention.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import "package:collection/collection.dart";
import 'package:social_network_app_mobile/widgets/mentions/model/social_content_detection_model.dart';

class CreateFeedStatus extends ConsumerStatefulWidget {
  final String? content;
  final bool isShowBackground;
  final dynamic checkin;
  final dynamic visibility;
  final dynamic statusActivity;
  final dynamic backgroundSelected;
  final Function handleUpdateData;
  final List friendSelected;
  final Function handleGetPreviewUrl;
  final dynamic pageData;
  final FocusNode? focusNode;
  final Function(Offset currentCharacterMention, List mentionList)?
      mentionAction;
  final Function(dynamic mention)? handleMention;

  /// This is used to create post in friend wall
  final dynamic friendData;
  const CreateFeedStatus(
      {Key? key,
      required this.visibility,
      this.backgroundSelected,
      required this.handleUpdateData,
      required this.handleGetPreviewUrl,
      required this.isShowBackground,
      this.statusActivity,
      required this.friendSelected,
      this.checkin,
      this.content,
      this.pageData,
      this.focusNode,
      this.friendData,
      this.mentionAction,
      this.handleMention})
      : super(key: key);

  @override
  ConsumerState<CreateFeedStatus> createState() => _CreateFeedStatusState();
}

class _CreateFeedStatusState extends ConsumerState<CreateFeedStatus> {
  final TextEditingController controller = TextEditingController();
  List listMentions = [];
  List listMentionsSelected = [];
  bool isActiveBackground = false;
  GlobalKey textformfieldKey = GlobalKey();

  @override
  void initState() {
    if (!mounted) return;

    if (widget.content!.trim().isNotEmpty) {
      controller.text = widget.content ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    String description = '';

    if (widget.statusActivity == null) {
      description = '';
    } else if (widget.statusActivity['parent'] == null) {
      description = ' đang cảm thấy ${widget.statusActivity['name']}';
    } else {
      description =
          ' ${widget.statusActivity['parent']['name'].toLowerCase()} ${widget.statusActivity['name'].toLowerCase()}';
    }

    if (widget.friendSelected.isNotEmpty) {
      description = '$description cùng với ';
    }

    if (widget.checkin != null) {
      description = '$description đang ở ${widget.checkin['title']}';
    }

    double marginContainer = widget.backgroundSelected != null ? 0.0 : 8.0;
    double paddingContainer = widget.backgroundSelected != null ? 8.0 : 0;

    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(width: 0.2, color: greyColor)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: CreateFeedStatusHeader(
              description: description,
              friendSelected: widget.friendSelected,
              statusActivity: widget.statusActivity,
              visibility: widget.visibility,
              handleUpdateData: widget.handleUpdateData,
              sharePostFriend: widget.friendData,
              entity: widget.pageData != null
                  ? {...widget.pageData, "entityType": "page"}
                  : null,
            ),
          ),
          Container(
            height: widget.backgroundSelected != null ? 230 : null,
            width: size.width,
            margin: EdgeInsets.only(
                left: marginContainer, right: marginContainer, bottom: 8.0),
            padding: EdgeInsets.symmetric(horizontal: paddingContainer),
            decoration: BoxDecoration(
              image: widget.backgroundSelected != null
                  ? DecorationImage(
                      image: NetworkImage(widget.backgroundSelected['url']),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      key: textformfieldKey,
                      autofocus: false,
                      focusNode: widget.focusNode,
                      onChanged: (value) {
                        widget.handleUpdateData('update_content', {
                          "content": value,
                          "mentions": listMentionsSelected
                        });
                        widget.handleGetPreviewUrl(value);
                        onDetectContent(value);
                      },
                      maxLines: null,
                      textAlign: widget.backgroundSelected != null
                          ? TextAlign.center
                          : TextAlign.left,
                      controller: controller,
                      textCapitalization: TextCapitalization.sentences,
                      style: widget.backgroundSelected != null
                          ? TextStyle(
                              color: Color(int.parse(
                                  '0xFF${widget.backgroundSelected['style']['fontColor'].substring(1)}')),
                              fontWeight: FontWeight.w700,
                              fontSize: 22)
                          : null,
                      decoration: InputDecoration(
                        hintText: "Bạn đang nghĩ gì?",
                        hintStyle: TextStyle(
                            color: widget.backgroundSelected != null
                                ? Color(int.parse(
                                    '0xFF${widget.backgroundSelected['style']['fontColor'].substring(1)}'))
                                : null,
                            fontSize:
                                widget.backgroundSelected != null ? 22 : 15),
                        border: InputBorder.none,
                      ),
                    )
                  ],
                ),
                listMentions.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: BoxMention(
                          listData: listMentions,
                          getMention: (mention) {
                            setState(() {
                              listMentions = [];
                              if (!listMentionsSelected.contains(mention)) {
                                listMentionsSelected.add(mention);
                              }
                            });
                            updateDataTextController(mention);
                          },
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  updateDataTextController(dynamic mention) {
    final indexOfPointer = controller.selection.baseOffset;
    final valueOfTextfield = controller.value.text;
    final result = renderNewValue(valueOfTextfield, indexOfPointer,
        ((mention?['title']) ?? (mention?['display_name']) ?? ""));
    controller.text = result[0];
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: result[1]));
    widget.handleUpdateData('update_content',
        {"content": result[0], "mentions": listMentionsSelected});
  }

  // return List contain: [0]:newValue, [1]:currentIndex of pointer
  List renderNewValue(String value, int indexPointer, String newValue) {
    String subStringValue = value.substring(0, indexPointer);
    List solitList = subStringValue.split("");
    final indexCharater = solitList.lastIndexOf("@");

    return [
      value.substring(0, indexCharater) +
          newValue +
          value.substring(indexPointer),
      (value.substring(0, indexCharater) + newValue).length
    ];
  }

  void onDetectContent(String value) async {
    if (!value.contains('@')) {
      if (listMentions.isNotEmpty) {
        setState(() {
          listMentions = [];
        });
      }
      return;
    }
    List newList = [];
    String searchValues = getSearchCharacter(value);
    if (searchValues.isEmpty) {
      newList = await FriendsApi().getListFriendApi(
              ref.watch(meControllerProvider)[0]['id'], {"limit": 20}) ??
          [];
    } else {
      var response = await SearchApi()
          .getListSearchApi({"q": searchValues, "limit": 5});
      if (response != null) {
        newList = response['accounts'] + response['groups'] + response['pages'];
      }
    }
    setState(() {
      listMentions = newList;
    });
    // final textfieldRenderBox =
    //     textformfieldKey.currentContext!.findRenderObject() as RenderBox;
    // Offset textfieldOffset = textfieldRenderBox.localToGlobal(Offset.zero);
    // final bottomOffset = Offset(textfieldOffset.dx,
    //     textfieldOffset.dy + textfieldRenderBox.size.height - 100);
    // widget.mentionAction != null
    //     ? widget.mentionAction!(bottomOffset, newList)
    //     : null;
  }

  String getSearchCharacter(String value) {
    var splitValueList = value.split("").reversed.toList();
    var lastSpecialIndex = getIndex(splitValueList);
    return value.substring(value.length - lastSpecialIndex, value.length);
  }

  int getIndex(List list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == "@") {
        return i;
      }
    }
    return -1;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class WrapBackground extends StatelessWidget {
  final Widget widgetChild;
  const WrapBackground({
    super.key,
    required this.widgetChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 0.1, color: greyColor)),
      child: widgetChild,
    );
  }
}

class PostBackground extends StatelessWidget {
  final dynamic backgroundSelected;
  final Function updateBackgroundSelected;

  const PostBackground(
      {super.key,
      this.backgroundSelected,
      required this.updateBackgroundSelected});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    dynamic listGroupBg =
        groupBy(backgroundPost, (obj) => obj['category_name']);
    List<dynamic> listKeysBg = listGroupBg.keys.toList();
    return SizedBox(
      height: size.height * 0.45,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  listKeysBg.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            listKeysBg[index],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 4,
                                crossAxisCount: 5,
                              ),
                              itemCount: listGroupBg[listKeysBg[index]].length,
                              itemBuilder: (context, indexBg) => BackgroundItem(
                                    updateBackgroundSelected:
                                        updateBackgroundSelected,
                                    backgroundSelected: backgroundSelected,
                                    background: listGroupBg[listKeysBg[index]]
                                        [indexBg],
                                  )),
                        ],
                      )),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundItem extends StatelessWidget {
  const BackgroundItem({
    super.key,
    required this.updateBackgroundSelected,
    required this.backgroundSelected,
    this.background,
  });

  final Function updateBackgroundSelected;
  final dynamic backgroundSelected;
  final dynamic background;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        updateBackgroundSelected(background);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 5),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
            border: backgroundSelected != null &&
                    backgroundSelected['id'] == background['id']
                ? Border.all(width: 1, color: primaryColor)
                : null,
            borderRadius: BorderRadius.circular(5)),
        child: WrapBackground(
            widgetChild: WrapBackground(
                widgetChild: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: ImageCacheRender(
              width: 26.0, height: 26.0, path: background['url']),
        ))),
      ),
    );
  }
}
