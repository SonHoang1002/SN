import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/widgets/AvatarStack/avatar_stack.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';

import '../../../widgets/AvatarStack/positions.dart';

class HomeGroup extends StatefulWidget {
  final dynamic groupDetail;
  final Function? onTap;
  const HomeGroup({
    super.key,
    this.onTap,
    this.groupDetail,
  });

  @override
  State<HomeGroup> createState() => _HomeGroupState();
}

class _HomeGroupState extends State<HomeGroup> {
  String menuSelected = '';

  final settings = RestrictedPositions(
    maxCoverage: 0.3,
    minCoverage: 0.2,
    laying: StackLaying.first,
  );
  String getAvatarUrl(int n) {
    final url = 'https://i.pravatar.cc/150?img=$n';
    return url;
  }

  List groupChip = [
    {
      'key': 'intro',
      'label': 'Giới thiệu',
    },
    {
      'key': 'interestion',
      'label': 'Đáng chú ý',
    },
    {
      'key': 'image',
      'label': 'Ảnh',
    },
    {
      'key': 'event',
      'label': 'Sự kiện',
    },
    {
      'key': 'album',
      'label': 'Album',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.25,
                child: ExtendedImage.network(
                  widget.groupDetail['banner'] != null
                      ? widget.groupDetail['banner']['preview_url']
                      : linkBannerDefault,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 10,
                bottom: 0,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 30),
                    elevation: 0,
                    backgroundColor: Colors.transparent.withOpacity(0.5),
                    shadowColor: Colors.transparent.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                        text: widget.groupDetail['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    const WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(Icons.chevron_right,
                          size: 18, color: Colors.grey),
                    )),
                  ],
                )),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    text: TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.only(bottom: 1.0, right: 5.0),
                      child: Icon(Icons.lock, size: 14, color: Colors.grey),
                    )),
                    TextSpan(
                        text: widget.groupDetail['is_private'] == true
                            ? 'Nhóm Riêng tư'
                            : '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                    TextSpan(
                        text:
                            ' \u{2022} ${widget.groupDetail['member_count']} thành viên',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                  ],
                )),
                const SizedBox(
                  height: 10,
                ),
                AvatarStack(
                  height: 40,
                  borderColor: Theme.of(context).scaffoldBackgroundColor,
                  settings: settings,
                  iconEllipse: true,
                  avatars: [
                    for (var n = 0; n < 7; n++)
                      NetworkImage(
                        getAvatarUrl(n),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.44,
                      child: ButtonPrimary(
                        label: 'Quản lý',
                        icon: Image.asset('assets/groups/managerGroup.png',
                            width: 16, height: 16),
                        handlePress: () {
                          widget.onTap!();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: size.width * 0.44,
                      child: ButtonPrimary(
                        label: 'Mời',
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Image.asset('assets/groups/group.png',
                              width: 16, height: 16),
                        ),
                        isGrey: true,
                        handlePress: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
              child: Row(
                children: List.generate(
                  groupChip.length,
                  (index) => InkWell(
                    onTap: () {
                      setState(
                        () {
                          menuSelected = groupChip[index]['key'];
                        },
                      );
                    },
                    child: ChipMenu(
                      isSelected: menuSelected == groupChip[index]['key'],
                      label: groupChip[index]['label'],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
