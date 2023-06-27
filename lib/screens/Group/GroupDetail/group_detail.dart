import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/AvatarStack/src/avatar_stack.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

import '../../../widgets/AvatarStack/positions.dart';

class GroupDetail extends ConsumerStatefulWidget {
  final String id;
  const GroupDetail({super.key, required this.id});

  @override
  ConsumerState<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends ConsumerState<GroupDetail> {
  final settings = RestrictedPositions(
    maxCoverage: 0.3,
    minCoverage: 0.2,
    laying: StackLaying.first,
  );
  String getAvatarUrl(int n) {
    final url = 'https://i.pravatar.cc/150?img=$n';
    return url;
  }

  var groupDetail = {};
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(groupListControllerProvider.notifier)
          .getGroupDetail(widget.id)
          .then((value) {
        setState(() {
          groupDetail = ref.read(groupListControllerProvider).groupDetail;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(
          title: groupDetail['title'] ?? '',
        ),
      ),
      body: SingleChildScrollView(
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
                      groupDetail['banner'] != null
                          ? groupDetail['banner']['preview_url']
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
                          backgroundColor: colorTransparent),
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
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                            text: groupDetail['title'],
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
                            text: groupDetail['is_private'] == true
                                ? 'Nhóm Riêng tư'
                                : '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            )),
                        TextSpan(
                            text:
                                ' \u{2022} ${groupDetail['member_count']} thành viên',
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
                            icon: const Icon(Icons.settings, size: 18),
                            handlePress: () {},
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          width: size.width * 0.44,
                          child: ButtonPrimary(
                            label: 'Mời',
                            isGrey: true,
                            colorText: Colors.black,
                            handlePress: () {},
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
