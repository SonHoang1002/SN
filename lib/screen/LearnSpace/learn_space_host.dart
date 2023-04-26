import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class LearnSpaceHost extends ConsumerStatefulWidget {
  const LearnSpaceHost({Key? key}) : super(key: key);

  @override
  ConsumerState<LearnSpaceHost> createState() => _LearnSpaceHostState();
}

class _LearnSpaceHostState extends ConsumerState<LearnSpaceHost> {
  late double width;
  late double height;
  List course = [];
  var paramsConfigList = {"limit": 10, "only_current_user": true};
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero).then((_) {
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesChipMenu(paramsConfigList)
            .then((value) {
          setState(() {
            course =
                ref.watch(learnSpaceStateControllerProvider).coursesChipMenu;
          });
        }).catchError((error) {
          // handle error
        });
      });
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId = ref
            .read(learnSpaceStateControllerProvider)
            .coursesChipMenu
            .last['id'];
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesChipMenu({"max_id": maxId, ...paramsConfigList});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMore = ref.watch(learnSpaceStateControllerProvider).isMore;
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesChipMenu(paramsConfigList);
      },
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                'Khoá học bạn tổ chức',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            course.any((element) => element['title'] != null)
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
                                      course[index]['status'] == 'draft'
                                          ? 'Bản nháp'
                                          : course[index]['status'] ==
                                                  'approved'
                                              ? 'Đã duyệt'
                                              : 'Đang chờ',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color:
                                            course[index]['status'] == 'draft'
                                                ? Colors.green
                                                : course[index]['status'] ==
                                                        'approved'
                                                    ? Colors.yellow
                                                    : Colors.red,
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
