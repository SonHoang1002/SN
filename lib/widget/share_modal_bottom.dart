import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class ShareModalBottom extends StatefulWidget {
  const ShareModalBottom({Key? key}) : super(key: key);
  @override
  State<ShareModalBottom> createState() => _ShareModalBottomState();
}

class _ShareModalBottomState extends State<ShareModalBottom> {
  @override
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
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(left: 5),
      height: 350,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              const AvatarSocial(
                  width: 36,
                  height: 36,
                  path:
                      'https://snapi.emso.asia/system/media_attachments/files/109/755/970/747/984/611/small/7536cb0b04ce2155.jpg'),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, bottom: 2),
                      child: const Text(
                        'Trần Trung Nhật',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 18,
                              width: MediaQuery.of(context).size.width * 0.2,
                              margin: const EdgeInsets.fromLTRB(10, 0, 6, 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Bảng feed',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Icon(FontAwesomeIcons.sortDown,
                                        color: Colors.black, size: 12),
                                  ),
                                ],
                              ),
                            )),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 18,
                            width: MediaQuery.of(context).size.width * 0.2,
                            margin: const EdgeInsets.fromLTRB(2, 0, 6, 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(width: 0.2, color: greyColor)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2.0),
                                  child: Icon(FontAwesomeIcons.userGroup,
                                      color: Colors.black, size: 10),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Bạn bè',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Center(
                                    child: Icon(FontAwesomeIcons.sortDown,
                                        color: Colors.black, size: 12),
                                  ),
                                ),
                              ],
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
          TextFormField(
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Hãy nói gì đó về nội dung này...'),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 5),
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(width: 0.2, color: greyColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
          const CrossBar(),
          Column(
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
                            minWidth: MediaQuery.of(context).size.width * 0.08),
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
                          minWidth: MediaQuery.of(context).size.width * 0.1),
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
          ),
        ],
      ),
    );
  }
}
