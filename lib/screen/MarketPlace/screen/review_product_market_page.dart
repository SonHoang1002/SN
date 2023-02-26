import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/a_test/test.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/review_product_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';

import '../../../../widget/back_icon_appbar.dart';

const List<String> _sizes = ["Vừa", "Trật", "Rộng"];

class ReviewProductMarketPage extends ConsumerStatefulWidget {
  final List<dynamic>? completeProductList = get_product_list_for_review;
  ReviewProductMarketPage({
    super.key,
    //  required this.completeProductList
  });

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
  @override
  void initState() {
    super.initState();
  }

  void _initData() {
    widget.completeProductList!.forEach((element) {
      _starQualityList!.add(0);
      _starServiceList!.add(0);
      _starTranferList!.add(0);
      reviewControllerList!.add(TextEditingController(text: ""));
      _selectedSizeList!.add("");
      _imgFileList!.add([]);
      _videoFileList.add(null);
      _showSwitchList!.add(false);
    });
  }

  Future _createReviewProduct() async {
    Future.delayed(Duration.zero, () async {
      final newReview = await ref
          .read(reviewProductProvider.notifier)
          .createReviewProduct(15, {
        // "rating": [
        //   {
        //     "media_ids": ["109630124703424265"],
        //     "product_variant_id": "23",
        //     "status": reviewControllerList[index].text.trim(),
        //     "rating_point": "5"
        //   }
        // ]
      });
    });
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
    _initData();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Đánh giá sản phẩm"),
              GestureDetector(
                  onTap: () {
                    _createReviewProduct();
                  },
                  child: const AppBarTitle(title: "Gửi"))
            ],
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children:
                    List.generate(widget.completeProductList!.length, (index) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            _getSizes(
                              index,
                            ),
                            buildSpacer(height: 10),
                            _showUserName(
                              index,
                            ),
                            buildDivider(color: greyColor, height: 10),
                            _ratingComponent(
                                index, "Dịch vụ của người bán", "service"),
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

  Widget _instructStandardReview() {
    return GeneralComponent(
      [
        buildTextContent(
            "Xem hướng dẫn đánh giá chuẩn để nhận đến 200 xu", false,
            fontSize: 17)
      ],
      suffixWidget: Container(
        width: 20,
        height: 20,
        child: const Icon(
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
                "Mã ABC giả đến 30k đơn 120k - ${widget.completeProductList![index]["product_variants"][0]["title"]}",
                false,
                fontSize: 17,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(
              height: 10,
            ),
            buildTextContent("Phân loại: ${widget.completeProductList![index]["product_variants"][0]["option1"] ?? ""} ${widget.completeProductList![index]["product_variants"][0]["option2"] ?? ""}", false,
                fontSize: 14, colorWord: greyColor),
          ],
          suffixWidget: Container(
            width: 20,
            height: 20,
            child: const Icon(
              FontAwesomeIcons.chevronRight,
              size: 17,
            ),
          ),
          prefixWidget: Container(
            width: 40,
            height: 40,
            child: ImageCacheRender(
                path: widget.completeProductList![index]["product_variants"][0]
                    ["image"]["url"]),
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
            false,
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
                        // width: 80,
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
                                          color: red.withOpacity(0.5),
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
                        return _buildSelectImageVideo(index, "Thêm hình ảnh",
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
                    _videoFileList[mediaIndex] != ""
                ? _buildSelectImageVideo(
                    mediaIndex,
                    "Thêm video",
                  )
                : Container(
                    margin: const EdgeInsets.only(right: 10, top: 10),
                    height: 100,
                    // width: 80,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: VideoPlayerRender(
                                path: _videoFileList[mediaIndex].path),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  _videoFileList[mediaIndex] = null;
                                  setState(() {});
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: red.withOpacity(0.5),
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

// doi voi quan ao
  Widget _getSizes(int sizeindex) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: buildTextContent("Kích thước", true, fontSize: 17),
        ),
        Row(
          children: List.generate(_sizes.length, (index) {
            return Row(
              children: [
                Radio(
                    groupValue: _selectedSizeList![sizeindex],
                    value: _sizes[index],
                    onChanged: (value) {
                      setState(() {
                        _selectedSizeList![sizeindex] = value as String;
                      });
                    }),
                buildSpacer(width: 5),
                buildTextContent(_sizes[index], false),
              ],
            );
          }),
        )
      ],
    );
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
    Color wordColor = blackColor;
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
    return buildTextContent(description, true,
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
        _videoFileList[index] = File(selectedVideo.path);
      });
    }
  }
}
