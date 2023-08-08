import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screens/LearnSpace/learn_space_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';

import '../../widgets/skeleton.dart';

class LearnSpaceHost extends ConsumerStatefulWidget {
  const LearnSpaceHost({Key? key}) : super(key: key);

  @override
  ConsumerState<LearnSpaceHost> createState() => _LearnSpaceHostState();
}

class _LearnSpaceHostState extends ConsumerState<LearnSpaceHost> {
  late double width;
  late double height;
  var paramsConfigList = {"limit": 10, "only_current_user": true};
  final scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () {
        fetchData(paramsConfigList);
      });
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId =
            ref.read(learnSpaceStateControllerProvider).coursesHost.last['id'];
        fetchData({"max_id": maxId, ...paramsConfigList});
      }
    });
  }

  void fetchData(params) async {
    setState(() {
      isLoading = true;
    });
    await ref
        .read(learnSpaceStateControllerProvider.notifier)
        .getListCoursesHost(params);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMore = ref.watch(learnSpaceStateControllerProvider).isMore;
    List course = ref.watch(learnSpaceStateControllerProvider).coursesHost;
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        fetchData(paramsConfigList);
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
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                        child: CardComponents(
                          // type: 'homeScreen',
                          imageCard: SizedBox(
                            height: 180,
                            width: width,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: ExtendedImage.network(
                                course[index]['banner'] != null
                                    ? course[index]['banner']['url']
                                    : linkBannerDefault,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        LearnSpaceDetail(data: course[index])));
                          },
                          textCard: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0, right: 16.0, left: 16.0, top: 8),
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
                                        : course[index]['status'] == 'approved'
                                            ? 'Đã duyệt'
                                            : 'Đang chờ',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: course[index]['status'] == 'draft'
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
                    },
                  ))
                : const SizedBox(),
            isLoading && course.isEmpty || isMore == true
                ? Center(child: SkeletonCustom().eventSkeleton(context))
                : course.isEmpty
                    ? Column(
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/wow-emo-2.gif",
                              height: 125.0,
                              width: 125.0,
                            ),
                          ),
                          const Text('Không tìm thấy kết quả nào'),
                        ],
                      )
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
