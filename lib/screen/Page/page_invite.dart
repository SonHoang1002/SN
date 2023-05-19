import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/page/page_list_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

class PageInvite extends ConsumerStatefulWidget {
  const PageInvite({super.key});

  @override
  ConsumerState<PageInvite> createState() => _PageInviteState();
}

class _PageInviteState extends ConsumerState<PageInvite> {
  @override
  Widget build(BuildContext context) {
    List inviteManagePage =
        ref.watch(pageListControllerProvider).pageInvitedManage;
    List inviteLikePage = ref.watch(pageListControllerProvider).pageInvitedLike;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: SingleChildScrollView(
          child: Column(
        children: [
          RenderInvitePage(
            title: 'Lời mời quản lý Trang',
            listInvites: inviteManagePage,
            type: 'manage',
          ),
          const Padding(
            padding: EdgeInsets.all(6.0),
            child: Divider(
              height: 3,
              thickness: 1.1,
            ),
          ),
          RenderInvitePage(
            title: 'Lời mời thích Trang',
            listInvites: inviteLikePage,
            type: 'like',
          ),
        ],
      )),
    );
  }
}

class RenderInvitePage extends ConsumerStatefulWidget {
  final String title;
  final List listInvites;
  final String? type;
  const RenderInvitePage(
      {super.key, required this.title, required this.listInvites, this.type});
  @override
  ConsumerState<RenderInvitePage> createState() => _RenderInvitePageState();
}

class _RenderInvitePageState extends ConsumerState<RenderInvitePage> {
  String typeInviteManage = '';
  List<int> hiddenIndexes = [];
  String typeInviteLike = '';
  List<int> hiddenIndexesLike = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            if (widget.listInvites.isNotEmpty)
              InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
              )
          ],
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
                itemBuilder: ((context, index) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      // height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 0.0,
                                ),
                                AvatarSocial(
                                    width: 60,
                                    height: 60,
                                    object: widget.listInvites[index]['page'],
                                    path: widget.listInvites[index]['page']
                                                ['avatar_media'] !=
                                            null
                                        ? widget.listInvites[index]['page']
                                            ['avatar_media']['preview_url']
                                        : linkAvatarDefault),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width - 112,
                                      child: RichText(
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: widget.listInvites[index]
                                                ['account']['display_name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge!
                                                    .color),
                                            children: widget.type == 'manage'
                                                ? [
                                                    TextSpan(
                                                      text:
                                                          ' đã mời bạn làm ${widget.listInvites[index]['role'] == 'moderator' ? 'người kiểm duyệt' : 'quản trị viên'} một trang',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  ]
                                                : [
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
                                    typeInviteManage != "" &&
                                                hiddenIndexes.contains(index) ||
                                            typeInviteLike != "" &&
                                                hiddenIndexesLike
                                                    .contains(index)
                                        ? Text(
                                            typeInviteManage == "approved" ||
                                                    typeInviteLike == "approved"
                                                ? "Bạn dã chấp nhận lời mời này"
                                                : "Bạn dã từ chối lời mời này",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
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
                                                      if (widget.type ==
                                                          'manage') {
                                                        setState(() {
                                                          typeInviteManage =
                                                              "approved";
                                                          hiddenIndexes
                                                              .add(index);
                                                          PageApi()
                                                              .postInviteManage(
                                                            {
                                                              "type": "approved"
                                                            },
                                                            widget.listInvites[
                                                                    index]
                                                                ['page']['id'],
                                                          );
                                                        });
                                                      } else {
                                                        setState(() {
                                                          typeInviteLike =
                                                              "approved";
                                                          hiddenIndexesLike
                                                              .add(index);
                                                          PageApi()
                                                              .postInviteLike(
                                                            {
                                                              "type": "approved"
                                                            },
                                                            widget.listInvites[
                                                                    index]
                                                                ['page']['id'],
                                                          );
                                                        });
                                                      }
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
                                                    if (widget.type ==
                                                        'manage') {
                                                      setState(() {
                                                        typeInviteManage =
                                                            "rejected";
                                                        hiddenIndexes
                                                            .add(index);
                                                        PageApi()
                                                            .postInviteManage(
                                                          {"type": "rejected"},
                                                          widget.listInvites[
                                                                  index]['page']
                                                              ['id'],
                                                        );
                                                      });
                                                    } else {
                                                      setState(() {
                                                        typeInviteLike =
                                                            "rejected";
                                                        hiddenIndexesLike
                                                            .add(index);
                                                        PageApi()
                                                            .postInviteLike(
                                                          {"type": "rejected"},
                                                          widget.listInvites[
                                                                  index]['page']
                                                              ['id'],
                                                        );
                                                      });
                                                    }
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
                    ))),
      ],
    );
  }
}
