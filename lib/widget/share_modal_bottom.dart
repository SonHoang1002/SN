import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';

import '../theme/colors.dart';
import 'avatar_social.dart';

class ShareModalBottom extends ConsumerStatefulWidget {
  final dynamic data;
  final String? type;
  const ShareModalBottom({Key? key, this.data, this.type}) : super(key: key);
  @override
  ConsumerState<ShareModalBottom> createState() => _ShareModalBottomState();
}

List iconShareModal = [
  {
    "key": "share",
    "label": "Chia sẻ lên tin của bạn",
    "icon": FontAwesomeIcons.bookOpen
  },
  {
    "key": "share-send",
    "label": "Gửi bằng Messenger",
    "icon": FontAwesomeIcons.facebookMessenger
  },
  {
    "key": "share-group",
    "label": "Chia sẻ lên nhóm",
    "icon": FontAwesomeIcons.users
  },
  {
    "key": "share-option",
    "label": "Tuỳ chọn khác",
    "icon": FontAwesomeIcons.arrowUpRightFromSquare
  },
];

class _ShareModalBottomState extends ConsumerState<ShareModalBottom> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var meData = ref.watch(meControllerProvider)[0];
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (focusNode.hasFocus) {
          focusNode.unfocus();
        }
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    visible: !focusNode.hasFocus,
                    child: const Text('123'),
                  ),
                  Visibility(
                    visible: focusNode.hasFocus,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (focusNode.hasFocus) {
                                focusNode.unfocus();
                              }
                            },
                            child: const Icon(
                              FontAwesomeIcons.chevronLeft,
                              size: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Chia sẻ',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            children: [
                              AvatarSocial(
                                  width: 36,
                                  height: 36,
                                  path: meData['avatar_media'] != null
                                      ? meData['avatar_media']['preview_url']
                                      : meData['avatar_static']),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, bottom: 10, top: 4),
                                      child: Text(
                                        meData['display_name'],
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 24,
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 0, 6, 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: greyColor)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Text(
                                                      'Bảng feed',
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 3.0,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0),
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .sortDown,
                                                          color: Colors.black,
                                                          size: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            height: 24,
                                            margin: const EdgeInsets.fromLTRB(
                                                2, 0, 6, 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    width: 0.2,
                                                    color: greyColor)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Row(
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 2.0),
                                                    child: Icon(
                                                        FontAwesomeIcons
                                                            .userGroup,
                                                        color: Colors.black,
                                                        size: 10),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    'Bạn bè',
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: 3.0,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 8.0),
                                                    child: Center(
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .sortDown,
                                                          color: Colors.black,
                                                          size: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextFormField(
                            focusNode: focusNode,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Hãy nói gì đó về nội dung này...'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(right: 10, bottom: 12),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Chia sẻ ngay',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: !focusNode.hasFocus,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: List.generate(
                            iconShareModal.length,
                            (index) => GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, left: 10.0, bottom: 8),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08),
                                      child: Center(
                                        child: Icon(
                                          iconShareModal[index]['icon'],
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    alignment: Alignment.centerLeft,
                                    constraints: BoxConstraints(
                                        minWidth:
                                            MediaQuery.of(context).size.width *
                                                0.1),
                                    child: Text(
                                      iconShareModal[index]['label'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  )
                ],
              ))),
    );
  }
}
