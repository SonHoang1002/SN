import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/apis/market_place_apis/review_product_apis.dart';
import 'package:market_place/apis/media_api.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/cross_bar.dart';
import 'package:market_place/widgets/image_cache.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';
import 'package:market_place/widgets/video_render_player.dart';

class ReviewProductMarketPage extends ConsumerStatefulWidget {
  final List<dynamic>? completeProductList;
  final dynamic reviewId;
  const ReviewProductMarketPage(
      {super.key, required this.completeProductList, required this.reviewId});

  @override
  ConsumerState<ReviewProductMarketPage> createState() =>
      _ReviewProductMarketPageState();
}

class _ReviewProductMarketPageState
    extends ConsumerState<ReviewProductMarketPage> {
  late double width = 0;
  late double height = 0;
  List<int>? _starQualityList = [];
  List<int>? _starServiceList = [];
  List<int>? _starTranferList = [];
  List<TextEditingController>? reviewControllerList = [];

  List<String>? _selectedSizeList = [];
  List<List<File>>? _imgFileList = [];
  List<bool>? _showSwitchList = [];
  List _videoFileList = [];
  Color? colorTheme;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    for (var element in widget.completeProductList!) {
      _starQualityList!.add(0);
      _starServiceList!.add(0);
      _starTranferList!.add(0);
      reviewControllerList!.add(TextEditingController(text: ""));
      _selectedSizeList!.add("");
      _imgFileList!.add([]);
      _videoFileList.add(null);
      _showSwitchList!.add(false);
    }
    setState(() {});
  }

// hướng dẫn, mã giảm giá, chất lượng, mô tả, ảnh, video, thẻ mô tả, kích thước, hiển thị tên, dịch vụ người bạn, dịch vụ vận chuyển.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    colorTheme = ThemeMode.dark == true
        ? Theme.of(context).cardColor
        : const Color(0xfff1f2f5);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(text: "Đánh giá sản phẩm"),
              GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await _createReviewProduct();
                  },
                  child: const AppBarTitle(text: "Gửi"))
            ],
          ),
        ),
        body: _isLoading
            ? buildCircularProgressIndicator()
            : Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(
                          widget.completeProductList!.length, (index) {
                        return Column(
                          children: [
                            index == 0
                                ? const SizedBox(
                                    height: 40,
                                  )
                                : const CrossBar(
                                    height: 10,
                                  ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  _voucherApply(index),
                                  _ratingComponent(
                                      index, "Chất lượng sản phẩm", "quality"),
                                  buildDivider(color: greyColor, height: 10),
                                  buildTextContent(
                                      "Thêm 50 ký tự, 1-5 hình ảnh và 1 video để nhận đến 200 ECoin",
                                      false,
                                      fontSize: 15,
                                      isCenterLeft: false,
                                      colorWord: greyColor),
                                  _getImageAndVideo(
                                    index,
                                  ),
                                  buildSpacer(height: 10),
                                  _getDescription(
                                    index,
                                  ),
                                  buildSpacer(height: 10),
                                  _showUserName(
                                    index,
                                  ),
                                  buildDivider(color: greyColor, height: 10),
                                  _ratingComponent(index,
                                      "Dịch vụ của người bán", "service"),
                                  buildDivider(color: greyColor, height: 10),
                                  _ratingComponent(
                                      index, "Dịch vụ vận chuyển", "tranfer"),
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_instructStandardReview(), const SizedBox()],
                  ),
                ],
              ));
  }

  Future _createReviewProduct() async {
    List<List<String>> imgIdList = [];
    List<String> videoIdList = [];

    for (var element in _imgFileList!) {
      imgIdList.add([]);
    }
    for (int i = 0; i < _imgFileList!.length; i++) {
      if (_imgFileList!.isEmpty) {
        imgIdList[i] = [];
      } else {
        imgIdList[i] = (await Future.wait(_imgFileList![i].map((element) async {
          if (element == null || element == "") {
            return "";
          }
          String fileName = element.path.split('/').last;
          FormData formData = FormData.fromMap({
            "file":
                await MultipartFile.fromFile(element.path, filename: fileName),
          });
          final response = await MediaApi().uploadMediaEmso(formData);
          return response["id"].toString();
        }).toList()));
      }
    }

    if (_videoFileList.isNotEmpty) {
      videoIdList = (await Future.wait(_videoFileList.map((element) async {
        if (element != null) {
          String fileName = element.split('/').last;
          FormData formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(element, filename: fileName),
          });
          final response = await MediaApi().uploadMediaEmso(formData);
          return response["id"].toString();
        }
        return "";
      }).toList()));
    }
    List<Map<String, dynamic>> reviewProductData = [];
    for (int i = 0; i < reviewControllerList!.length; i++) {
      List<String> mediaList = [];
      imgIdList[i].forEach((element) {
        mediaList.add(element);
      });
      if (videoIdList[i] != null || videoIdList[i] != "") {
        mediaList.add(videoIdList[i]);
      }
      reviewProductData.add({
        "media_ids": mediaList,
        "product_variant_id": widget.completeProductList![i]["product_variant"]
            ["id"],
        "status": reviewControllerList![i].text.trim(),
        "rating_point": _starQualityList![i]
      });
    }
    var response;
    Future.delayed(Duration.zero, () async {
      response = ReviewProductApi()
          .createReviewProductApi(widget.reviewId, reviewProductData);
    });
    buildMessageDialog(
      context,
      response.toString() ?? "Chỉ được đánh giá một lần duy nhất",
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<List<String>> _convertImageToId(List<dynamic> mediaList) async {
    List<String> result = await Future.wait(mediaList.map((element) async {
      String fileName = element.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(element.path, filename: fileName),
      });
      final response = await MediaApi().uploadMediaEmso(formData);
      return response["id"].toString();
    }));
    return result;
  }

  Widget _instructStandardReview() {
    return GeneralComponent(
      [
        buildTextContent(
            "Xem hướng dẫn đánh giá chuẩn để nhận đến 200 xu", false,
            fontSize: 17)
      ],
      suffixWidget: const SizedBox(
        width: 20,
        height: 20,
        child: Icon(
          FontAwesomeIcons.chevronRight,
          size: 17,
        ),
      ),
      prefixWidget: Container(
        width: 40,
        height: 40,
        color: red,
      ),
      changeBackground: greyColor[700]!.withOpacity(0.8),
      padding: const EdgeInsets.all(5),
      borderRadiusValue: 0,
    );
  }

  Widget _voucherApply(int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: buildDivider(color: greyColor),
        ),
        GeneralComponent(
          [
            buildTextContent(
                "Mã ABC giả đến 30k đơn 120k - ${widget.completeProductList![index]["product_variant"]["title"]}",
                false,
                fontSize: 17,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(
              height: 10,
            ),
            buildTextContent(
                "Phân loại: ${widget.completeProductList![index]["product_variant"]["option1"] ?? ""} ${widget.completeProductList![index]["product_variant"]["option2"] ?? ""}",
                false,
                fontSize: 14,
                colorWord: greyColor),
          ],
          suffixWidget: const SizedBox(
            width: 20,
            height: 20,
            child: Icon(
              FontAwesomeIcons.chevronRight,
              size: 17,
            ),
          ),
          prefixWidget: SizedBox(
            width: 40,
            height: 40,
            child: ImageCacheRender(
                path: widget.completeProductList![index]["product_variant"]
                            ["image"] !=
                        null
                    ? widget.completeProductList![index]["product_variant"]
                        ["image"]["url"]
                    : "https://kynguyenlamdep.com/wp-content/uploads/2022/01/hinh-anh-meo-con-sieu-cute-700x467.jpg"),
          ),
          changeBackground: transparent,
          padding: EdgeInsets.zero,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: buildDivider(color: greyColor),
        ),
      ],
    );
  }

  Widget _ratingComponent(int index, String title, String key) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
          margin: const EdgeInsets.only(left: 20),
          child: buildTextContent(
            title,
            true,
            fontSize: 16,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              _buildRatingStarWidget(index, key),
              buildSpacer(height: 5),
              _changeDescriptionRating(index, key)
            ],
          ),
        )
      ],
    );
  }

  Widget _getImageAndVideo(int mediaIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: _imgFileList![mediaIndex].isEmpty
              ? _buildSelectImageVideo(
                  mediaIndex,
                  "Thêm hình ảnh",
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          _imgFileList![mediaIndex].length + 1, (index) {
                    if (index < _imgFileList![mediaIndex].length) {
                      return Container(
                        margin: const EdgeInsets.only(right: 10, top: 10),
                        height: 100,
                        width: 80,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.file(
                                  _imgFileList![mediaIndex][index],
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5, left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _imgFileList![mediaIndex].remove(
                                          _imgFileList![mediaIndex][index]);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: white.withOpacity(0.5),
                                          border: Border.all(
                                              color: greyColor, width: 0.4),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      if (index != 5) {
                        return _buildSelectImageVideo(
                            mediaIndex, "Thêm hình ảnh",
                            width: 120);
                      } else {
                        return const SizedBox();
                      }
                    }
                  })),
                ),
        ),
        Container(
          child: _videoFileList[mediaIndex] == null ||
                  _videoFileList[mediaIndex] == ""
              ? _buildSelectImageVideo(
                  mediaIndex,
                  "Thêm video",
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, top: 10),
                    height: 100,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: VideoPlayerRender(
                              path: _videoFileList[mediaIndex],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5, left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _videoFileList[mediaIndex] = null;
                                  });
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: white.withOpacity(0.5),
                                      border: Border.all(
                                          color: greyColor, width: 0.4),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
        )
      ],
    );
  }

  Widget _getDescription(int index) {
    return Container(
        height: 200,
        color: ThemeMode.dark == true
            ? Theme.of(context).cardColor
            : greyColor[400]!.withOpacity(0.4),
        child: _buildInput(
            reviewControllerList![index], width, "Nhập mô tả vào đây"));
  }

  Widget _showUserName(int index) {
    return GeneralComponent(
      [
        buildTextContent("Hiển thị tên đăng nhập trên đánh giá này", false,
            fontSize: 17),
        buildSpacer(height: 5),
        buildTextContent("Tên tài khoản của bạn sẽ hiển thị như abcdef", false,
            fontSize: 15, colorWord: greyColor),
      ],
      suffixWidget: Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 10),
          child: Switch(
            onChanged: (value) {
              setState(() {
                _showSwitchList![index] = value as bool;
              });
            },
            value: _showSwitchList![index],
          )),
      changeBackground: transparent,
    );
  }

// general
  Widget _changeDescriptionRating(int index, String key) {
    String description = "Không có đánh giá";
    Color wordColor = greyColor;
    int value;
    switch (key) {
      case "quality":
        value = _starQualityList![index];
        break;
      case "service":
        value = _starServiceList![index];
        break;
      default:
        value = _starTranferList![index];
        break;
    }
    switch (value) {
      case 1:
        description = "Rất tệ";
        wordColor = Colors.purple;
        break;
      case 2:
        description = "Tệ";
        wordColor = red;

        break;
      case 3:
        description = "Bình thường";

        break;
      case 4:
        description = "Tốt";
        wordColor = Colors.green;

        break;
      case 5:
        description = "Rất tốt";
        wordColor = Colors.blue;

        break;
      default:
        break;
    }
    return buildTextContent(description, false,
        fontSize: 15,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        colorWord: wordColor);
  }

  Widget _buildRatingStarWidget(int index, String key) {
    return Row(
        children: List.generate(5, (indexList) {
      return Container(
          margin: const EdgeInsets.only(right: 10),
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: () {
              switch (key) {
                case "quality":
                  _starQualityList![index] = indexList + 1;
                  break;
                case "service":
                  _starServiceList![index] = indexList + 1;
                  break;
                default:
                  _starTranferList![index] = indexList + 1;
                  break;
              }
              setState(() {});
            },
            child: Icon(
              Icons.star,
              color: (key == "quality"
                              ? _starQualityList![index]
                              : key == "service"
                                  ? _starServiceList![index]
                                  : _starTranferList![index]) -
                          1 >=
                      indexList
                  ? Colors.yellow[700]
                  : greyColor,
              size: 20,
            ),
          ));
    }).toList());
  }

  Widget _buildSelectImageVideo(int index, String title, {double? width}) {
    return InkWell(
      onTap: () {
        title == "Thêm hình ảnh"
            ? dialogSelectSource(index, true)
            : dialogSelectSource(index, false);
      },
      child: Container(
          height: 100,
          width: width ?? 250,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              border: Border.all(color: greyColor, width: 0.6),
              borderRadius: BorderRadius.circular(7)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  title == "Thêm hình ảnh"
                      ? FontAwesomeIcons.camera
                      : FontAwesomeIcons.video,
                  color: red,
                  size: 20,
                ),
                buildSpacer(height: 15),
                buildTextContent(title, false,
                    fontSize: 13, colorWord: primaryColor, isCenterLeft: false),
              ])),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    double width,
    String hintText, {
    IconData? iconData,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      width: width * 0.9,
      child: TextFormField(
        controller: controller,
        maxLines: 10,
        keyboardType: keyboardType ?? TextInputType.text,
        validator: (value) {},
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            border: InputBorder.none,
            hintText: hintText,
            prefixIcon: iconData != null
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      iconData,
                      size: 15,
                    ),
                  )
                : null),
      ),
    );
  }

  void dialogSelectSource(int index, bool isImage) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Camera"),
                    onTap: () {
                      popToPreviousScreen(context);
                      isImage
                          ? getImage(index, ImageSource.camera)
                          : getVideo(index, ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Thư viện"),
                    onTap: () {
                      popToPreviousScreen(context);
                      isImage
                          ? getImage(index, ImageSource.gallery)
                          : getVideo(index, ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(int index, ImageSource src) async {
    XFile selectedImage = XFile("");
    selectedImage = (await ImagePicker().pickImage(source: src))!;
    setState(() {
      _imgFileList![index]
          .add(File(selectedImage.path != null ? selectedImage.path : ""));
    });
  }

  Future getVideo(int index, ImageSource src) async {
    XFile selectedVideo = XFile("");
    selectedVideo = (await ImagePicker().pickVideo(source: src))!;
    if (selectedVideo.path != "") {
      setState(() {
        _videoFileList[index] = selectedVideo.path;
      });
    }
  }
}
