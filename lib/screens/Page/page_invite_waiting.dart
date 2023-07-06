import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

import '../../apis/page_api.dart';
import '../../constant/common.dart';
import '../../theme/colors.dart';
import '../../widgets/avatar_social.dart';
import '../../widgets/button_primary.dart';

class PageInviteWaiting extends StatefulWidget {
  final dynamic listInvites;
  const PageInviteWaiting({super.key, this.listInvites});

  @override
  State<PageInviteWaiting> createState() => _PageInviteWaitingState();
}

class _PageInviteWaitingState extends State<PageInviteWaiting> {
  String typeInviteLike = '';
  List<int> hiddenIndexesLike = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Lời mời đang chờ'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 13.0,
              right: 13.0,
            ),
            child: Text('Lời mời đang chờ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          widget.listInvites.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Không có lời mời nào',
                    style: TextStyle(
                        fontSize: 15,
                        color: greyColor,
                        fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.listInvites.length,
                  itemBuilder: ((context, index) => Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 0.0,
                                      ),
                                      AvatarSocial(
                                          width: 60,
                                          height: 60,
                                          object: widget.listInvites[index]
                                              ['page'],
                                          path: widget.listInvites[index]
                                                          ['page']
                                                      ['avatar_media'] !=
                                                  null
                                              ? widget.listInvites[index]
                                                      ['page']['avatar_media']
                                                  ['preview_url']
                                              : linkAvatarDefault),
                                      const SizedBox(
                                        width: 12.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: size.width - 112,
                                            child: RichText(
                                              maxLines: 2,
                                              text: TextSpan(
                                                  text:
                                                      widget.listInvites[index]
                                                              ['account']
                                                          ['display_name'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .displayLarge!
                                                          .color),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            ' đã mời bạn thích ',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '${widget.listInvites[index]['page']['title'].length < 30 ? widget.listInvites[index]['page']['title'] : '${widget.listInvites[index]['page']['title'].toString().substring(0, 30)}...'}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayLarge!
                                                                    .color),
                                                          )
                                                        ])
                                                  ]),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          typeInviteLike != "" &&
                                                  hiddenIndexesLike
                                                      .contains(index)
                                              ? Text(
                                                  typeInviteLike == "approved"
                                                      ? "Bạn dã chấp nhận lời mời này"
                                                      : "Bạn dã từ chối lời mời này",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
                                                      width: size.width - 250,
                                                      child: ButtonPrimary(
                                                          isPrimary: false,
                                                          handlePress: () {
                                                            setState(() {
                                                              typeInviteLike =
                                                                  "approved";
                                                              hiddenIndexesLike
                                                                  .add(index);
                                                              PageApi()
                                                                  .postInviteLike(
                                                                {
                                                                  "type":
                                                                      "approved"
                                                                },
                                                                widget.listInvites[
                                                                            index]
                                                                        ['page']
                                                                    ['id'],
                                                              );
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            FontAwesomeIcons
                                                                .solidThumbsUp,
                                                            size: 16,
                                                            color: white,
                                                          ),
                                                          label: "Chấp nhận"),
                                                    ),
                                                    const SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    SizedBox(
                                                      width: size.width - 290,
                                                      child: ButtonPrimary(
                                                        colorText: Colors.black,
                                                        isPrimary: false,
                                                        colorButton:
                                                            greyColorOutlined,
                                                        handlePress: () {
                                                          setState(() {
                                                            typeInviteLike =
                                                                "rejected";
                                                            hiddenIndexesLike
                                                                .add(index);
                                                            PageApi()
                                                                .postInviteLike(
                                                              {
                                                                "type":
                                                                    "rejected"
                                                              },
                                                              widget.listInvites[
                                                                          index]
                                                                      ['page']
                                                                  ['id'],
                                                            );
                                                          });
                                                        },
                                                        label: "Từ chối",
                                                        isGrey: true,
                                                      ),
                                                    )
                                                  ],
                                                )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            height: 10,
                            thickness: 1,
                            indent: 10,
                            endIndent: 20,
                          )
                        ],
                      ))),
        ],
      ),
    );
  }
}
