import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          ),
        ],
      )),
    );
  }
}

class RenderInvitePage extends StatelessWidget {
  final String title;
  final List listInvites;
  const RenderInvitePage(
      {super.key, required this.title, required this.listInvites});

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
              title,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            if (listInvites.isNotEmpty)
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
        listInvites.isEmpty
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
                itemCount: listInvites.length,
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
                                    object: listInvites[index]['page'],
                                    path: listInvites[index]['page']
                                                ['avatar_media'] !=
                                            null
                                        ? listInvites[index]['page']
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
                                            text: listInvites[index]['account']
                                                ['display_name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge!
                                                    .color),
                                            children: [
                                              TextSpan(
                                                  text: ' đã mời bạn thích ',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${listInvites[index]['page']['title'].length < 30 ? listInvites[index]['page']['title'] : '${listInvites[index]['page']['title'].toString().substring(0, 30)}...'}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color:
                                                              Theme.of(context)
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: size.width - 250,
                                          child: ButtonPrimary(
                                              isPrimary: false,
                                              handlePress: () {},
                                              icon: const Icon(
                                                FontAwesomeIcons.solidThumbsUp,
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
                                            isPrimary: false,
                                            colorButton: greyColorOutlined,
                                            handlePress: () {},
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
