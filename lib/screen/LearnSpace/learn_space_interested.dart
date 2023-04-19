import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';

class LearnSpaceInterested extends ConsumerStatefulWidget {
  const LearnSpaceInterested({Key? key}) : super(key: key);

  @override
  ConsumerState<LearnSpaceInterested> createState() =>
      _LearnSpaceInterestedState();
}

class _LearnSpaceInterestedState extends ConsumerState<LearnSpaceInterested> {
  late double width;
  late double height;
  var paramsConfigList = {"limit": 10, "following": true};

  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(learnSpaceStateControllerProvider.notifier)
              .getListCourses(paramsConfigList));
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId =
            ref.read(learnSpaceStateControllerProvider).course.last['id'];
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCourses({"max_id": maxId, ...paramsConfigList});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List course = ref.watch(learnSpaceStateControllerProvider).course;
    bool isMore = ref.watch(learnSpaceStateControllerProvider).isMore;
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCourses(paramsConfigList);
      },
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                'Khoá học quan tâm',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            course.isNotEmpty
                ? SizedBox(
                    child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: course.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (index < course.length) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                          child: CardComponents(
                            type: 'homeScreen',
                            imageCard: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: ImageCacheRender(
                                path: course[index]['banner'] != null
                                    ? course[index]['banner']['url']
                                    : "https://sn.emso.vn/static/media/group_cover.81acfb42.png",
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => LearnSpaceDetail(
                                          data: course[index])));
                            },
                            textCard: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0,
                                  right: 16.0,
                                  left: 16.0,
                                  top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      course[index]['title'],
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w800,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      course[index]['account']['display_name'],
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: greyColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      course[index]['free'] == true
                                          ? 'Miễn phí'
                                          : '${convertNumberToVND(course[index]['price'] ~/ 1)} VNĐ',
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buttonCard: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0, left: 16.0, right: 16.0),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 32,
                                          width: width * 0.7,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  189, 202, 202, 202),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  width: 0.2,
                                                  color: greyColor)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(FontAwesomeIcons.solidStar,
                                                  color: Colors.black,
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
                                              SizedBox(
                                                width: 3.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 11.0,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(10),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) =>
                                                const ShareModalBottom());
                                      },
                                      child: Container(
                                        height: 32,
                                        width: width * 0.12,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                189, 202, 202, 202),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                width: 0.2, color: greyColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(FontAwesomeIcons.share,
                                                color: Colors.black, size: 14),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        isMore == true
                            ? const Center(child: CupertinoActivityIndicator())
                            : const SizedBox();
                      }
                      return null;
                    },
                  ))
                : const SizedBox(),
            isMore == true
                ? const Center(child: CupertinoActivityIndicator())
                : const SizedBox()
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
