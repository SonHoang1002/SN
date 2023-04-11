import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/recruit/recruit_provider.dart';
import 'package:social_network_app_mobile/screen/Recruit/recruit_intro.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class RecruitDetail extends ConsumerStatefulWidget {
  final dynamic data;
  const RecruitDetail({Key? key, this.data}) : super(key: key);

  @override
  ConsumerState<RecruitDetail> createState() => _RecruitDetailState();
}

class _RecruitDetailState extends ConsumerState<RecruitDetail> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(recruitControllerProvider.notifier)
              .getDetailRecruit(widget.data['id']));
      Future.delayed(
          Duration.zero,
          () => ref
              .read(recruitControllerProvider.notifier)
              .getListRecruitPropose(
                  {'exclude_current_user': true, 'limit': 5}));
      Future.delayed(
          Duration.zero,
          () => ref
                  .read(recruitControllerProvider.notifier)
                  .getListRecruitSimilar({
                'recruit_id': widget.data['id'],
                'recruit_category_id': widget.data['recruit_category']['id'],
                'limit': 5,
                'time': 'upcoming'
              }));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var recruitDetail = ref.watch(recruitControllerProvider).detailRecruit;

    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 26,
            width: 26,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(width: 0.2, color: greyColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(FontAwesomeIcons.angleLeft, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: recruitDetail.isNotEmpty
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Hero(
                              tag: recruitDetail['banner']['url'] ?? "",
                              child: ClipRRect(
                                child: ImageCacheRender(
                                  path: recruitDetail['banner']['url'] ?? "",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hạn nộp hồ sơ: ${GetTimeAgo.parse(
                                  DateTime.parse(recruitDetail['created_at']),
                                )}',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                recruitDetail['title'],
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 8.0),
                        child: Row(
                          children: [
                            Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.44,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        189, 202, 202, 202),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        width: 0.2, color: greyColor)),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(FontAwesomeIcons.solidStar,
                                          size: 14),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        'Quan tâm',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ])),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.44,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        189, 202, 202, 202),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        width: 0.2, color: greyColor)),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Mời',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ])),
                          ],
                        ),
                      ),
                      RecruitIntro(recruitDetail: recruitDetail),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }
}
