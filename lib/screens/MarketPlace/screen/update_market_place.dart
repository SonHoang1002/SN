import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/brand_api.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/category_product_apis.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/detail_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/page_list_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/product_categories_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/manage_product_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/detail_product_api.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/page_list_api.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/products_api.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Market/video_render_player.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';

import '../../../../theme/colors.dart';
import '../../../widgets/GeneralWidget/general_component.dart';
import 'create_product_page.dart';

class UpdateMarketPage extends ConsumerStatefulWidget {
  final dynamic id;

  const UpdateMarketPage(this.id, {super.key});
  @override
  ConsumerState<UpdateMarketPage> createState() => _UpdateMarketPageState();
}

String selectPageTitle = "Chọn Page";

String selectionImageWarnings = "Hãy chọn ảnh cho mục này !!";

class _UpdateMarketPageState extends ConsumerState<UpdateMarketPage>
    with TickerProviderStateMixin {
  late double width = 0;
  late double height = 0;
  Map<String, dynamic>? _oldData;
  Map<String, dynamic>? newData;
  dynamic _branchSelectedValue;
  List<dynamic>? imgLink = [];
  final List<dynamic> _videoFiles = [];

  final Map<String, bool> _validatorSelectionList = {
    "category": true,
    "branch": true,
    "image": true,
    "page": true,
    "weight": true,
    "description": true
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bottomFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _descriptionController =
      TextEditingController(text: "");
  final TextEditingController _priceController =
      TextEditingController(text: "");
  final TextEditingController _repositoryController =
      TextEditingController(text: "");
  final TextEditingController _skuController = TextEditingController(text: "");
  final TextEditingController _weightController =
      TextEditingController(text: "");
  final TextEditingController _sizeLengthController =
      TextEditingController(text: "");
  final TextEditingController _sizeHeightController =
      TextEditingController(text: "");
  final TextEditingController _sizeWidthController =
      TextEditingController(text: "");

  bool _isLoading = false;
  // bao gom cac list category theo chieu cha den con
  final List<dynamic> _listCategoryData = [];
  List<dynamic> _listCategoriesSelectedValue = [];

  /// cac form data được lay ra tu phuong thuc goi cac api con
  List<dynamic> _listDetailInforData = [];
  List<dynamic> _listDetailInforSelectedValue = [];
  dynamic _selectedPage;
  List _brandListFromCategory = [];
  List _listPage = [];
  List<String> _previewClassifyValues = ["", ""];
  Map<String, dynamic>? _categoryData;
  bool? _isDetailEmpty = false;
  TabController? _tabController;
  int _currentCategoryTabIndex = 0;
  dynamic _preOderSelectedValue;
  dynamic _statusProductSelectedValue;
  final int _preOrderTimeSelectedValue = 7;
  final TextEditingController _createOptionController =
      TextEditingController(text: "");
  dynamic responseUpdateProductApi;
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();
    _initData();
    newData = {
      "product_images": [],
      "product_video": null,
      "product": {},
      "product_options_attributes": [],
      "product_variants_attributes": []
    };
    Future.delayed(Duration.zero, () async {
      final b = await ref
          .read(detailProductProvider.notifier)
          .getDetailProduct(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  buildMessageDialog(context, "Bạn có chắc chắn muốn thoát ?",
                      oKFunction: () {
                    popToPreviousScreen(context);
                    popToPreviousScreen(context);
                  });
                },
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Theme.of(context).textTheme.displayLarge!.color,
                ),
              ),
              const AppBarTitle(title: "Cập nhật sản phẩm"),
              InkWell(
                onTap: () {
                  pushToNextScreen(context, NotificationMarketPage());
                },
                child: const Icon(
                  FontAwesomeIcons.bell,
                  size: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        body: _isLoading
            ? Center(
                child: buildCircularProgressIndicator(),
              )
            : GestureDetector(
                onTap: (() {
                  FocusManager.instance.primaryFocus!.unfocus();
                }),
                child: Stack(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListView(children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(children: [
                                  buildDivider(
                                    color: greyColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: buildTextContent(
                                        "Thông tin cơ bản", true,
                                        fontSize: 20, isCenterLeft: false),
                                  ),
                                  _buildSelectionWidget(
                                      context, selectPageTitle, selectPageTitle,
                                      onSelected: (newData) {
                                    popToPreviousScreen(context);
                                    _selectedPage = newData;
                                    _validatorSelectionList["page"] = true;
                                  }, renderedDataList: _listPage),
                                  // anh
                                  _buildImageSelections(),
                                  // mô tả ảnh
                                  _builImageDescription(),
                                  // video
                                  _buildVideoSelection(),
                                  // mô tả video
                                  _buildVideoDescription(),
                                  // ten san pham
                                  buildSpacer(height: 5),
                                  _buildInformationInput(
                                    _nameController,
                                    width,
                                    CreateProductMarketConstants
                                        .CREATE_PRODUCT_MARKET_PRODUCT_NAME_PLACEHOLDER,
                                  ),
                                  buildSpacer(height: 5),
                                  // danh muc
                                  _buildSelectionWidget(
                                    context,
                                    CreateProductMarketConstants
                                        .CREATE_PRODUCT_MARKET_CATEGORY_TITLE,
                                    "Chọn hạng mục",
                                    height: height - 100,
                                  ),
                                  buildSpacer(height: 5),
                                  // mo ta san pham
                                  _buildInformationInput(
                                      _descriptionController,
                                      width,
                                      CreateProductMarketConstants
                                          .CREATE_PRODUCT_MARKET_DESCRIPTION_PLACEHOLDER),
                                ]),
                              ),

                              //////////////////////
                              // thong tin chi tiet
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: buildSpacer(
                                  width: width,
                                  color: greyColor[400],
                                  height: 5,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: buildTextContent(
                                    "Thông tin chi tiết", true,
                                    fontSize: 20, isCenterLeft: false),
                              ),
                              // thuong hieu
                              _buildSelectionWidget(
                                  context,
                                  CreateProductMarketConstants
                                      .CREATE_PRODUCT_MARKET_BRAND_TITLE,
                                  "Thương hiệu", onSelected: (newData) {
                                popToPreviousScreen(context);
                                _branchSelectedValue = newData;
                              }, renderedDataList: _brandListFromCategory),
                              Wrap(
                                children: _listDetailInforData.map<Widget>(
                                  (e) {
                                    return _buildSelectionWidget(
                                        context,
                                        e['product_attribute']['name'],
                                        e['product_attribute']['count_values'] <= 1
                                            ? "Chọn một "
                                            : "Chọn nhiều",
                                        isGrantedCreateOptions: true,
                                        useCheckbox: !(e['product_attribute']
                                                ['count_values'] <=
                                            1),
                                        useRatio: e['product_attribute']
                                                ['count_values'] <=
                                            1,
                                        checkedList: _listDetailInforSelectedValue[_listDetailInforData.indexOf(e)]
                                            ['value'], onSelected: (newData) {
                                      if (!_listDetailInforSelectedValue[
                                              _listDetailInforData
                                                  .indexOf(e)]['value']
                                          .contains(newData)) {
                                        if (e['product_attribute']
                                                ['count_values'] <=
                                            1) {
                                          if (_listDetailInforSelectedValue[
                                                      _listDetailInforData
                                                          .indexOf(e)]['value']
                                                  .length ==
                                              0) {
                                            _listDetailInforSelectedValue[
                                                    _listDetailInforData
                                                        .indexOf(e)]['value']
                                                .add(newData);
                                          } else {
                                            _listDetailInforSelectedValue[
                                                _listDetailInforData.indexOf(
                                                    e)]['value'][0] = newData;
                                          }
                                        } else {
                                          _listDetailInforSelectedValue[
                                                  _listDetailInforData
                                                      .indexOf(e)]['value']
                                              .add(newData);
                                        }
                                      } else {
                                        _listDetailInforSelectedValue[
                                                _listDetailInforData
                                                    .indexOf(e)]['value']
                                            .remove(newData);
                                      }
                                    },
                                        renderedDataList: e['product_attribute']
                                            ['product_attribute_values'],
                                        isMultiSelect: e['product_attribute']['count_values'] > 1);
                                  },
                                ).toList(),
                              ),

                              //////////////////////
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: buildSpacer(
                                  width: width,
                                  color: greyColor[400],
                                  height: 5,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: buildTextContent(
                                    "Thông tin bán hàng", true,
                                    fontSize: 20, isCenterLeft: false),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: _buildClassifyWidget(
                                  context,
                                  "Phân loại",
                                ),
                              ),
                              _buildGeneralInputWidget(),

                              //////////////////////
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: buildSpacer(
                                  width: width,
                                  color: greyColor[400],
                                  height: 5,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: buildTextContent(
                                    "Thông tin vận chuyển", true,
                                    fontSize: 20, isCenterLeft: false),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    buildTextContent(
                                        "Cân nặng (sau khi đóng gói, tính theo gram)",
                                        false,
                                        fontSize: 13),
                                    buildSpacer(height: 5),
                                    _buildInformationInput(_weightController,
                                        width, "Nhập cân nặng",
                                        maxLength: 12,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                        keyboardType: TextInputType.number),
                                    buildTextContent(
                                        "Kích thước đóng gói (sau khi đóng gói, tính theo cm)",
                                        false,
                                        fontSize: 13),
                                    buildSpacer(height: 5),
                                    _buildInformationInput(
                                        _sizeHeightController,
                                        width,
                                        "Nhập chiều cao",
                                        maxLength: 8,
                                        keyboardType: TextInputType.number),
                                    _buildInformationInput(
                                        _sizeLengthController,
                                        width,
                                        maxLength: 100,
                                        "Nhập chiều dài",
                                        keyboardType: TextInputType.number),
                                    _buildInformationInput(
                                        _sizeWidthController,
                                        width,
                                        maxLength: 100,
                                        "Nhập chiều rộng",
                                        keyboardType: TextInputType.number),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: buildSpacer(
                                  width: width,
                                  color: greyColor[400],
                                  height: 5,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: buildTextContent("Thông tin khác", true,
                                    fontSize: 20, isCenterLeft: false),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    _buildSelectionWidget(
                                      context,
                                      preOderProduct,
                                      "Chọn hàng đặt trước",
                                      onSelected: (newData) {
                                        popToPreviousScreen(context);
                                        _preOderSelectedValue = newData;
                                      },
                                      renderedDataList: preOderSelections,
                                      height: 200,
                                    ),
                                    _buildSelectionWidget(
                                      context,
                                      statusProduct,
                                      "Chọn tình trạng sản phẩm",
                                      onSelected: (newData) {
                                        popToPreviousScreen(context);
                                        _statusProductSelectedValue = newData;
                                      },
                                      renderedDataList: statusProductSelections,
                                      height: 200,
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          // tao san pham
                          Container(
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: width,
                            child: GestureDetector(
                              onTap: () {},
                              child: buildMarketButton(
                                  width: width,
                                  bgColor: Colors.orange[300],
                                  contents: [
                                    buildTextContent("Cập nhật sản phẩm", false,
                                        fontSize: 13)
                                  ],
                                  function: () {
                                    validateUpdate();
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isLoading
                        ? buildCircularProgressIndicator()
                        : const SizedBox(),
                  ],
                ),
              ));
  }

  void _initProductCategorySelected(dynamic data, List<dynamic> result) {
    if (data != null) {
      if (data['parent_tree'] != null && data['parent_tree'].isNotEmpty) {
        _initProductCategorySelected(data['parent_tree'][0], result);
      }
      result.add(data);
    }
  }

  Future<dynamic> _callChildCategory(dynamic id, params) async {
    final response =
        await CategoryProductApis().getChildCategoryProductApi(id, params);
    return response;
  }

  Future<int> _initData() async {
    if (_oldData == null || _categoryData == null) {
      Future.delayed(Duration.zero, () async {
        await ref
            .read(detailProductProvider.notifier)
            .getDetailProduct(widget.id);
        await ref.read(pageListProvider.notifier).getPageList();
      });
      _oldData = await DetailProductApi().getDetailProductApi(widget.id);
      if (_listPage.isEmpty) {
        _listPage = await PageListApi().getPageListApi();
      }
      _isDetailEmpty = _oldData?["product_options"] == null ||
          _oldData?["product_options"].isEmpty;
      if (_oldData != null) {
        _selectedPage = {
          "id": _oldData!["page"]["id"],
          "title": _oldData!["page"]["title"]
        };
      }
      _nameController.text = _oldData?["title"];
      _descriptionController.text = _oldData?["description"];
      _branchSelectedValue = _oldData?["brand"] ?? "";

      // khởi tạo các thông tin chi tiết
      _brandListFromCategory = await BrandProductApi().getBrandProduct(
          {"product_category_id": _oldData?['product_category']['id']});
      if (_listCategoryData.isEmpty) {
        _listCategoryData.add(ref.watch(parentCategoryController).parentList);
      }
      _initProductCategorySelected(
          _oldData?['product_category'], _listCategoriesSelectedValue);
      _listCategoriesSelectedValue.forEach((ele) async {
        final response = await _callChildCategory(
            ele['id'], ele['has_children'] ? {"subcategories": true} : null);
        _listCategoryData.add(ele['has_children'] ? response : [response]);
      });

      _listDetailInforData =
          _oldData?['product_category']['category_attributes'];
      _oldData?['product_attribute_informations'].forEach((ele) {
        _listDetailInforSelectedValue.add(ele);
      });
      //
      if (_oldData?["product_image_attachments"] != null &&
          _oldData?["product_image_attachments"].isNotEmpty) {
        imgLink = _oldData?["product_image_attachments"].map((e) {
          return e["attachment"]["url"];
        }).toList();
      }
      if (_oldData?["product_video"] != null &&
          _oldData?["product_video"].isNotEmpty) {
        _videoFiles.add(_oldData?["product_video"]["url"]);
      }
      if (_oldData?["weight_package"] != null) {
        _weightController.text = (_oldData?["weight_package"] ?? "").toString();
      }
      if (_oldData?["length_package"] != null) {
        _sizeLengthController.text =
            (_oldData?["length_package"] ?? "").toString();
      }
      if (_oldData?["width_package"] != null) {
        _sizeWidthController.text =
            (_oldData?["width_package"] ?? "").toString();
      }
      if (_oldData?["height_package"] != null) {
        _sizeHeightController.text =
            (_oldData?["height_package"] ?? "").toString();
      }
      // khởi tạ thông tin vận chuyển
      if (_oldData?['pre_order'] == true) {
        _preOderSelectedValue = preOderSelections[1];
      } else {
        _preOderSelectedValue = preOderSelections[0];
      }
      if (_oldData?['condition'] == "new_product") {
        _statusProductSelectedValue = statusProductSelections[0];
      } else {
        _statusProductSelectedValue = statusProductSelections[1];
      }
      // neu co product_variants va product_options
      if (_isDetailEmpty!) {
        _priceController.text =
            _oldData!["product_variants"][0]["price"].toString();
        _repositoryController.text =
            _oldData!["product_variants"][0]["inventory_quantity"].toString();
        _skuController.text =
            _oldData!["product_variants"][0]["sku"].toString();
      } else {
        //////////////////////////////////////////////////////////////
        ///  hkoi tao du lieu bang
        //////////////////////////////////////////////////////////////
        if (_categoryData == null) {
          Map<String, dynamic> primaryData = _oldData!;
          if (_oldData?["product_options"] != null &&
              _oldData?['product_options'].isNotEmpty) {
            for (int i = 0;
                i < primaryData["product_options"].length - 1;
                i++) {
              for (int j = 0;
                  j < primaryData["product_options"].length - i - 1;
                  j++) {
                if (int.parse(primaryData["product_options"][j]["position"]) >
                    int.parse(
                        primaryData["product_options"][j + 1]["position"])) {
                  dynamic temp = primaryData["product_options"][j];
                  primaryData["product_options"][j] =
                      primaryData["product_options"][j + 1];
                  primaryData["product_options"][j + 1] = temp;
                }
              }
            }
          }
          final Map<String, dynamic> informationData = primaryData;
          _categoryData = {
            "loai_1": {
              "name": TextEditingController(
                text: informationData["product_options"][0]["name"],
              ),
              "values": informationData["product_options"][0]["values"]
                  .map((element) {
                return TextEditingController(text: element.toString());
              }).toList(),
              "images": _initCategoryOneImages(informationData),
              "contents": {"price": [], "repository": [], "sku": []}
            },
          };
          // khoi tao content loai 1 voi cac the input rong
          informationData["product_options"][0]["values"]
              .forEach((elementOfOne) {
            _categoryData!["loai_1"]["contents"]["price"]
                .add(TextEditingController(text: ""));
            _categoryData!["loai_1"]["contents"]["repository"]
                .add(TextEditingController(text: ""));
            _categoryData!["loai_1"]["contents"]["sku"]
                .add(TextEditingController(text: ""));
          });
          // khoi tao cac the input neu co loai 2
          if (informationData["product_options"].length > 1) {
            _categoryData!["loai_2"] = {
              "name": TextEditingController(
                text: informationData["product_options"][1]["name"],
              ),
              "values": []
            };
            // List<Map<String, dynamic>> valuesOfLoai2 = [];
            for (int i = 0;
                i < informationData["product_options"][1]["values"].length;
                i++) {
              _categoryData!["loai_2"]["values"].add({
                "category_2_name": TextEditingController(
                  text: informationData["product_options"][1]["values"][i],
                ),
                "price": [],
                "repository": [],
                "sku": []
              });
            }
            informationData["product_options"][0]["values"]
                .forEach((nameOfOne) {
              for (int indexOfTwo = 0;
                  indexOfTwo <
                      informationData["product_options"][1]["values"].length;
                  indexOfTwo++) {
                for (int i = 0;
                    i < informationData["product_variants"].length;
                    i++) {
                  if (informationData["product_variants"][i]["option1"] ==
                      nameOfOne) {
                    if (informationData["product_variants"][i]["option2"] ==
                        informationData["product_options"][1]["values"]
                            [indexOfTwo]) {
                      _categoryData!["loai_2"]["values"][indexOfTwo]["price"]
                          .add(TextEditingController(
                              text: informationData["product_variants"][i]
                                      ["price"]
                                  .toString()));
                      _categoryData!["loai_2"]["values"][indexOfTwo]
                              ["repository"]
                          .add(TextEditingController(
                              text: informationData["product_variants"][i]
                                      ["inventory_quantity"]
                                  .toString()));
                      _categoryData!["loai_2"]["values"][indexOfTwo]["sku"].add(
                          TextEditingController(
                              text: informationData["product_variants"][i]
                                  ["sku"]));
                    }
                  }
                }
              }
            });
          } else {
            // gan gia tri cac the input cua loai neu khong co loai 2
            informationData["product_options"][0]["values"]
                .forEach((elementOfOne) {
              informationData["product_variants"].forEach((valueOfOption1) {
                if (valueOfOption1["option1"] == elementOfOne) {
                  int index = informationData["product_options"][0]["values"]
                      .indexOf(elementOfOne);
                  _categoryData!["loai_1"]["contents"]["price"][index].text =
                      valueOfOption1["price"].toString();

                  _categoryData!["loai_1"]["contents"]["repository"][index]
                      .text = valueOfOption1["inventory_quantity"].toString();
                  _categoryData!["loai_1"]["contents"]["sku"][index].text =
                      valueOfOption1["sku"].toString();
                }
              });
            });
          }
        }
      }
    }
    _previewClassifyValues = ["", ""];

    if (_categoryData != null &&
        _categoryData!["loai_1"]["name"].text.trim() != "") {
      _previewClassifyValues[0] = _categoryData!["loai_1"]["name"].text.trim();
      _categoryData!["loai_1"]["values"].forEach((ele) {
        _previewClassifyValues[0] += " - ${ele.text.trim()}";
      });
      if (_categoryData!["loai_2"] != null) {
        _previewClassifyValues[1] +=
            "${_categoryData!["loai_2"]["name"].text.trim()}";
        _categoryData!["loai_2"]["values"].forEach((ele) {
          _previewClassifyValues[1] +=
              " - ${ele["category_2_name"].text.trim()}";
        });
      }
    }

    _isLoading = false;
    setState(() {});
    return 0;
  }

  List<dynamic> _initCategoryOneImages(Map<String, dynamic> informationData) {
    List<dynamic> imageChildList = [];
    if (informationData["product_options"].isNotEmpty) {
      for (var optionElement in informationData["product_variants"]) {
        if (optionElement['image'] != null) {
          if (!imageChildList.contains(optionElement['image']["url"])) {
            imageChildList.add(optionElement['image']["url"]);
          }
        } else {
          imageChildList.add(
              "https://haycafe.vn/wp-content/uploads/2022/02/Tranh-to-mau-bien-bao-giao-thong-1.jpg");
        }
      }
    }
    return imageChildList;
  }

  Future<void> validateUpdate() async {
    if (_listCategoriesSelectedValue.any((element) => element.isEmpty)) {
      _validatorSelectionList["category"] = false;
    }
    if (_branchSelectedValue == null) {
      _validatorSelectionList["branch"] = false;
    }
    if (imgLink!.isEmpty) {
      _validatorSelectionList["image"] = false;
    }
    if (_weightController.text.trim().isEmpty) {
      _validatorSelectionList["weight"] = false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _validatorSelectionList["description"] = false;
    }
    if (_formKey.currentState!.validate() &&
        _validatorSelectionList["image"] == true &&
        _validatorSelectionList["branch"] == true &&
        _validatorSelectionList["category"] == true &&
        _validatorSelectionList["page"] == true &&
        _validatorSelectionList["weight"] == true &&
        _validatorSelectionList["description"] == true) {
      _questionForUpdateProduct();
    }
    setState(() {});
  }

  Future<void> _setDataForUpdate() async {
    setState(() {
      _isLoading = true;
    });

    // check link anh chinh
    // List<String> product_images =
    //     await Future.wait(imgLink!.map((element) async {
    //   if (element is XFile || element is File) {
    //     String fileName = element.path.split('/').last;
    //     FormData formData = FormData.fromMap({
    //       "file":
    //           await MultipartFile.fromFile(element.path, filename: fileName),
    //     });
    //     final response = await MediaApi().uploadMediaEmso(formData);
    //     return response["id"].toString();
    //   } else {
    //     var idLink = "";
    //     _oldData?["product_image_attachments"].forEach((e) {
    //       if (element == e["attachment"]["url"]) {
    //         idLink = e["attachment"]["id"];
    //       }
    //     });
    //     return idLink;
    //   }
    // }));
    // newData!["product_images"] = product_images;

    // them vao product_video neu co
    // them vao product
    newData!["product"]["page_id"] = _selectedPage["id"];
    newData!["product"]["title"] = _nameController.text.trim();
    newData!["product"]["description"] = _descriptionController.text.trim();
    newData!["product"]["product_category_id"] =
        _listCategoriesSelectedValue.last["id"];
    newData!["product"]["brand_id"] = _branchSelectedValue['id'];

    newData!["product"]["weight_package"] = _weightController.text.trim();
    newData!["product"]["length_package"] = _sizeLengthController.text.trim();
    newData!["product"]["width_package"] = _sizeWidthController.text.trim();
    newData!["product"]["height_package"] = _sizeHeightController.text.trim();
    newData!["product"]["pre_order"] =
        _preOderSelectedValue['text'] == preOderSelections[0]['text']
            ? false
            : true;
    newData!["product"]["condition"] = _statusProductSelectedValue['text'] ==
            statusProductSelections[0]['text']
        ? "new_product"
        : "used_product";
    newData!["product"]["days_to_ship"] =
        _preOderSelectedValue['text'] == preOderSelections[0]['text']
            ? 2
            : _preOrderTimeSelectedValue;
    newData!['product_attribute_informations_attributes'] =
        _listDetailInforSelectedValue;
    // _listDetailInforData
    //     .map(
    //       (e) => {
    //         "product_attribute_id": int.parse(e['product_attribute']['id']),
    //         "name": e['product_attribute']['name'],
    //         "value":
    //             _listDetailInforSelectedValue[_listDetailInforData.indexOf(e)]
    //                 .map((ele) {
    //           return ele['value'];
    //         }).toList(),
    //         "unit": ""
    //       },
    //     )
    //     .toList();

    ///
    // them  product_options
    // loai 1
    if (!_isDetailEmpty!) {
      newData!["product_options_attributes"].add({
        "name": _categoryData?["loai_1"]["name"].text.trim(),
        "position": 1,
        "values": _categoryData?["loai_1"]["values"]
            .map((e) => e.text.trim())
            .toList()
      });
      //loai 2
      if (_categoryData?["loai_2"] != null) {
        Map<String, dynamic> optionAttribute2 = {
          "name": _categoryData?["loai_2"]["name"].text.trim(),
          "position": 2,
          "values": _categoryData?["loai_2"]["values"]
              .map((e) => e["category_2_name"].text.trim())
              .toList()
        };
        newData!["product_options_attributes"].add(optionAttribute2);
      }
      // chuyển đổi ảnh con thành id
      List<dynamic> imgList = _categoryData?["loai_1"]["images"].toList();
      List<String> imageIdList = await Future.wait(imgList.map((element) async {
        if (element is XFile || element is File) {
          String fileName = element.path.split('/').last;
          FormData formData = FormData.fromMap({
            "file":
                await MultipartFile.fromFile(element.path, filename: fileName),
          });
          final response = await MediaApi().uploadMediaEmso(formData);
          return response["id"].toString();
        } else {
          // chuyen doi anh con hoac so sanh de lay id anh con lay tu data cu
          String imageId = "";
          _oldData?["product_variants"].forEach((optionAttributeComponent) {
            if (optionAttributeComponent["image"] != null &&
                element == optionAttributeComponent["image"]["url"]) {
              imageId = optionAttributeComponent["image"]["id"];
            } else {
              imageId = "";
            }
            return;
          });
          return imageId;
        }
      }).toList());

      // them product_variants
      if (_categoryData?["loai_2"] == null) {
        // loai 1
        List<dynamic> productVariantsOne = [];
        for (int i = 0; i < _categoryData!["loai_1"]["values"].length; i++) {
          productVariantsOne.add({
            "title":
                "${_nameController.text.trim().toString()} - ${_categoryData!["loai_1"]["values"][i].text.trim().toString()}",
            "price": _categoryData?["loai_1"]["contents"]["price"][i]
                .text
                .trim()
                .toString(),
            "sku": _categoryData?["loai_1"]["contents"]["sku"][i]
                .text
                .trim()
                .toString(),
            "position": 1,
            "compare_at_price": null,
            "option1":
                _categoryData!["loai_1"]["values"][i].text.trim().toString(),
            "option2": null,
            "image_id": imageIdList[i],
            "weight": 0.25,
            "weight_unit": "Kg",
            "inventory_quantity": int.parse(_categoryData?["loai_1"]["contents"]
                    ["repository"][i]
                .text
                .trim()),
            "old_inventory_quantity": 100,
            "requires_shipping": true
          });
        }
        newData!["product_variants_attributes"] = productVariantsOne;
      } else {
        // them product_variants du lieu loai 2
        List<dynamic> productVariantsTwo = [];
        for (int i = 0; i < _categoryData!["loai_1"]["values"].length; i++) {
          for (int z = 0; z < _categoryData!["loai_2"]["values"].length; z++) {
            productVariantsTwo.add({
              "title":
                  "${_nameController.text.trim().toString()} - ${_categoryData!["loai_1"]["values"][i].text.trim().toString()} - ${_categoryData!["loai_2"]["values"][z]["category_2_name"].text.trim().toString()} ",
              "price": _categoryData?["loai_2"]["values"][z]["price"][i]
                  .text
                  .trim()
                  .toString(),
              "sku": _categoryData?["loai_2"]["values"][z]["sku"][i]
                  .text
                  .trim()
                  .toString(),
              "position": 1,
              "compare_at_price": null,
              "option1":
                  _categoryData!["loai_1"]["values"][i].text.trim().toString(),
              "option2": _categoryData!["loai_2"]["values"][z]
                      ["category_2_name"]
                  .text
                  .trim()
                  .toString(),
              "image_id": imageIdList[i],
              "weight": 0.25,
              "weight_unit": "Kg",
              "inventory_quantity": int.parse(_categoryData?["loai_2"]["values"]
                      [z]["repository"][i]
                  .text
                  .trim()),
              "old_inventory_quantity": 100,
              "requires_shipping": true
            });
          }
        }
        newData!["product_variants_attributes"] = productVariantsTwo;
      }
    } else {
      newData!["product_variants_attributes"].add({
        "title": _nameController.text.trim().toString(),
        "price": _priceController.text.trim(),
        "sku": _skuController.text.trim(),
        "position": 1,
        "compare_at_price": null,
        "option1": null,
        "option2": null,
        "image_id": null,
        "weight": 0.25,
        "weight_unit": "Kg",
        "inventory_quantity": _repositoryController.text.trim(),
        "old_inventory_quantity": 100,
        "requires_shipping": true
      });
    }
    await _chooseApi();
    _isLoading = false;
    setState(() {});
  }

  dynamic showCategoryBottom() {
    return showCustomBottomSheet(context, height - 50,
        title: "Phân loại hàng",
        paddingHorizontal: 0,
        enableDrag: false,
        isDismissible: false, prefixFunction: () {
      if (_bottomFormKey.currentState!.validate()) {
        if (_categoryData!["loai_1"]["images"].every((element) {
          return element != "";
        })) {
          popToPreviousScreen(context);
        }
      }
    }, widget: StatefulBuilder(builder: (context, setStatefull) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Form(
          key: _bottomFormKey,
          child: SizedBox(
            height: height - 145,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // main detail information
                  _isDetailEmpty!
                      ? Column(
                          children: [
                            _buildGeneralInputWidget(),
                            _isDetailEmpty!
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: buildTextContentButton(
                                        "Thêm nhóm phân loại", true,
                                        function: () {
                                      setStatefull(() {
                                        _isDetailEmpty = !_isDetailEmpty!;
                                        _createClassifyCategoryOne();
                                      });
                                      setState(() {});
                                    }, fontSize: 18, isCenterLeft: false),
                                  )
                                : const SizedBox()
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(left: 10),
                            physics: const BouncingScrollPhysics(),
                            child: Column(children: [
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      buildSpacer(height: 10),
                                      _buildInformationInput(
                                          _categoryData!["loai_1"]["name"],
                                          width,
                                          "Nhập tên phân loại 1",
                                          maxLength: 14,
                                          additionalFunction: () {
                                            setStatefull(() {});
                                          },
                                          suffixIconData:
                                              FontAwesomeIcons.close,
                                          suffixFunction: () {
                                            setStatefull(() {
                                              _deleteClassifyCategoryOne();
                                            });
                                          }),
                                      // phan loai 1
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Wrap(
                                          children: List.generate(
                                              _categoryData!["loai_1"]["values"]
                                                  .length,
                                              (indexDescription) => Padding(
                                                    padding: EdgeInsets.only(
                                                        right: indexDescription
                                                                .isOdd
                                                            ? 0
                                                            : 5,
                                                        left: indexDescription
                                                                .isEven
                                                            ? 0
                                                            : 5),
                                                    child: _buildInformationInput(
                                                        _categoryData!["loai_1"]
                                                                ["values"]
                                                            [indexDescription],
                                                        width * 0.48,
                                                        "Thuộc tính 1: ${indexDescription + 1}",
                                                        maxLength: 20,
                                                        additionalFunction: () {
                                                          setStatefull(() {});
                                                        },
                                                        suffixIconData:
                                                            FontAwesomeIcons
                                                                .close,
                                                        suffixFunction: () {
                                                          setStatefull(() {
                                                            _deleteItemCategoryOne(
                                                                indexDescription);
                                                          });
                                                          setState(() {});
                                                        }),
                                                  )),
                                        ),
                                      ),
                                      _categoryData!["loai_1"]["values"]
                                                  .length !=
                                              10
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 5),
                                              child: buildTextContentButton(
                                                  "Thêm mô tả cho phân loại 1: ${_categoryData!["loai_1"]["values"].length}/10",
                                                  false,
                                                  fontSize: 13, function: () {
                                                setStatefull(() {
                                                  _addItemCategoryOne();
                                                });
                                                setState(() {});
                                              }),
                                            )
                                          : const SizedBox(),
                                      buildSpacer(height: 10),
                                      // img child list
                                      SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: List.generate(
                                                  _categoryData!["loai_1"]
                                                          ["values"]
                                                      .length, (index) {
                                            return GestureDetector(
                                              onTap: () {
                                                dialogInformartionImgSource(
                                                    index, function: () {
                                                  setStatefull(() {});
                                                });
                                              },
                                              child: SizedBox(
                                                height: 100,
                                                width: 80,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 80,
                                                      width: 80,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  primaryColor,
                                                              width: 1)),
                                                      child: Column(children: [
                                                        Expanded(
                                                          child: _categoryData![
                                                                              "loai_1"]
                                                                          ["images"]
                                                                      [index] !=
                                                                  ""
                                                              ? _categoryData!["loai_1"]
                                                                              [
                                                                              "images"]
                                                                          [
                                                                          index]
                                                                      is XFile
                                                                  ? Image.file(
                                                                      File(_categoryData!["loai_1"]["images"]
                                                                              [
                                                                              index]
                                                                          .path),
                                                                      fit: BoxFit
                                                                          .fitWidth,
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      _categoryData!["loai_1"]
                                                                              [
                                                                              "images"]
                                                                          [
                                                                          index],
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                    )
                                                              : SvgPicture
                                                                  .asset(
                                                                  "${MarketPlaceConstants.PATH_ICON}add_img_file_icon.svg",
                                                                ),
                                                        ),
                                                        Container(
                                                            color:
                                                                secondaryColor,
                                                            width: 80,
                                                            height: 20,
                                                            child: buildTextContent(
                                                                _categoryData!["loai_1"]
                                                                            [
                                                                            "values"]
                                                                        [index]
                                                                    .text
                                                                    .trim(),
                                                                false,
                                                                isCenterLeft:
                                                                    false,
                                                                fontSize: 13)),
                                                      ]),
                                                    ),
                                                    _categoryData!["loai_1"]
                                                                    ["images"]
                                                                [index] ==
                                                            ""
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0),
                                                            child:
                                                                buildTextContent(
                                                                    "<Trống>",
                                                                    false,
                                                                    colorWord:
                                                                        red,
                                                                    isCenterLeft:
                                                                        false,
                                                                    fontSize:
                                                                        12),
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              ),
                                            );
                                          }))),

                                      _categoryData!["loai_2"] == null ||
                                              _categoryData!["loai_2"] == {} ||
                                              _categoryData!["loai_2"].isEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: buildTextContentButton(
                                                  "Thêm nhóm phân loại", true,
                                                  fontSize: 16,
                                                  iconData:
                                                      FontAwesomeIcons.add,
                                                  isCenterLeft: false,
                                                  function: () {
                                                setStatefull(() {
                                                  setStatefull(() {
                                                    _createClassifyCategoryTwo();
                                                  });
                                                  setState(() {});
                                                });
                                              }),
                                            )
                                          : const SizedBox(),
                                      //loai 2
                                      _categoryData!["loai_2"] != null &&
                                              _categoryData!["loai_2"] != {} &&
                                              _categoryData!["loai_2"]
                                                  .isNotEmpty
                                          ? Column(
                                              children: [
                                                buildSpacer(height: 10),
                                                _buildInformationInput(
                                                    _categoryData!["loai_2"]
                                                        ["name"],
                                                    width,
                                                    "Nhập tên phân loại 2",
                                                    maxLength: 14,
                                                    suffixIconData:
                                                        FontAwesomeIcons.close,
                                                    additionalFunction: () {
                                                  setStatefull(() {});
                                                }, suffixFunction: () {
                                                  setStatefull(() {
                                                    _deleteClassifyCategoryTwo();
                                                  });
                                                  setState(() {});
                                                }),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Wrap(
                                                    children: List.generate(
                                                        _categoryData!["loai_2"]
                                                                ["values"]
                                                            .length,
                                                        (indexDescription) =>
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  right: indexDescription
                                                                          .isOdd
                                                                      ? 0
                                                                      : 5,
                                                                  left: indexDescription
                                                                          .isEven
                                                                      ? 0
                                                                      : 5),
                                                              child:
                                                                  _buildInformationInput(
                                                                      _categoryData!["loai_2"]["values"]
                                                                              [
                                                                              indexDescription]
                                                                          [
                                                                          "category_2_name"],
                                                                      width *
                                                                          0.48,
                                                                      maxLength:
                                                                          20,
                                                                      "Thuộc tính 2: ${indexDescription + 1}",
                                                                      additionalFunction:
                                                                          () {
                                                                        setStatefull(
                                                                            () {});
                                                                      },
                                                                      suffixIconData:
                                                                          FontAwesomeIcons
                                                                              .close,
                                                                      suffixFunction:
                                                                          () {
                                                                        setStatefull(
                                                                            () {
                                                                          _deleteItemCategoryTwo(
                                                                              indexDescription);
                                                                        });
                                                                        setState(
                                                                            () {});
                                                                      }),
                                                            )),
                                                  ),
                                                ),
                                                _categoryData!["loai_2"]
                                                                ["values"]
                                                            .length !=
                                                        10
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                top: 5),
                                                        child: buildTextContentButton(
                                                            "Thêm mô tả cho phân loại 2: ${_categoryData!["loai_2"]["values"].length}/10",
                                                            false,
                                                            fontSize: 13,
                                                            function: () {
                                                          setStatefull(() {
                                                            _addItemCategoryTwo();
                                                          });
                                                          setState(() {});
                                                        }),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            )
                                          : const SizedBox(),
                                      buildSpacer(height: 10),
                                      _buildGeneralInputWidget(
                                          inputHeight: 45,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                          applyTitlte: "Áp dụng hàng loạt"),
                                      buildDivider(color: greyColor),
                                    ],
                                  ),
                                  // table
                                  SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: _categoryData!["loai_2"] == {} ||
                                              _categoryData!["loai_2"] == null
                                          ? _buildOneDataTable()
                                          : _buildTwoDataTable()),
                                  buildSpacer(height: height * 0.3)
                                ],
                              ),
                            ]),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      );
    }));
  }

  Future<void> _initSelections() async {
    if (_listPage.isEmpty) {
      _listPage = ref.watch(pageListProvider).listPage;
    }
    if (_listCategoryData.isEmpty) {
      _listCategoryData.add(ref.watch(parentCategoryController).parentList);
    }
    _previewClassifyValues = ["", ""];
    if (_categoryData != null) {
      if (_categoryData!["loai_1"]["name"].text.trim() != "") {
        _previewClassifyValues[0] =
            _categoryData!["loai_1"]["name"].text.trim();
        _categoryData!["loai_1"]["values"].forEach((ele) {
          _previewClassifyValues[0] += " - ${ele.text.trim()}";
        });
        if (_categoryData!["loai_2"] != null) {
          _previewClassifyValues[1] +=
              "${_categoryData!["loai_2"]["name"].text.trim()}";
          _categoryData!["loai_2"]["values"].forEach((ele) {
            _previewClassifyValues[1] +=
                " - ${ele["category_2_name"].text.trim()}";
          });
        }
      }
    } else {
      _previewClassifyValues = ["", ""];
    }
    if (_listPage.isNotEmpty) {
      _selectedPage ??= _listPage[0];
    }
    _tabController ??= TabController(
        length: _listCategoryData.length,
        vsync: this,
        initialIndex: _currentCategoryTabIndex);
    if (_listCategoriesSelectedValue.isEmpty) {
      _listCategoriesSelectedValue.add({});
    }
  }

  Widget _buildSelectionWidget(
      BuildContext context, String title, String titleForBottomSheet,
      {double height = 400,
      Function? onSelected,
      List? renderedDataList,
      bool isMultiSelect = false,
      List checkedList = const [],
      bool useRatio = false,
      bool useCheckbox = false,

      /// cho phep them option vao tuy theo cac nganh hang duoc lua chon khong
      bool isGrantedCreateOptions = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 14),
              Container(
                child: _buildSelectionContents(title, checkedList: checkedList),
              )
            ],
            suffixWidget: const SizedBox(
              height: 40,
              width: 40,
              child: Icon(
                FontAwesomeIcons.caretDown,
                size: 18,
              ),
            ),
            changeBackground: transparent,
            padding: const EdgeInsets.all(5),
            isHaveBorder: true,
            function: () {
              showCustomBottomSheet(context, height,
                  isShowCloseButton: false,
                  title: titleForBottomSheet, onEnd: () {
                _createOptionController.text = "";
              },
                  widget: SizedBox(
                    height: height - 100,
                    child: FutureBuilder(
                        future: _initSelections(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final data = renderedDataList ?? [];
                            return Column(
                              children: [
                                isGrantedCreateOptions
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildInformationInput(
                                                _createOptionController,
                                                width * 0.8,
                                                "Tạo thêm lựa chọn mới",
                                                height: 40),
                                            buildSpacer(width: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 9),
                                              child: buildMarketButton(
                                                  contents: [
                                                    const Text("hello")
                                                  ],
                                                  width: width * 0.2),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                Flexible(
                                    child: data.isNotEmpty
                                        ? StatefulBuilder(
                                            builder: (context, setStatefull) {
                                            return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: data.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      GeneralComponent(
                                                        [
                                                          buildTextContent(
                                                              data[index][
                                                                      "text"] ??
                                                                  data[index][
                                                                      "title"] ??
                                                                  data[index][
                                                                      "name"] ??
                                                                  data[index][
                                                                      "value"] ??
                                                                  data[index],
                                                              false,
                                                              colorWord: checkedList
                                                                          .isNotEmpty &&
                                                                      checkedList
                                                                          .contains(
                                                                              data[index])
                                                                  ? primaryColor
                                                                  : null),
                                                        ],
                                                        changeBackground:
                                                            transparent,
                                                        function: () async {
                                                          onSelected != null
                                                              ? onSelected(
                                                                  data[index])
                                                              : null;
                                                          setState(() {});
                                                          setStatefull(() {});
                                                        },
                                                        prefixWidget:
                                                            useCheckbox
                                                                ? SizedBox(
                                                                    height: 15,
                                                                    width: 15,
                                                                    child: Checkbox(
                                                                        value: checkedList.isNotEmpty && checkedList.contains(data[index]),
                                                                        onChanged: (value) {
                                                                          onSelected != null
                                                                              ? onSelected(data[index])
                                                                              : null;
                                                                          setState(
                                                                              () {});
                                                                          setStatefull(
                                                                              () {});
                                                                        }),
                                                                  )
                                                                : useRatio
                                                                    ? SizedBox(
                                                                        height:
                                                                            15,
                                                                        width:
                                                                            15,
                                                                        child: Radio(
                                                                            value: checkedList.isNotEmpty && checkedList.contains(data[index]),
                                                                            groupValue: true,
                                                                            onChanged: (value) {
                                                                              onSelected != null ? onSelected(data[index]) : null;
                                                                              setState(() {});
                                                                              setStatefull(() {});
                                                                            }),
                                                                      )
                                                                    : null,
                                                      ),
                                                      buildDivider(
                                                          color: greyColor)
                                                    ],
                                                  );
                                                });
                                          })
                                        : title == selectPageTitle
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  buildTextContent(
                                                      "Bạn chưa sở hữu trang nào, vui lòng tạo page trước",
                                                      false,
                                                      isCenterLeft: false),
                                                  buildSpacer(height: 10),
                                                  buildMarketButton(
                                                      contents: [
                                                        buildTextContent(
                                                            "Tạo page mới",
                                                            false,
                                                            fontSize: 13)
                                                      ],
                                                      width: width * 0.5,
                                                      function: () {
                                                        buildMessageDialog(
                                                            context,
                                                            "Vui lòng sang web tạo page nhé !!",
                                                            oneButton: true);
                                                      })
                                                ],
                                              )
                                            : title ==
                                                    CreateProductMarketConstants
                                                        .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
                                                ? StatefulBuilder(builder:
                                                    (context, setStatefull) {
                                                    return _tabController !=
                                                            null
                                                        ? Column(
                                                            children: [
                                                              TabBar(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          6,
                                                                          0,
                                                                          6,
                                                                          3),
                                                                  labelColor:
                                                                      secondaryColor,
                                                                  unselectedLabelColor: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.color,
                                                                  indicatorColor:
                                                                      secondaryColor,
                                                                  dividerColor:
                                                                      secondaryColor,
                                                                  controller:
                                                                      _tabController,
                                                                  onTap:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      _currentCategoryTabIndex =
                                                                          value;
                                                                    });
                                                                    setStatefull(
                                                                        () {});
                                                                  },
                                                                  tabs: _listCategoriesSelectedValue
                                                                      .map<Widget>((e) => Tab(
                                                                            icon:
                                                                                Text(
                                                                              e?['text'] ?? "---",
                                                                              style: const TextStyle(fontSize: 15),
                                                                            ),
                                                                          ))
                                                                      .toList()),
                                                              Expanded(
                                                                child: TabBarView(
                                                                    controller:
                                                                        _tabController,
                                                                    children: [
                                                                      ListView.builder(
                                                                          itemCount: _listCategoryData[_currentCategoryTabIndex].length,
                                                                          scrollDirection: Axis.vertical,
                                                                          itemBuilder: (context, subIndex) {
                                                                            final datas =
                                                                                _listCategoryData[_currentCategoryTabIndex];
                                                                            return Column(
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () async {
                                                                                    _listCategoriesSelectedValue[_currentCategoryTabIndex] = datas[subIndex];
                                                                                    if (_currentCategoryTabIndex < _listCategoriesSelectedValue.length) {
                                                                                      _listCategoriesSelectedValue = _listCategoriesSelectedValue.sublist(0, _currentCategoryTabIndex + 1);
                                                                                    }
                                                                                    if (_listCategoriesSelectedValue.length <= 2 && datas[subIndex]['has_children'] == true) {
                                                                                      _listCategoriesSelectedValue.add({});
                                                                                      final response = await _callChildCategory(datas[subIndex]['id'], {
                                                                                        "subcategories": true
                                                                                      });
                                                                                      if (response != null && response.isNotEmpty) {
                                                                                        _listCategoryData.add(response);
                                                                                        _currentCategoryTabIndex = 0;
                                                                                      }
                                                                                      _tabController = TabController(
                                                                                        length: _listCategoryData.length,
                                                                                        vsync: this,
                                                                                        // initialIndex: _listCategoryData.length - 1
                                                                                      );
                                                                                    } else {
                                                                                      final response = await _callChildCategory(datas[subIndex]['id'], null);
                                                                                      if (response != null) {
                                                                                        List categoryAttributes = response['category_attributes'];
                                                                                        categoryAttributes.sort((a, b) => (a['position']).compareTo(b['position']));
                                                                                        _listDetailInforData = categoryAttributes;
                                                                                        _listDetailInforSelectedValue = [];
                                                                                        for (var element in _listDetailInforData) {
                                                                                          _listDetailInforSelectedValue.add({
                                                                                            "id": element['id'],
                                                                                            "product_attribute_id": element['product_attribute']['id'],
                                                                                            "name": element['name'],
                                                                                            "value": [],
                                                                                            "unit": ""
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                    _brandListFromCategory = await BrandProductApi().getBrandProduct({
                                                                                      "product_category_id": datas[subIndex]['id']
                                                                                    });
                                                                                    setState(() {});
                                                                                    setStatefull(() {});
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        buildTextContent(datas[subIndex]['text'], false, fontSize: 16, colorWord: _listCategoriesSelectedValue[_currentCategoryTabIndex]['text'] == datas[subIndex]['text'] ? red : null),
                                                                                        const Icon(
                                                                                          FontAwesomeIcons.chevronRight,
                                                                                          size: 20,
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                buildDivider(color: greyColor)
                                                                              ],
                                                                            );
                                                                          }),
                                                                    ]),
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox();
                                                  })
                                                : Center(
                                                    child:
                                                        buildCircularProgressIndicator(),
                                                  ))
                              ],
                            );
                          }
                          return buildCircularProgressIndicator();
                        }),
                  ));
            },
          ),
          _validatorSelectionList["category"] == false &&
                  title ==
                      CreateProductMarketConstants
                          .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
              ? _buildWarningSelection("Vui lòng chọn danh mục.")
              : const SizedBox(),
          _validatorSelectionList["branch"] == false &&
                  title ==
                      CreateProductMarketConstants
                          .CREATE_PRODUCT_MARKET_BRAND_TITLE
              ? _buildWarningSelection("Vui lòng chọn thương hiệu")
              : const SizedBox(),
          _validatorSelectionList["page"] == false && title == selectPageTitle
              ? _buildWarningSelection("Vui lòng chọn trang của bạn.")
              : const SizedBox(),
        ],
      ),
    );
  }

  Future _chooseApi() async {
    dynamic updateBodyData = {};
    updateBodyData = {
      "product": newData!["product"],
      "product_options_attributes": newData!["product_options_attributes"],
      "product_variants_attributes": newData!["product_variants_attributes"],
      "product_attribute_informations_attributes":
          newData!['product_attribute_informations_attributes']
    };
    // goi api
    responseUpdateProductApi =
        await ProductsApi().updateProductApi(_oldData!["id"], updateBodyData);
    await ref.read(productsProvider.notifier).updateProductData([]);
    // ignore: use_build_context_synchronously
    buildMessageDialog(
        context,
        responseUpdateProductApi != null && responseUpdateProductApi.isNotEmpty
            ? "Update thành công =))!"
            : "Update không thành  =((", oKFunction: () {
      pushAndReplaceToNextScreen(context, const ManageProductMarketPage());
    });
  }

  Widget _buildSelectionContents(String title, {List? checkedList = const []}) {
    if (_selectedPage != null && title == selectPageTitle) {
      return buildTextContent(_selectedPage["title"], false, fontSize: 17);
    }
    // danh muc
    else if (title ==
        CreateProductMarketConstants.CREATE_PRODUCT_MARKET_CATEGORY_TITLE) {
      if (_listCategoriesSelectedValue
          .where((element) => element['text'] != null)
          .toList()
          .isNotEmpty) {
        return buildTextContent(
            _listCategoriesSelectedValue
                .map((e) => e['text'])
                .toList()
                .join(" > ")
                .toString(),
            false,
            fontSize: 17);
      }
    } else if (_branchSelectedValue != null &&
        title ==
            CreateProductMarketConstants.CREATE_PRODUCT_MARKET_BRAND_TITLE) {
      return buildTextContent(_branchSelectedValue["name"], false,
          fontSize: 17);
    } else if (_preOderSelectedValue != null && title == preOderProduct) {
      return buildTextContent(_preOderSelectedValue['text'], false,
          fontSize: 17);
    } else if (_statusProductSelectedValue != null && title == statusProduct) {
      return buildTextContent(_statusProductSelectedValue['text'], false,
          fontSize: 17);
    } else if (checkedList!.isNotEmpty) {
      return buildTextContent(
          checkedList.map((e) => e['value']).toList().join(", ").toString(),
          false,
          fontSize: 17);
    }
    return const SizedBox();
  }

  Widget _buildClassifyWidget(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 14),
              _categoryData?["loai_1"]?["name"].text.trim() != ""
                  ? Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          buildTextContent(
                            _previewClassifyValues[0],
                            false,
                            fontSize: 17,
                          ),
                          _previewClassifyValues[1] != ""
                              ? buildTextContent(
                                  _previewClassifyValues[1],
                                  false,
                                  fontSize: 17,
                                )
                              : const SizedBox()
                        ],
                      ),
                    )
                  : const SizedBox()
            ],
            prefixWidget: Container(
              height: 35,
              width: 35,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: greyColor[400]),
              child: const Icon(
                FontAwesomeIcons.list,
                size: 18,
              ),
            ),
            suffixWidget: Container(
              alignment: Alignment.centerRight,
              height: 35,
              width: 35,
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                FontAwesomeIcons.caretDown,
                size: 18,
              ),
            ),
            changeBackground: transparent,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            isHaveBorder: true,
            function: () {
              showCategoryBottom();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInformationInput(
      TextEditingController controller, double width, String hintText,
      {IconData? prefixIconData,
      IconData? suffixIconData,
      TextInputType? keyboardType,
      double? height,
      EdgeInsets? contentPadding,
      Function? additionalFunction,
      Function? suffixFunction,
      int? maxLength}) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      width: width * 0.9,
      height: height,
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        keyboardType: keyboardType ?? TextInputType.text,
        maxLength: maxLength,
        validator: (value) {
          switch (hintText) {
            case CreateProductMarketConstants
                  .CREATE_PRODUCT_MARKET_PRODUCT_NAME_PLACEHOLDER:
              if (value!.isEmpty) {
                return CreateProductMarketConstants
                    .CREATE_PRODUCT_MARKET_PRODUCT_NAME_WARING;
              } else if (controller.text.trim().length < 10) {
                return "Tên sản phẩm phải tối thiểu 10 ký tự";
              }
              break;
            case "Nhập cân nặng":
              if (controller.text.trim().isEmpty) {
                return "Trường cân nặng không được để trống";
              }
              break;
            case "Nhập chiều cao":
            case "Nhập chiều dài":
            case "Nhập chiều rộng":
              return null;
            case CreateProductMarketConstants
                  .CREATE_PRODUCT_MARKET_DESCRIPTION_PLACEHOLDER:
              if (controller.text.trim().isEmpty) {
                return "Vui lòng nhập mô tả sản phẩm";
              } else if (controller.text.trim().length < 50) {
                return "Mô tả phải tối thiểu 50 ký tự";
              }
              return null;
            case "Nhập giá sản phẩm":
            case "Nhập tồn kho":
              if (_categoryData?["loai_1"]["name"].text.trim() != "") {
                if (hintText != "Nhập giá sản phẩm" &&
                    hintText != "Nhập tồn kho" &&
                    hintText != "Nhập mã sản phẩm" &&
                    controller.text.trim().isEmpty) {
                  return "Không hợp lệ";
                }
              } else {
                if (controller.text.trim().isEmpty) {
                  return "Trường này không được để trống";
                }
              }
              return null;
            default:
              break;
          }
          // kiem tra validator cho cac phan khuc san pham

          additionalFunction != null ? additionalFunction() : null;
          return null;
        },
        onChanged: (value) {
          setState(() {});
          additionalFunction != null ? additionalFunction() : null;
        },
        decoration: InputDecoration(
            counterText: "",
            contentPadding:
                contentPadding ?? const EdgeInsets.fromLTRB(10, 20, 10, 10),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                )),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: red),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                )),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                )),
            hintText: hintText,
            labelText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: prefixIconData != null
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      prefixIconData,
                      size: 15,
                    ),
                  )
                : null,
            suffixIcon: suffixIconData != null
                ? InkWell(
                    onTap: () {
                      suffixFunction != null ? suffixFunction() : null;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        suffixIconData,
                        size: 15,
                      ),
                    ),
                  )
                : null),
      ),
    );
  }

  Widget _buildGeneralInputWidget(
      {double? inputHeight, EdgeInsets? contentPadding, String? applyTitlte}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _buildInformationInput(_priceController, width, "Nhập giá sản phẩm",
              height: inputHeight,
              contentPadding: contentPadding,
              maxLength: 12,
              keyboardType: TextInputType.number),
          _buildInformationInput(_repositoryController, width, "Nhập tồn kho",
              height: inputHeight,
              maxLength: 8,
              contentPadding: contentPadding,
              keyboardType: TextInputType.number),
          _buildInformationInput(
            _skuController,
            width,
            maxLength: 100,
            "Nhập mã sản phẩm",
            height: inputHeight,
            contentPadding: contentPadding,
          ),
          buildMarketButton(
              contents: [
                buildTextContent(applyTitlte ?? "Áp dụng cho tất cả", false,
                    fontSize: 13)
              ],
              function: () {
                if (_priceController.text.isNotEmpty &&
                    _repositoryController.text.isNotEmpty &&
                    _skuController.text.isNotEmpty) {
                  _applyPriceForAll();
                  setState(() {});
                }
              })
        ],
      ),
    );
  }

  Widget _buildImageSelections() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: width * 0.9,
          // color: red,
          margin: const EdgeInsets.only(top: 10),
          decoration: imgLink!.isEmpty
              ? BoxDecoration(
                  border: Border.all(color: greyColor, width: 0.4),
                  borderRadius: BorderRadius.circular(7))
              : null,
          child: imgLink!.isEmpty
              ? _iconAndAddImage(
                  CreateProductMarketConstants
                      .CREATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER, function: () {
                  dialogImgSource();
                })
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(imgLink!.length + 1, (index) {
                    if (index < imgLink!.length) {
                      return Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 100,
                        width: 80,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: imgLink![index] is File ||
                                        imgLink![index] is XFile
                                    ? Image.file(
                                        imgLink![index],
                                        fit: BoxFit.fitHeight,
                                      )
                                    : Image.network(
                                        imgLink![index],
                                        fit: BoxFit.fitHeight,
                                      ),
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.only(top: 5),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceAround,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       _deleteOrFixIcon(Icons.close, function: () {
                            //         imgLink!.remove(imgLink![index]);
                            //         setState(() {});
                            //       }),
                            //       _deleteOrFixIcon(Icons.wifi_protected_setup,
                            //           function: () {
                            //         // fix image
                            //       })
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    } else {
                      if (index != 9) {
                        return Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: greyColor, width: 0.4),
                              borderRadius: BorderRadius.circular(7)),
                          child: _iconAndAddImage(
                              CreateProductMarketConstants
                                  .CREATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER,
                              function: () {
                            dialogImgSource();
                          }),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }
                  })),
                ),
        ),
      ],
    );
  }

  Widget _builImageDescription() {
    return _validatorSelectionList["image"] == false && imgLink!.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
            ),
            child: _buildWarningSelection("Chọn ảnh để tiếp tục"),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10),
            child: buildTextContent(
                imgLink!.length == 9
                    ? ""
                    : "Chọn ${imgLink!.length}/9. Hãy nhập ảnh chính của bài niêm yết.",
                false,
                colorWord: greyColor,
                fontSize: 13),
          );
  }

  Widget _iconAndAddImage(String title, {Function? function}) {
    return InkWell(
      onTap: () {
        function != null ? function() : null;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${MarketPlaceConstants.PATH_ICON}add_img_file_icon.svg",
            height: 20,
          ),
          buildSpacer(width: 5),
          buildTextContent(title, false, isCenterLeft: false, fontSize: 15),
        ],
      ),
    );
  }

  Widget _buildVideoSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 150,
          width: width * 0.9,
          margin: const EdgeInsets.only(top: 10),
          decoration: _videoFiles.isEmpty
              ? BoxDecoration(
                  border: Border.all(color: greyColor, width: 0.4),
                  borderRadius: BorderRadius.circular(7))
              : null,
          child: _videoFiles.isEmpty
              ? _iconAndAddImage("Thêm video", function: () {
                  dialogVideoSource();
                })
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 150,
                    width: 170,
                    child: SizedBox(
                      height: 150,
                      width: 170,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: VideoPlayerRender(
                          path: _videoFiles[0],
                        ),
                      ),
                    ),
                  )),
        ),
      ],
    );
  }

  Widget _buildVideoDescription() {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20),
      child: buildTextContent(
          _videoFiles.isEmpty
              ? "Hãy chọn video mô tả sản phẩm của bạn(Lưu ý: dung lượng dưới 30Mb, thời gian giới hạn:10s-60s)"
              : "",
          false,
          colorWord: greyColor,
          fontSize: 13),
    );
  }

  void _createClassifyCategoryOne() {
    _categoryData ??= {
      "loai_1": {
        "name": TextEditingController(
          text: "",
        ),
        "values": [TextEditingController(text: "")],
        "images": <dynamic>[""],
        "contents": {
          "price": [TextEditingController(text: "")],
          "repository": [TextEditingController(text: "")],
          "sku": [TextEditingController(text: "")]
        }
      },
    };

    setState(() {});
  }

  void _addItemCategoryOne() {
    // them cac the input vao loai 1
    _categoryData?["loai_1"]["values"].add(TextEditingController(text: ""));
    _categoryData?["loai_1"]["images"].add("");
    _categoryData?["loai_1"]["contents"]["price"]
        .add(TextEditingController(text: ""));
    _categoryData?["loai_1"]["contents"]["repository"]
        .add(TextEditingController(text: ""));
    _categoryData?["loai_1"]["contents"]["sku"]
        .add(TextEditingController(text: ""));
    // them cac the input vao loai 2 (neu co)

    if (_categoryData?["loai_2"] != null &&
        _categoryData?["loai_2"].isNotEmpty) {
      for (int i = 0; i < _categoryData?["loai_2"]?["values"]?.length; i++) {
        _categoryData?["loai_2"]?["values"]?[i]["price"]
            .add(TextEditingController(text: ""));
        _categoryData?["loai_2"]?["values"]?[i]["repository"]
            .add(TextEditingController(text: ""));
        _categoryData?["loai_2"]?["values"]?[i]["sku"]
            .add(TextEditingController(text: ""));
      }
    }
    setState(() {});
  }

  void _deleteItemCategoryOne(int index) {
    // xoa trong loai_1
    if (_categoryData?["loai_1"]["values"].length != 1) {
      _categoryData?["loai_1"]["values"].removeAt(index);
      _categoryData?["loai_1"]["contents"]["price"].removeAt(index);
      _categoryData?["loai_1"]["contents"]["repository"].removeAt(index);
      _categoryData?["loai_1"]["contents"]["sku"].removeAt(index);

      // xoa trong loai_2 (neu co)
      if (_categoryData?["loai_2"] != null && _categoryData?["loai_2"] != {}) {
        for (int i = 0; i < _categoryData?["loai_2"]["values"].length; i++) {
          _categoryData?["loai_2"]["values"][i]["price"].removeAt(index);
          _categoryData?["loai_2"]["values"][i]["repository"].removeAt(index);
          _categoryData?["loai_2"]["values"][i]["sku"].removeAt(index);
        }
      }
    }

    setState(() {});
  }

  void _deleteClassifyCategoryOne() {
    //chuyen loai 2 thanh loai 1
    if (_categoryData!["loai_2"] != null) {
      Map<String, dynamic> newLoai1 = {
        "loai_1": {
          "name": TextEditingController(text: ""),
          "values": [],
          "images": [],
          "contents": {
            "price": [],
            "repository": [],
            "sku": [],
          },
        },
      };
      newLoai1["loai_1"]["name"].text =
          _categoryData!["loai_2"]["name"].text.trim();
      newLoai1["loai_1"]["values"] =
          _categoryData!["loai_2"]["values"].map((element) {
        return element["category_2_name"];
      }).toList();
      newLoai1["loai_1"]["images"] = _categoryData!["loai_1"]["images"];
      int compareImageValue = _categoryData!["loai_2"]["values"].length -
          _categoryData!["loai_1"]["images"].length;
      if (compareImageValue > 0) {
        for (int i = 0; i < compareImageValue; i++) {
          newLoai1["loai_1"]["images"].add("");
        }
      }
      newLoai1["loai_1"]["contents"]["price"] =
          _categoryData!["loai_2"]['values'].map((element) {
        return TextEditingController(text: "");
      }).toList();
      newLoai1["loai_1"]["contents"]["repository"] =
          _categoryData!["loai_2"]['values'].map((element) {
        return TextEditingController(text: "");
      }).toList();
      newLoai1["loai_1"]["contents"]["sku"] =
          _categoryData!["loai_2"]['values'].map((element) {
        return TextEditingController(text: "");
      }).toList();
      setState(() {
        _categoryData = newLoai1;
      });
    } else {
      setState(() {
        _isDetailEmpty = !_isDetailEmpty!;
      });
    }
  }

  void _createClassifyCategoryTwo() {
    Map<String, dynamic> primaryData = {
      "name": TextEditingController(text: ""),
      "values": [
        {
          "category_2_name": TextEditingController(text: ""),
          "price": [],
          "repository": [],
          "sku": []
        },
      ]
    };
    for (int i = 0; i < _categoryData?["loai_1"]["values"].length; i++) {
      primaryData["values"][0]["price"].add(TextEditingController(text: ""));
      primaryData["values"][0]["repository"]
          .add(TextEditingController(text: ""));
      primaryData["values"][0]["sku"].add(TextEditingController(text: ""));
    }

    _categoryData?["loai_2"] = primaryData;
    setState(() {});
  }

  // them cac the input vao loai 2
  void _addItemCategoryTwo() {
    List<dynamic> valuesCategory2 = _categoryData?["loai_2"]["values"];
    Map<String, dynamic> primaryData = {
      "category_2_name": TextEditingController(text: ""),
      "price": [],
      "repository": [],
      "sku": []
    };

    for (int i = 0; i < _categoryData?["loai_1"]["values"].length; i++) {
      primaryData["price"].add(TextEditingController(text: ""));
      primaryData["repository"].add(TextEditingController(text: ""));
      primaryData["sku"].add(TextEditingController(text: ""));
    }
    valuesCategory2.add(primaryData.cast<String, Object>());
    _categoryData?["loai_2"]["values"] = valuesCategory2;
    setState(() {});
  }

  // xoa phan tu trong phan loai 2
  void _deleteItemCategoryTwo(int index) {
    if (_categoryData?["loai_2"]["values"].length > 1) {
      _categoryData?["loai_2"]["values"].removeAt(index);
      setState(() {});
    }
  }

  void _deleteClassifyCategoryTwo() {
    Map<String, dynamic> newCategory = {};
    newCategory["loai_1"] = _categoryData!["loai_1"];
    setState(() {
      _categoryData = newCategory;
    });
  }

  void _applyPriceForAll() {
    // ap dung cho cac phan loai 1
    for (int i = 0; i < _categoryData?["loai_1"]["values"].length; i++) {
      _categoryData?["loai_1"]["contents"]["price"][i].text =
          _priceController.text.trim();
      _categoryData?["loai_1"]["contents"]["repository"][i].text =
          _repositoryController.text.trim();
      _categoryData?["loai_1"]["contents"]["sku"][i].text =
          _skuController.text.trim();
    }
    // ap dung cho cac phan loai 2
    if (_categoryData?["loai_2"] != null && _categoryData?["loai_2"] != {}) {
      for (int i = 0; i < _categoryData?["loai_1"]["values"].length; i++) {
        for (int z = 0; z < _categoryData?["loai_2"]["values"].length; z++) {
          _categoryData?["loai_2"]["values"][z]["price"][i].text =
              _priceController.text.trim();
          _categoryData?["loai_2"]["values"][z]["repository"][i].text =
              _repositoryController.text.trim();
          _categoryData?["loai_2"]["values"][z]["sku"][i].text =
              _skuController.text.trim();
        }
      }
    }
    setState(() {});
  }

  DataTable _buildOneDataTable() {
    List<DataColumn> dataColumns = [];
    List<DataRow> dataRows = [];
    List<DataCell> dataCells = [];

    // phân loại hàng
    dataColumns.add(DataColumn(
        label: Text(
            _categoryData!["loai_1"]["name"].text.length > 0
                ? _categoryData!["loai_1"]["name"].text.trim()
                : "Phân loại hàng 1",
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));
    dataColumns.add(
      const DataColumn(
          label: Text('Giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Kho hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Mã(sku) phân loại',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );

    for (int i = 0; i < _categoryData!["loai_1"]["values"].length; i++) {
      dataRows.add(DataRow(cells: [
        DataCell(
          buildTextContent(
              _categoryData!["loai_1"]["values"][i].text.trim(), true,
              isCenterLeft: false, fontSize: 17),
        ),
        DataCell(_buildInformationInput(
            _categoryData!["loai_1"]["contents"]["price"][i],
            width * 0.5,
            height: 40,
            maxLength: 12,
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            "Gia",
            keyboardType: TextInputType.number)),
        DataCell(_buildInformationInput(
            _categoryData!["loai_1"]["contents"]["repository"][i],
            width * 0.5,
            height: 40,
            maxLength: 8,
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            "Kho hang",
            keyboardType: TextInputType.number)),
        DataCell(_buildInformationInput(
            _categoryData!["loai_1"]["contents"]["sku"][i],
            width * 0.5,
            height: 40,
            maxLength: 100,
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            "Ma phan loai")),
      ]));
    }
    return DataTable(
      columns: dataColumns,
      rows: dataRows,
      showBottomBorder: true,
      // dataRowHeight: 60,
      dividerThickness: .4,
    );
  }

  DataTable _buildTwoDataTable() {
    List<DataColumn> dataColumns = [];
    List<DataRow> dataRows = [];
    dataColumns.add(DataColumn(
        label: Text(
            _categoryData!["loai_1"]["name"].text.length > 0
                ? _categoryData!["loai_1"]["name"].text.trim()
                : "Phân loại hàng 1",
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));

    dataColumns.add(DataColumn(
        label: Text(
            _categoryData!["loai_2"]?["name"]?.text.length > 0
                ? _categoryData!["loai_2"]["name"].text.trim()
                : "Phân loại hàng 2",
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));

    dataColumns.add(
      const DataColumn(
          label: Text('Giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Kho hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Mã(sku) phân loại',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );

    // thêm dòng
    for (int i = 0; i < _categoryData!["loai_1"]["values"].length; i++) {
      for (int z = 0; z < _categoryData!["loai_2"]?["values"]?.length; z++) {
        dataRows.add(DataRow(cells: [
          z == 0
              ? DataCell(
                  buildTextContent(
                      _categoryData!["loai_1"]["values"][i].text.trim(), true,
                      isCenterLeft: false, fontSize: 17),
                )
              : const DataCell(SizedBox()),
          DataCell(
            buildTextContent(
                _categoryData!["loai_2"]?["values"][z]["category_2_name"]
                    .text
                    .trim(),
                true,
                isCenterLeft: false,
                fontSize: 17),
          ),
          DataCell(_buildInformationInput(
              _categoryData!["loai_2"]?["values"][z]["price"][i],
              width * 0.5,
              "Giá",
              height: 40,
              maxLength: 12,
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              keyboardType: TextInputType.number)),
          DataCell(_buildInformationInput(
              _categoryData!["loai_2"]?["values"][z]["repository"][i],
              width * 0.5,
              "Kho hàng",
              maxLength: 8,
              height: 40,
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              keyboardType: TextInputType.number)),
          DataCell(_buildInformationInput(
            _categoryData!["loai_2"]?["values"][z]["sku"][i],
            width * 0.5,
            "Mã phân loại",
            maxLength: 100,
            height: 40,
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          )),
        ]));
      }
    }

    return DataTable(
      columns: dataColumns,
      rows: dataRows,
      showBottomBorder: true,
      // dataRowHeight: 60,
      dividerThickness: .4,
    );
  }

  Future getImage(ImageSource src) async {
    XFile? getImage;
    getImage = await ImagePicker().pickImage(source: src);
    if (getImage != null) {
      setState(() {
        imgLink!.add(File(getImage!.path));
      });
    }
  }

  Future getInformationImage(ImageSource src, int index,
      {Function? function}) async {
    XFile? getImage;
    getImage = await ImagePicker().pickImage(source: src);
    if (getImage != null) {
      _categoryData!["loai_1"]["images"][index] = getImage.path;
    }
    setState(() {});
    function != null ? function() : null;
  }

  void dialogImgSource() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Pick From Camera"),
                    onTap: () {
                      getImage(ImageSource.camera);
                      popToPreviousScreen(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Pick From Galery"),
                    onTap: () {
                      popToPreviousScreen(context);
                      getImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void dialogVideoSource() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Video từ Camera"),
                    onTap: () {
                      getVideo(ImageSource.camera);
                      popToPreviousScreen(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Video từ thư viện"),
                    onTap: () {
                      popToPreviousScreen(context);
                      getVideo(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getVideo(ImageSource src) async {
    XFile selectedVideo = XFile("");
    selectedVideo = (await ImagePicker().pickVideo(source: src))!;
    setState(() {
      _videoFiles.add(File(selectedVideo.path ?? ""));
    });
  }

  void dialogInformartionImgSource(int index, {Function? function}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Pick From Camera"),
                    onTap: () {
                      getInformationImage(ImageSource.camera, index,
                          function: function);
                      popToPreviousScreen(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Pick From Galery"),
                    onTap: () {
                      popToPreviousScreen(context);
                      getInformationImage(ImageSource.gallery, index,
                          function: function);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _questionForUpdateProduct() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cập nhật"),
          content: const Text("Bạn thực sự muốn cập nhật sản phẩm ?"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Đồng ý"),
              onPressed: () async {
                await _setDataForUpdate();
                if (responseUpdateProductApi != null) {
                  Navigator.of(context)
                    ..pop()
                    ..pop(true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                    "Cập nhật không thành công",
                    style: TextStyle(color: Colors.red),
                  )));
                }
              },
            ),
          ],
        );
      },
    );
  }
}

Widget _buildWarningSelection(String warning) {
  return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: buildTextContent(warning, false,
          fontSize: 12, colorWord: Colors.red[800]));
}
