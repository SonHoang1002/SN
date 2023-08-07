import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';

import '../../theme/colors.dart';

class LearnSpaceCourse extends ConsumerStatefulWidget {
  final String? id;
  final ScrollController scrollController;
  const LearnSpaceCourse({super.key, this.id, required this.scrollController});

  @override
  ConsumerState<LearnSpaceCourse> createState() => _LearnSpaceCourseState();
}

class _LearnSpaceCourseState extends ConsumerState<LearnSpaceCourse> {
  String menuSelected = "";
  bool loadingCourse = false;
  bool loadingCourseFile = false;
  String currentChapterId = '-1';
  List courseLessonChapter = [];
  int indexChapter = -1;
  int limit = 10;
  int offset = 0;
  bool isLoading = false;
  List courseChapter = [];
  List addCourseChapter = [];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (currentChapterId == '-1') {
      await ref
          .read(learnSpaceStateControllerProvider.notifier)
          .getListCoursesChapter({"limit": limit, "offset": offset}, widget.id);
    }
    if (mounted) {
      setState(() {
        courseChapter =
            ref.read(learnSpaceStateControllerProvider).courseChapter;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent ==
              widget.scrollController.offset &&
          !isLoading) {
        if (mounted) {
          getListChapter();
        }
      }
    });
  }

  Future<void> getListChapter() async {
    // Đánh dấu đang tải dữ liệu
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    if (courseChapter != []) {
      await ref
          .read(learnSpaceStateControllerProvider.notifier)
          .getListCoursesChapter(
              {"limit": limit, "offset": offset += 10}, widget.id);
    }
    if (mounted) {
      setState(() {
        if (ref.watch(learnSpaceStateControllerProvider).courseChapter != []) {
          addCourseChapter = ref.watch(learnSpaceStateControllerProvider).courseChapter;
          courseChapter.addAll(addCourseChapter);
          isLoading = false; // Kết thúc quá trình tải dữ liệu
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          height: 20,
          thickness: 1,
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              courseChapter.length,
              (index) => InkWell(
                onTap: () async {
                  if (currentChapterId != courseChapter[index]['id']) {
                    setState(() {
                      menuSelected = courseChapter[index]['title'];
                      currentChapterId = courseChapter[index]['id'];
                      loadingCourse = true;
                      indexChapter = index;
                    });

                    await ref
                        .read(learnSpaceStateControllerProvider.notifier)
                        .getListCoursesLessonChapter(
                      {"chapter_id": courseChapter[index]['id']},
                    );
                    setState(() {
                      courseLessonChapter = ref
                          .watch(learnSpaceStateControllerProvider)
                          .courseLessonChapter;
                      loadingCourse = false;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: menuSelected == courseChapter[index]['title']
                                ? primaryColor
                                : Theme.of(context).colorScheme.background),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 6.0),
                            Flexible(child: Text(
                              "${index + 1}. " + courseChapter[index]['title'],
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: menuSelected ==
                                          courseChapter[index]['title']
                                      ? white
                                      : null),
                            ),),
                            const SizedBox(width: 6.0),
                          ],
                        ),
                      ),
                      Visibility(
                        // Thiết lập `visible` dựa trên giá trị
                        visible: index == indexChapter,
                        // Nội dung chi tiết ở đây, bạn có thể thay thế bằng bất kỳ widget nào bạn muốn
                        child: menuSelected != ""
                            ? loadingCourse
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.45,
                                    child: const Center(
                                        child: CupertinoActivityIndicator()))
                                : courseLessonChapter.any(
                                        (element) => element['title'] != null)
                                    ? Stack(
                                        children: [
                                          ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            primary: false,
                                            itemCount:
                                                courseLessonChapter.length,
                                            itemBuilder: (context, newIndex) {
                                              return Column(
                                                children: [
                                                  ListTile(
                                                      dense: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 16.0,
                                                              vertical: 0.0),
                                                      visualDensity:
                                                          const VisualDensity(
                                                              horizontal: -4,
                                                              vertical: 0),
                                                      leading: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: Icon(
                                                            FontAwesomeIcons
                                                                .bookOpen,
                                                            size: 18),
                                                      ),
                                                      title: Text(
                                                        courseLessonChapter[
                                                            newIndex]['title'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      subtitle: Text(courseLessonChapter[newIndex]
                                                                              ['course_lesson_attachments']
                                                                          [0]
                                                                      ['attachment']
                                                                  ['type'] ==
                                                              'document'
                                                          ? 'Tài liệu'
                                                          : courseLessonChapter[newIndex]
                                                                              ['course_lesson_attachments'][0]
                                                                          ['attachment']
                                                                      ['type'] ==
                                                                  'video'
                                                              ? 'Video'
                                                              : 'Ảnh'),
                                                      onTap: () async {
                                                        setState(() {
                                                          loadingCourseFile =
                                                              true;
                                                        });
                                                        String fileUrl = courseLessonChapter[
                                                                        newIndex]
                                                                    ['course_lesson_attachments']
                                                                [0]['attachment']
                                                            ['url']; // Đường dẫn đến file
                                                        String fileName = fileUrl
                                                            .split('/')
                                                            .last; // Tên file được trích xuất từ đường dẫn

                                                        // Tải file về bằng http
                                                        final response =
                                                            await http.get(
                                                                Uri.parse(
                                                                    fileUrl));
                                                        final bytes = response.bodyBytes;

                                                        // Lưu file vào thư mục tạm trên thiết bị của người dùng
                                                        final tempDir =
                                                            await getTemporaryDirectory();
                                                        final file = File('${tempDir.path}/$fileName');
                                                        await file.writeAsBytes(
                                                            bytes);
                                                        bool permission =
                                                            await Permission
                                                                .manageExternalStorage
                                                                .isGranted;
                                                        if (Platform
                                                                .isAndroid &&
                                                            !permission) {
                                                          PermissionStatus
                                                              status =
                                                              await Permission
                                                                  .manageExternalStorage
                                                                  .request();
                                                          if (status
                                                              .isGranted) {
                                                            OpenFile.open(
                                                                file.path);
                                                          }
                                                        } else {
                                                          OpenFile.open(
                                                              file.path);
                                                        }
                                                        setState(() {
                                                          loadingCourseFile =
                                                              false;
                                                        });
                                                      }),
                                                  Divider(
                                                    height: 1,
                                                    thickness: 1,
                                                    color: Colors.grey[300],
                                                    indent: 16,
                                                    endIndent: 16,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          loadingCourseFile
                                              ? const Center(
                                                  child: CupertinoActivityIndicator(),
                                                )
                                              : const SizedBox()
                                        ],
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('Không có bài học nào!'),
                                      )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
