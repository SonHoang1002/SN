import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class LearnSpaceLibrary extends ConsumerStatefulWidget {
  const LearnSpaceLibrary({super.key});

  @override
  ConsumerState<LearnSpaceLibrary> createState() => _LearnSpaceLibraryState();
}

class _LearnSpaceLibraryState extends ConsumerState<LearnSpaceLibrary> {
  late double width;
  late double height;
  bool isLoading = false;

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    getListCoursesLibraries();
  }

  void getListCoursesLibraries() async {
    isLoading = true;
    final result = await ref.read(learnSpaceStateControllerProvider.notifier).getListCoursesLibraries();
    if (result == null || result != null) {
      setState(() {
        isLoading = false;
      });
    }
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
    List courseLibrary = ref.watch(learnSpaceStateControllerProvider).courseLibrary;
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        ref.read(learnSpaceStateControllerProvider.notifier).getListCoursesLibraries();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                'Thư viện nội dung của bạn',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
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
                          if (index < courseLibrary.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                              child: CardComponents(
                                imageCard: ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                  child: ImageCacheRender(
                                    path: courseLibrary[index]['preview_url'] ?? "https://sn.emso.vn/static/media/group_cover.81acfb42.png",
                                  ),
                                ),
                                onTap: () async {
                                  String fileUrl = courseLibrary[index]['url']; // Đường dẫn đến file
                                  String fileName = fileUrl.split('/').last; // Tên file được trích xuất từ đường dẫn

                                  // Tải file về bằng http
                                  final response = await http.get(Uri.parse(fileUrl));
                                  final bytes = response.bodyBytes;

                                  // Lưu file vào thư mục tạm trên thiết bị của người dùng
                                  final tempDir = await getTemporaryDirectory();
                                  final file = File('${tempDir.path}/$fileName');
                                  await file.writeAsBytes(bytes);
                                  bool permission = await Permission.manageExternalStorage.isGranted;
                                  if (Platform.isAndroid && !permission) {
                                    PermissionStatus status = await Permission.manageExternalStorage.request();
                                    if (status.isGranted) {
                                      OpenFile.open(file.path);
                                    }
                                  } else {
                                    OpenFile.open(file.path);
                                  }
                                },
                                textCard: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0, top: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          courseLibrary[index]['url'].split('/').last.toString(),
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
                          } else {
                            return null;
                          }
                        },
                      )),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    clearTemporaryDirectory();
  }
}
