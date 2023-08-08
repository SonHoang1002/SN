import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';

import '../../widgets/skeleton.dart';

class LearnSpaceLibrary extends ConsumerStatefulWidget {
  const LearnSpaceLibrary({super.key});

  @override
  ConsumerState<LearnSpaceLibrary> createState() => _LearnSpaceLibraryState();
}

class _LearnSpaceLibraryState extends ConsumerState<LearnSpaceLibrary> {
  late double width;
  late double height;
  bool isLoading = false;
  bool loadingCourseFile = false;

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    getListCoursesLibraries();
  }

  void getListCoursesLibraries() async {
    setState(() {
      isLoading = true;
    });
    await ref
        .read(learnSpaceStateControllerProvider.notifier)
        .getListCoursesLibraries();
    setState(() {
      isLoading = false;
    });
  }

  void clearTemporaryDirectory() async {
    final directory = await getTemporaryDirectory();
    directory.listSync().forEach((file) {
      if (file is File) {
        file.deleteSync();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List courseLibrary =
        ref.watch(learnSpaceStateControllerProvider).courseLibrary;
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesLibraries();
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                  child: Text(
                    'Thư viện nội dung của bạn',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                isLoading && courseLibrary.isEmpty
                    ? Center(
                        child: SkeletonCustom().eventSkeleton(context),
                      )
                    : courseLibrary.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Không có dữ liệu'),
                          )
                        : SizedBox(
                            child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: courseLibrary.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: 8.0),
                                child: CardComponents(
                                  imageCard: SizedBox(
                                    height: 180,
                                    width: width,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: ExtendedImage.network(
                                        courseLibrary[index]['preview_url'] ??
                                            linkBannerDefault,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      loadingCourseFile = true;
                                    });
                                    String fileUrl = courseLibrary[index]
                                        ['url']; // Đường dẫn đến file
                                    String fileName = fileUrl
                                        .split('/')
                                        .last; // Tên file được trích xuất từ đường dẫn

                                    // Tải file về bằng http
                                    final response =
                                        await http.get(Uri.parse(fileUrl));
                                    final bytes = response.bodyBytes;

                                    // Lưu file vào thư mục tạm trên thiết bị của người dùng
                                    final tempDir =
                                        await getTemporaryDirectory();
                                    final file =
                                        File('${tempDir.path}/$fileName');
                                    await file.writeAsBytes(bytes);
                                    bool permission = await Permission
                                        .manageExternalStorage.isGranted;
                                    if (Platform.isAndroid && !permission) {
                                      PermissionStatus status = await Permission
                                          .manageExternalStorage
                                          .request();
                                      if (status.isGranted) {
                                        OpenFile.open(file.path);
                                      }
                                    } else {
                                      OpenFile.open(file.path);
                                    }
                                    setState(() {
                                      loadingCourseFile = false;
                                    });
                                  },
                                  textCard: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 16.0,
                                        right: 16.0,
                                        left: 16.0,
                                        top: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            courseLibrary[index]['url']
                                                .split('/')
                                                .last
                                                .toString(),
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w800,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
              ],
            ),
          ),
          if (loadingCourseFile)
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
                child: const Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    clearTemporaryDirectory();
  }
}
