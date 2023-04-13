import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_intro.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class LearnSpaceDetail extends ConsumerStatefulWidget {
  final dynamic data;
  const LearnSpaceDetail({
    super.key,
    this.data,
  });

  @override
  ConsumerState<LearnSpaceDetail> createState() => _LearnSpaceDetailState();
}

class _LearnSpaceDetailState extends ConsumerState<LearnSpaceDetail> {
  dynamic courseDetail = {};

  @override
  void initState() {
    super.initState();
    if (mounted) {
      loadData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() async {
    await ref
        .read(learnSpaceStateControllerProvider.notifier)
        .getDetailCourses(widget.data['id']);
    await ref
        .read(learnSpaceStateControllerProvider.notifier)
        .getListCoursesSimilar({'only_current_user': true, 'limit': 5});
    await ref
        .read(learnSpaceStateControllerProvider.notifier)
        .getListCoursesPropose({
      'status': 'approved',
      'exclude_current_user': true,
      'limit': 5,
      'visibility': 'public'
    });
    courseDetail = ref.read(learnSpaceStateControllerProvider).detailCourse;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
          child: courseDetail['title'] != null
              ? Container(
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
                      Icon(FontAwesomeIcons.angleLeft,
                          color: Colors.white, size: 16),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        elevation: 0.0,
      ),
      body: courseDetail['title'] != null
          ? Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    ref
                        .read(learnSpaceStateControllerProvider.notifier)
                        .getDetailCourses(widget.data['id']);
                  },
                  child: SingleChildScrollView(
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
                                tag: courseDetail['banner']['url'] ?? "",
                                child: ClipRRect(
                                  child: ImageCacheRender(
                                    path: courseDetail['banner']['url'] ?? "",
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
                                  courseDetail['title'],
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        LearnSpaceIntro(
                          courseDetail: courseDetail,
                        ),
                        const SizedBox(height: 70),
                      ],
                    ),
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
