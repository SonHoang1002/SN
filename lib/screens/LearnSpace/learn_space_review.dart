import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/learn_space_api.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'dart:io';
import 'dart:convert';

import '../../apis/media_api.dart';

class LearnSpaceReview extends ConsumerStatefulWidget {
  final dynamic courseDetail;
  const LearnSpaceReview({super.key, this.courseDetail});

  @override
  ConsumerState<LearnSpaceReview> createState() => _LearnSpaceReviewState();
}

class _LearnSpaceReviewState extends ConsumerState<LearnSpaceReview> {
  File? _pickedCoverImage;
  XFile? _imageCover;
  bool isLoading = false;
  String errorMessage = '';
  bool hasImage = false;

  final TextEditingController reviewController =
      TextEditingController(text: '');
  int point = 5;

  Future<String> imageToBase64(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final base64Str = base64Encode(bytes);
    return 'data:image/jpeg;base64,$base64Str';
  }

  handleUploadMedia(fileData) async {
    fileData = fileData.replaceAll('file://', '');
    FormData formData;

    formData = FormData.fromMap({
      "description": '',
      "position": 1,
      "file": await MultipartFile.fromFile(fileData,
          filename: fileData.split('/').last),
    });
    var response = await MediaApi().uploadMediaEmso(formData);

    return response;
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(learnSpaceStateControllerProvider.notifier)
              .getListCourseReview(widget.courseDetail['id']));
    }
  }

  handleSubmit(BuildContext context) async {
    String message = '';

    if (hasImage) {
      var mediaUploadResult = await handleUploadMedia(_imageCover!.path);
      if (mediaUploadResult == null) {
        message =
            'Có lỗi xảy ra trong quá trình upload ảnh, vui lòng thử lại sau!';
        return message;
      }
      var response = await LearnSpaceApi().sendRatingPost(
        widget.courseDetail['id'],
        {
          "status": reviewController.text.trim(),
          "rating": point.toString(),
          "media_ids": [mediaUploadResult['id']],
        },
      );

      if (response == null) {
        message = 'Có lỗi xảy ra trong quá trình đăng';
      } else if (response['error'] != null) {
        message = response['error'];
      } else {
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCourseReview(widget.courseDetail['id']);
        message = 'Đăng bài đánh giá thành công!';
      }
    } else {
      var response;
      if (reviewController.text != "") {
        response = await LearnSpaceApi().sendRatingPost(
          widget.courseDetail['id'],
          {
            "status": reviewController.text.trim(),
            "rating": point.toString(),
          },
        );
      }

      if (response == null) {
        message = 'Có lỗi xảy ra trong quá trình đăng, hãy xem lại bài viết';
      } else if (response['error'] != null) {
        message = response['error'];
      } else {
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCourseReview(widget.courseDetail['id']);
        message = 'Đăng bài đánh giá thành công!';
      }
    }

    return message;
  }

  @override
  Widget build(BuildContext context) {
    final courseReview =
        ref.watch(learnSpaceStateControllerProvider).courseReview;
    final width = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              height: 20,
              thickness: 1,
            ),
            const Text('Xếp hạng khóa học này', style: TextStyle(fontSize: 17)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cho chúng tôi biết suy nghĩ của bạn.',
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                    onPressed: () {
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) => StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          var snackbar = ScaffoldMessenger.of(context);
                          return SingleChildScrollView(
                            primary: true,
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom *
                                        0.9),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                              child: SizedBox(
                                height: 450,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        5,
                                        (index) => index < point
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    point = index + 1;
                                                  });
                                                },
                                                child: const Icon(Icons.star,
                                                    size: 35,
                                                    color: Colors.yellow))
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    point = index + 1;
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.star_border,
                                                  size: 35,
                                                  color: greyColor,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: reviewController,
                                      maxLines: 4,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          hintText: "Viết đánh giá của bạn",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)))),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        _imageCover = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        setState(() {
                                          _pickedCoverImage =
                                              File(_imageCover!.path);
                                          isLoading = false;
                                          hasImage = true;
                                        });
                                      },
                                      child: Container(
                                        height: 175,
                                        width: width,
                                        margin:
                                            const EdgeInsets.only(top: 15.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: _pickedCoverImage != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                child: Image.file(
                                                  _pickedCoverImage!,
                                                  fit: BoxFit.cover,
                                                  height: 175,
                                                  width: width,
                                                ),
                                              )
                                            : Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    isLoading
                                                        ? const CupertinoActivityIndicator()
                                                        : const Icon(
                                                            Icons.camera_alt,
                                                            size: 25.0,
                                                            color: Colors.black,
                                                          ),
                                                    const Text(
                                                      "Chọn ảnh từ thiết bị",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(
                                              MediaQuery.sizeOf(context).width,
                                              45),
                                          foregroundColor:
                                              Colors.white, // foreground
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          String strMessage =
                                              await handleSubmit(context);
                                          Navigator.pop(context);
                                          snackbar.showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Text(strMessage),
                                            ),
                                          );
                                          setState(() {
                                            reviewController.text = '';
                                            isLoading = false;
                                            _pickedCoverImage = null;
                                            _imageCover = null;
                                            hasImage = false;
                                          });
                                        },
                                        child: isLoading
                                            ? const CupertinoActivityIndicator(
                                                color: Colors.white,
                                              )
                                            : const Text('Đánh giá'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                    child: const Text('Viết bài đánh giá'))
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            if (courseReview.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: courseReview.length,
                    itemBuilder: (context, index) {
                      return Post(
                          post: courseReview[index]['comment'],
                          data: courseReview[index],
                          type: 'rating');
                    }),
              )
            else
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 20),
                child: Text("Chưa có đánh giá nào!",
                    style: TextStyle(
                      color: colorWord(context),
                      fontWeight: FontWeight.bold,
                    )),
              )
          ],
        ),
      ),
    );
  }
}
