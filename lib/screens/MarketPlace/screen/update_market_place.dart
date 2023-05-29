import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_place/apis/market_place_apis/category_product_apis.dart';
import 'package:market_place/constant/marketPlace_constants.dart';

import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/detail_product_provider.dart';
import 'package:market_place/providers/market_place_providers/page_list_provider.dart';
import 'package:market_place/providers/market_place_providers/product_categories_provider.dart';
import 'package:market_place/providers/market_place_providers/products_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/manage_product_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/apis/market_place_apis/detail_product_api.dart';
import 'package:market_place/apis/market_place_apis/page_list_api.dart';
import 'package:market_place/apis/market_place_apis/products_api.dart';
import 'package:market_place/apis/media_api.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';
import 'package:market_place/widgets/video_render_player.dart';

import '../../../../theme/colors.dart';

class UpdateMarketPage extends ConsumerStatefulWidget {
  final dynamic id;

  const UpdateMarketPage(this.id, {super.key});
  @override
  ConsumerState<UpdateMarketPage> createState() => _UpdateMarketPageState();
}

String selectPageTitle = "Chọn Page";

String selectionImageWarnings = "Hãy chọn ảnh cho mục này !!";

class _UpdateMarketPageState extends ConsumerState<UpdateMarketPage> {
  late double width = 0;
  late double height = 0;
  Map<String, dynamic>? _oldData;
  Map<String, dynamic>? newData;
  List<dynamic>? _listPage;
  String _categoryTitle = "";
  String _branch = "";

  Map<String, dynamic>? _privateData = {};
  final Map<String, bool> _validatorSelectionList = {
    "category": true,
    "branch": true,
    "private": true,
    "image": true,
    "page": true
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bottomFormKey = GlobalKey<FormState>();

  dynamic _pageData;
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _descriptionController =
      TextEditingController(text: "");
  final TextEditingController _branchController =
      TextEditingController(text: "");
  final TextEditingController _priceController =
      TextEditingController(text: "");
  final TextEditingController _repositoryController =
      TextEditingController(text: "");
  final TextEditingController _skuController = TextEditingController(text: "");

  List<dynamic>? _childCategoriesList;
  // List<dynamic>? productCategoriesData = [];

  List<dynamic>? imgLink;
  List<dynamic>? _videoFiles = [];
  dynamic categoryId;
  Map<String, dynamic>? _categoryData;
  bool? _isDetailEmpty;
  bool _isLoading = true;
  List<String> previewClassifyValues = ["", ""];
  List<dynamic> _parentCategoryList = [];
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();
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
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Future<int> a = _initData();
    if (_parentCategoryList.isEmpty) {
      _parentCategoryList = ref.watch(parentCategoryController).parentList;
    }
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(text: "Cập nhật sản phẩm"),
              Icon(
                FontAwesomeIcons.bell,
                size: 18,
                color: Colors.black,
              )
            ],
          ),
        ),
        body: _isLoading
            ? buildCircularProgressIndicator()
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
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(children: [
                                  // ten san pham
                                  buildDivider(
                                    color: red,
                                  ),
                                  _categoryUnitPageSelection(
                                    context,
                                    selectPageTitle,
                                    selectPageTitle,
                                  ),
                                  _buildInformationInput(
                                    _nameController,
                                    width,
                                    UpdateProductMarketConstants
                                        .UPDATE_PRODUCT_MARKET_PRODUCT_NAME_PLACEHOLDER,
                                  ),
                                  // danh muc
                                  _categoryUnitPageSelection(
                                    context,
                                    UpdateProductMarketConstants
                                        .UPDATE_PRODUCT_MARKET_CATEGORY_TITLE,
                                    "Chọn hạng mục",
                                  ),
                                  // nganh hang (option)
                                  _categoryTitle != ""
                                      ? _categoryUnitPageSelection(
                                          context,
                                          UpdateProductMarketConstants
                                              .UPDATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE,
                                          "Chọn ngành hàng",
                                        )
                                      : const SizedBox(),
                                  // mo ta san pham
                                  _buildInformationInput(
                                      _descriptionController,
                                      width,
                                      UpdateProductMarketConstants
                                          .UPDATE_PRODUCT_MARKET_DESCRIPTION_PLACEHOLDER),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: buildTextContent(
                                        "Không bắt buộc", false,
                                        fontSize: 12, colorWord: greyColor),
                                  ),
                                  // thuong hieu
                                  _buildInformationInput(
                                      _branchController,
                                      width,
                                      UpdateProductMarketConstants
                                          .UPDATE_PRODUCT_MARKET_BRAND_PLACEHOLDER),
                                  // quyen rieng tu
                                  _privateAndClassifyComponent(
                                    context,
                                    CreateProductMarketConstants
                                        .CREATE_PRODUCT_MARKET_PRIVATE_RULE_TITLE,
                                    titleForBottomSheet: "Chọn quyền riêng tư",
                                  )
                                ]),
                              ),
                              // anh
                              _buildImageSelections(),
                              // mô tả ảnh
                              _builImageDescription(),
                              // video
                              _videoFiles!.isNotEmpty
                                  ? _buildVideoSelection()
                                  : const SizedBox(),
                              // mô tả video
                              _videoFiles!.isNotEmpty
                                  ? _buildVideoDescription()
                                  : const SizedBox(),
                              // thong tin chi tiet
                              buildSpacer(height: 10),
                              buildSpacer(
                                  width: width,
                                  color: greyColor[400],
                                  height: 5),
                              buildSpacer(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: _privateAndClassifyComponent(
                                  context,
                                  "Phân loại",
                                ),
                              ),
                              _buildGeneralInputWidget()
                            ]),
                          ),
                          // add to cart and buy now
                          Container(
                            // height: 40,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: width,
                            child: GestureDetector(
                              onTap: () {},
                              child: buildMarketButton(
                                  width: width,
                                  bgColor: Colors.orange[300],
                                  contents: [
                                    buildTextContent("Cập nhật", false,
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

  Future<int> _initData() async {
    if (_oldData == null || _categoryData == null) {
      Future.delayed(Duration.zero, () async {
        final a = await ref
            .read(detailProductProvider.notifier)
            .getDetailProduct(widget.id);
        final b = await ref.read(pageListProvider.notifier).getPageList();
      });
      _oldData = await DetailProductApi().getDetailProductApi(widget.id);
      if (_listPage == null || _listPage!.isEmpty) {
        _listPage = await PageListApi().getPageListApi();
      }
      _isDetailEmpty = _oldData?["product_options"] == null ||
          _oldData?["product_options"].isEmpty;
      _pageData = {
        "id": _oldData!["page"]["id"],
        "title": _oldData!["page"]["title"]
      };
      _nameController.text = _oldData?["title"];
      _branch = _oldData?["product_category"]["text"];
      _categoryTitle = _initBranch(
          _oldData?["product_category"]["parent_category_id"].toString());
      _descriptionController.text = _oldData?["description"];
      _branchController.text = _oldData?["brand"] ?? "";
      categoryId = _oldData!["product_category"]["id"];
      _childCategoriesList = await _getChildCategoryList(
          _oldData?["product_category"]["id"].toString());
      const privateSelections = UpdateProductMarketConstants
          .UPDATE_PRODUCT_MARKET_PRIVATE_RULE_SELECTIONS;
      for (int i = 0; i < privateSelections.length; i++) {
        if (_oldData?["visibility"] == privateSelections[i]["key"]) {
          _privateData?["title"] = privateSelections[i]["title"];
          _privateData?["key"] = privateSelections[i]["key"];
        }
      }
      if (_oldData?["product_image_attachments"] != null &&
          _oldData?["product_image_attachments"].isNotEmpty) {
        imgLink = _oldData?["product_image_attachments"].map((e) {
          return e["attachment"]["url"];
        }).toList();
      }
      if (_oldData?["product_video"] != null &&
          _oldData?["product_video"].isNotEmpty) {
        _videoFiles!.add(_oldData?["product_video"]["url"]);
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
          if (_oldData?["product_options"] != null) {
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
    previewClassifyValues = ["", ""];

    if (_categoryData != null &&
        _categoryData!["loai_1"]["name"].text.trim() != "") {
      previewClassifyValues[0] = _categoryData!["loai_1"]["name"].text.trim();
      _categoryData!["loai_1"]["values"].forEach((ele) {
        previewClassifyValues[0] += " - ${ele.text.trim()}";
      });
      if (_categoryData!["loai_2"] != null) {
        previewClassifyValues[1] +=
            "${_categoryData!["loai_2"]["name"].text.trim()}";
        _categoryData!["loai_2"]["values"].forEach((ele) {
          previewClassifyValues[1] +=
              " - ${ele["category_2_name"].text.trim()}";
        });
      }
    }
    _isLoading = false;
    setState(() {});
    return 0;
  }

  String _initBranch(dynamic parentId) {
    for (var element in _parentCategoryList) {
      if (element["id"] == parentId) {
        return element["text"];
      }
    }
    return "Không có dữ liệu";
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

  Future<dynamic> _getChildCategoryList(dynamic id) async {
    final response = await CategoryProductApis().getChildCategoryProductApi(id);
    return response;
  }

  Future<void> validateUpdate() async {
    if (_categoryTitle == "") {
      _validatorSelectionList["category"] = false;
    }
    if (_branch == "") {
      _validatorSelectionList["branch"] = false;
    }
    if (_privateData!.isEmpty) {
      _validatorSelectionList["private"] = false;
    }
    if (imgLink!.length == 0) {
      _validatorSelectionList["image"] = false;
    }
    if (_formKey.currentState!.validate() &&
        _validatorSelectionList["private"] == true &&
        _validatorSelectionList["branch"] == true &&
        _validatorSelectionList["category"] == true &&
        _validatorSelectionList["image"] == true) {
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
    newData!["product"]["page_id"] = _pageData["id"];
    newData!["product"]["title"] = _nameController.text.trim();
    newData!["product"]["description"] = _descriptionController.text.trim();
    newData!["product"]["product_category_id"] = categoryId;
    newData!["product"]["brand"] = _branchController.text.trim();
    newData!["product"]["visibility"] = _privateData!["key"];

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
    _chooseApi();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      "Cập nhật thành công",
      style: TextStyle(color: Colors.green),
    )));
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
                                      buildDivider(color: red),
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

  Future _chooseApi() async {
    dynamic updateBodyData = {};
    updateBodyData = {
      "product": newData!["product"],
      "product_options_attributes": newData!["product_options_attributes"],
      "product_variants_attributes": newData!["product_variants_attributes"],
    };
    // goi api
    final response =
        await ProductsApi().updateProductApi(_oldData!["id"], updateBodyData);
    final reset =
        await ref.read(productsProvider.notifier).updateProductData([]);
    // ignore: use_build_context_synchronously
    buildMessageDialog(
        context,
        response != null && response.isNotEmpty
            ? "Update thành công =))!"
            : "Update không thành  =((", oKFunction: () {
      pushAndReplaceToNextScreen(context, const ManageProductMarketPage());
    });
  }

  Widget _categoryUnitPageSelection(
    BuildContext context,
    String title,
    String titleForBottomSheet,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 14),
              const SizedBox(height: 5),
              _buildSelectionContents(title)
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
              showCustomBottomSheet(
                context,
                500,
                title: titleForBottomSheet,
                widget: SizedBox(
                    height: 400,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: title == selectPageTitle
                            ? _listPage!.length
                            : title ==
                                    CreateProductMarketConstants
                                        .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
                                ? _parentCategoryList.length
                                : _childCategoriesList!.length,
                        itemBuilder: (context, index) {
                          final data = title == selectPageTitle
                              ? _listPage!
                              : title ==
                                      CreateProductMarketConstants
                                          .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
                                  ? _parentCategoryList
                                  : _childCategoriesList;
                          return Column(
                            children: [
                              GeneralComponent(
                                [
                                  buildTextContent(
                                      data![index]["text"] ??
                                          data[index]["title"],
                                      false),
                                ],
                                changeBackground: transparent,
                                function: () async {
                                  popToPreviousScreen(context);
                                  if (title ==
                                      CreateProductMarketConstants
                                          .CREATE_PRODUCT_MARKET_CATEGORY_TITLE) {
                                    _categoryTitle = data[index]["text"];

                                    _validatorSelectionList["category"] = true;
                                    _childCategoriesList =
                                        await _getChildCategoryList(
                                            _parentCategoryList[index]["id"]);
                                    _branch = "";
                                  }
                                  if (title ==
                                      CreateProductMarketConstants
                                          .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE) {
                                    _branch = data[index]["text"];
                                    categoryId = data[index]["id"];
                                    _validatorSelectionList["branch"] = true;
                                  }
                                  if (title == selectPageTitle) {
                                    _pageData = {
                                      "id": data[index]["id"],
                                      "title": data[index]["title"]
                                    };
                                    _validatorSelectionList["page"] = true;
                                  }
                                  setState(() {});
                                },
                              ),
                              buildDivider(color: red)
                            ],
                          );
                        })),
              );
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
                          .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE
              ? _buildWarningSelection("Vui lòng chọn ngành hàng.")
              : const SizedBox(),
          _validatorSelectionList["page"] == false && title == selectPageTitle
              ? _buildWarningSelection("Vui lòng chọn trang của bạn.")
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildSelectionContents(String title) {
    if (_pageData != null && title == selectPageTitle) {
      return buildTextContent(_pageData["title"], false, fontSize: 17);
    }

    if (_categoryTitle != "" &&
        title ==
            CreateProductMarketConstants.CREATE_PRODUCT_MARKET_CATEGORY_TITLE) {
      return buildTextContent(_categoryTitle, false, fontSize: 17);
    }

    if (_categoryTitle != "" &&
        _branch != "" &&
        title ==
            CreateProductMarketConstants
                .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE) {
      return buildTextContent(_branch, false, fontSize: 17);
    }
    return const SizedBox();
  }

  Widget _privateAndClassifyComponent(
    BuildContext context,
    String title, {
    String? titleForBottomSheet,
  }) {
    List<dynamic> privateDatas = [];
    if (title != "Phân loại") {
      privateDatas = CreateProductMarketConstants
          .CREATE_PRODUCT_MARKET_PRIVATE_RULE_SELECTIONS;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 14),
              const SizedBox(height: 5),
              title != "Phân loại"
                  ? buildTextContent(_privateData!["title"], false,
                      fontSize: 17)
                  : _categoryData?["loai_1"] != null &&
                          _categoryData?["loai_1"]["name"].text.trim() != ""
                      ? Column(
                          children: [
                            buildTextContent(previewClassifyValues[0], false,
                                fontSize: 17),
                            previewClassifyValues[1] != ""
                                ? buildTextContent(
                                    previewClassifyValues[1], false,
                                    fontSize: 17)
                                : const SizedBox()
                          ],
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
              child: Icon(
                title != "Phân loại"
                    ? _privateData!["key"] == privateDatas[0]["key"]
                        ? FontAwesomeIcons.earthAfrica
                        : _privateData!["key"] == privateDatas[1]["key"]
                            ? FontAwesomeIcons.user
                            : FontAwesomeIcons.lock
                    : FontAwesomeIcons.list,
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
              title != "Phân loại"
                  ? showCustomBottomSheet(context, 250,
                      title: titleForBottomSheet,
                      bgColor: Colors.grey[300],
                      widget: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: privateDatas.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GeneralComponent(
                                  [
                                    buildTextContent(
                                        privateDatas[index]["title"], true),
                                    buildTextContent(
                                        privateDatas[index]["subTitle"], false),
                                  ],
                                  prefixWidget: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Icon(privateDatas[index]["icon"]),
                                  ),
                                  changeBackground: transparent,
                                  padding: const EdgeInsets.all(5),
                                  function: () {
                                    popToPreviousScreen(context);
                                    _privateData = privateDatas[index];
                                    _validatorSelectionList["private"] = true;
                                    setState(() {});
                                  },
                                ),
                                buildDivider(color: red)
                              ],
                            );
                          }))
                  : showCategoryBottom();
            },
          ),
          _validatorSelectionList["private"] == false &&
                  title ==
                      CreateProductMarketConstants
                          .CREATE_PRODUCT_MARKET_PRIVATE_RULE_TITLE
              ? _buildWarningSelection("Vui lòng chọn quyền riêng tư.")
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildIconAndAddImageText() {
    return InkWell(
      onTap: () {
        dialogImgSource();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${MarketPlaceConstants.PATH_ICON}add_img_file_icon.svg",
            height: 20,
          ),
          buildSpacer(width: 5),
          buildTextContent(
              UpdateProductMarketConstants
                  .UPDATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER,
              false,
              isCenterLeft: false,
              fontSize: 15),
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
        maxLines: null,
        maxLength: maxLength,
        keyboardType: keyboardType != null ? keyboardType : TextInputType.text,
        validator: (value) {
          switch (hintText) {
            case CreateProductMarketConstants
                .CREATE_PRODUCT_MARKET_PRODUCT_NAME_PLACEHOLDER:
              if (value!.isEmpty) {
                return CreateProductMarketConstants
                    .CREATE_PRODUCT_MARKET_PRODUCT_NAME_WARING;
              }
              break;
            case CreateProductMarketConstants
                .CREATE_PRODUCT_MARKET_BRAND_PLACEHOLDER:
              if (value!.isEmpty) {
                return CreateProductMarketConstants
                    .CREATE_PRODUCT_MARKET_BRAND_WARING;
              }
              break;
            case CreateProductMarketConstants
                .CREATE_PRODUCT_MARKET_DESCRIPTION_PLACEHOLDER:
              return null;

            default:
              break;
          }

          if (_categoryData != null &&
              _categoryData!["loai_1"]["name"].text.trim() != "") {
            if (hintText != "Nhập giá sản phẩm" &&
                hintText != "Nhập tên kho hàng" &&
                hintText != "Nhập mã sản phẩm" &&
                controller.text.trim().isEmpty) {
              return "Không hợp lệ";
            }
          } else {
            if (controller.text.trim().isEmpty) {
              return "Không hợp lệ";
            }
          }
          additionalFunction != null ? additionalFunction() : null;
        },
        onChanged: (value) {
          setState(() {});
          additionalFunction != null ? additionalFunction() : null;
        },
        decoration: InputDecoration(
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
          decoration: _videoFiles!.isEmpty
              ? BoxDecoration(
                  border: Border.all(color: greyColor, width: 0.4),
                  borderRadius: BorderRadius.circular(7))
              : null,
          child: _videoFiles!.isEmpty
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
                          path: _videoFiles![0],
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
          _videoFiles!.isEmpty
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
    XFile getImage = XFile("");
    getImage = (await ImagePicker().pickImage(source: src))!;
    setState(() {
      imgLink!.add(File(getImage.path != null ? getImage.path : ""));
    });
  }

  Future getInformationImage(ImageSource src, int index,
      {Function? function}) async {
    dynamic getImage;
    getImage = (await ImagePicker().pickImage(source: src))!;
    _categoryData!["loai_1"]["images"][index] =
        getImage.path != "" ? getImage : "";
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
      _videoFiles!
          .add(File(selectedVideo.path != null ? selectedVideo.path : ""));
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
          title: const Text("Tạo mới"),
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
              onPressed: () {
                Navigator.of(context).pop();
                _setDataForUpdate();
              },
            ),
          ],
        );
      },
    );
  }
}

Widget _deleteOrFixIcon(IconData iconData, {Function? function}) {
  return InkWell(
    onTap: () {
      function != null ? function() : null;
    },
    child: Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          color: red.withOpacity(0.5),
          border: Border.all(color: greyColor, width: 0.4),
          borderRadius: BorderRadius.circular(10)),
      child: Icon(
        iconData,
        size: 18,
      ),
    ),
  );
}

Widget _buildWarningSelection(String warning) {
  return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: buildTextContent(warning, false,
          fontSize: 12, colorWord: Colors.red[800]));
}
