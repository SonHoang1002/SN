import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/create_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/product_categories_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/manage_order_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../../widget/back_icon_appbar.dart';

class CreateProductMarketPage extends ConsumerStatefulWidget {
  const CreateProductMarketPage({super.key});

  @override
  ConsumerState<CreateProductMarketPage> createState() =>
      _CreateProductMarketPageState();
}

String selectionImageWarning = "Hãy chọn ảnh cho mục này !!";

class _CreateProductMarketPageState
    extends ConsumerState<CreateProductMarketPage> {
  late double width = 0;
  late double height = 0;
  String _category = "";
  String _branch = "";
  String _private = "";
  String _privateKey = "";
  final List<File> _imgFiles = [];
  final List<File> _videoFiles = [];
  List<String> _warningForChildImage = [];

  final Map<String, bool> _validatorSelectionList = {
    "category": true,
    "branch": true,
    "private": true,
    "image": true
  };
  bool _isDetailProduct = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  late Map<String, dynamic> newData;
  bool _isLoading = false;
  List<dynamic>? _childCategoriesList;
  List<dynamic> productCategoriesData = [];

  dynamic _productParentCategoryId;
  dynamic _productChildCategoryId;
  dynamic _pageId = "108277159419223832";
  final Map<String, dynamic> _categoryData = {
    "loai_1": {
      "name": TextEditingController(text: "Màu sắc"),
      "values": [
        TextEditingController(text: "xanh"),
      ],
      "images": [""],
      "contents": {
        "price": [
          TextEditingController(text: ""),
        ],
        "repository": [
          TextEditingController(text: ""),
        ],
        "sku": [
          TextEditingController(text: ""),
        ],
      },
    },
  };

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
    setState(() {});

    Future.delayed(Duration.zero, () {
      final data = ref
          .read(newProductDataProvider.notifier)
          .updateNewProductData(newData);
      final categories = ref
          .read(productCategoriesProvider.notifier)
          .getListProductCategories();
    });
    _warningForChildImage.add("Hãy chọn ảnh cho mục này !!");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    productCategoriesData = ref.watch(productCategoriesProvider).list;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(title: "Tạo sản phẩm"),
              Icon(
                FontAwesomeIcons.bell,
                size: 18,
                color: Colors.black,
              )
            ],
          ),
        ),
        body: GestureDetector(
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(children: [
                            // ten san pham
                            buildDivider(
                              color: red,
                            ),
                            _buildInput(
                              _nameController,
                              width,
                              CreateProductMarketConstants
                                  .CREATE_PRODUCT_MARKET_PRODUCT_NAME_PLACEHOLDER,
                            ),
                            // danh muc
                            _buildSelectionsCategoryAndUnitComponents(
                              context,
                              CreateProductMarketConstants
                                  .CREATE_PRODUCT_MARKET_CATEGORY_TITLE,
                              "Chọn hạng mục",
                            ),
                            // nganh hang (option)
                            _category != ""
                                ? _buildSelectionsCategoryAndUnitComponents(
                                    context,
                                    CreateProductMarketConstants
                                        .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE,
                                    "Chọn ngành hàng",
                                  )
                                : const SizedBox(),
                            // mo ta san pham
                            _buildInput(
                                _descriptionController,
                                width,
                                CreateProductMarketConstants
                                    .CREATE_PRODUCT_MARKET_DESCRIPTION_PLACEHOLDER),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: buildTextContent("Không bắt buộc", false,
                                  fontSize: 12, colorWord: greyColor),
                            ),
                            // nhan hieu
                            _buildInput(
                                _branchController,
                                width,
                                CreateProductMarketConstants
                                    .CREATE_PRODUCT_MARKET_BRAND_PLACEHOLDER),
                            // quyen rieng tu
                            _buildSelectionsPrivateRuleComponent(
                              context,
                              CreateProductMarketConstants
                                  .CREATE_PRODUCT_MARKET_PRIVATE_RULE_TITLE,
                              "Chọn quyền riêng tư",
                            )
                          ]),
                        ),
                        // anh
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: width * 0.9,
                              // color: red,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: _imgFiles.isEmpty
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: greyColor, width: 0.4),
                                      borderRadius: BorderRadius.circular(7))
                                  : null,
                              child: _imgFiles.isEmpty
                                  ? _buildIconAndAddImageText(
                                      CreateProductMarketConstants
                                          .CREATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER,
                                      function: () {
                                      dialogImgSource();
                                    })
                                  : SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: List.generate(
                                              _imgFiles.length + 1, (index) {
                                        if (index < _imgFiles.length) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            height: 100,
                                            width: 80,
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: 100,
                                                  width: 80,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    child: Image.file(
                                                      _imgFiles[index],
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _buildDeleteOrFixIconForImageWidget(
                                                          Icons.close,
                                                          function: () {
                                                        _imgFiles.remove(
                                                            _imgFiles[index]);
                                                        setState(() {});
                                                      }),
                                                      _buildDeleteOrFixIconForImageWidget(
                                                          Icons
                                                              .wifi_protected_setup,
                                                          function: () {
                                                        // fix image
                                                      })
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          if (index != 9) {
                                            return Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: greyColor,
                                                      width: 0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: _buildIconAndAddImageText(
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
                        ),
                        // mô tả ảnh
                        _validatorSelectionList["image"] == false &&
                                _imgFiles.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                ),
                                child: _buildWarningForSelections(
                                    "Chọn ảnh để tiếp tục"),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 10),
                                child: buildTextContent(
                                    _imgFiles.length == 9
                                        ? ""
                                        : "Chọn ${_imgFiles.length}/9. Hãy nhập ảnh chính của bài niêm yết.",
                                    false,
                                    colorWord: greyColor,
                                    fontSize: 13),
                              ),
                        // video
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: width * 0.9,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: _videoFiles.isEmpty
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: greyColor, width: 0.4),
                                      borderRadius: BorderRadius.circular(7))
                                  : null,
                              child: _videoFiles.isEmpty
                                  ? _buildIconAndAddImageText("Thêm video",
                                      function: () {
                                      dialogVideoSource();
                                    })
                                  : SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: _videoFiles.isEmpty
                                          ? Container(
                                              height: 150,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: greyColor,
                                                      width: 0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: _buildIconAndAddImageText(
                                                  "Thêm video", function: () {
                                                dialogVideoSource();
                                              }),
                                            )
                                          : Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              height: 150,
                                              width: 170,
                                              child: Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 150,
                                                    width: 170,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      child: VideoPlayerRender(
                                                        path:
                                                            _videoFiles[0].path,
                                                        // fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5,
                                                                  right: 10),
                                                          child:
                                                              _buildDeleteOrFixIconForImageWidget(
                                                                  Icons.close,
                                                                  function: () {
                                                            _videoFiles.remove(
                                                                _videoFiles[0]);
                                                            setState(() {});
                                                          }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                            ),
                          ],
                        ),
                        // mô tả video
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10, right: 20),
                          child: buildTextContent(
                              _videoFiles.isEmpty
                                  ? "Hãy chọn video mô tả sản phẩm của bạn(Lưu ý: dung lượng dưới 30Mb, thời gian giới hạn:10s-60s)"
                                  : "",
                              false,
                              colorWord: greyColor,
                              fontSize: 13),
                        ),

                        // thong tin chi tiet
                        buildSpacer(height: 10),
                        buildSpacer(
                            width: width, color: greyColor[400], height: 5),
                        buildSpacer(height: 10),
                        buildTextContent("Thông tin bán hàng", true,
                            isCenterLeft: false),
                        buildSpacer(height: 10),
                        // main detail information
                        _buildContentForClassifyCategoryContents()
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
                        child: buildButtonForMarketWidget(
                            width: width,
                            bgColor: Colors.orange[300],
                            title: "Tạo sản phẩm",
                            function: () {
                              validateForCreateProduct();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ));
  }

  Future<void> validateForCreateProduct() async {
    _validatorSelectionList["category"] = true;
    _validatorSelectionList["branch"] = true;
    _validatorSelectionList["private"] = true;
    _validatorSelectionList["image"] = true;
    if (_category == "") {
      _validatorSelectionList["category"] = false;
    }
    if (_branch == "") {
      _validatorSelectionList["branch"] = false;
    }
    if (_private == "") {
      _validatorSelectionList["private"] = false;
    }
    if (_imgFiles.isEmpty) {
      _validatorSelectionList["image"] = false;
    }
    // for(int i)hgj
    print("create $_warningForChildImage");
    if (_formKey.currentState!.validate() &&
        _validatorSelectionList["private"] == true &&
        _validatorSelectionList["branch"] == true &&
        _validatorSelectionList["category"] == true &&
        _validatorSelectionList["image"] == true &&
        _warningForChildImage.every((element) => element == "")) {

      _questionForCreateProduct();
    }
  }

  Future _setDataForCreate() async {
    setState(() {
      _isLoading = true;
    });
    List<String> productImages =
        await Future.wait(_imgFiles.map((element) async {
      String fileName = element.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(element.path, filename: fileName),
      });
      final response = await MediaApi().uploadMediaEmso(formData);
      return response["id"].toString();
    }));
    newData["product_images"] = productImages;
    // them vao product_video
    if (_videoFiles.isNotEmpty) {
      List<String> productVideos =
          await Future.wait(_videoFiles.map((element) async {
        String fileName = element.path.split('/').last;
        FormData formData = FormData.fromMap({
          "file":
              await MultipartFile.fromFile(element.path, filename: fileName),
        });
        final response = await MediaApi().uploadMediaEmso(formData);
        return response["id"].toString();
      }));
      newData["product_video"] = productVideos[0];
    }
    // them vao product
    newData["product"]["title"] = _nameController.text.trim();
    newData["product"]["description"] = _descriptionController.text.trim();
    newData["product"]["product_category_id"] =
        _productChildCategoryId ?? _productParentCategoryId;
    newData["product"]["brand"] = _branch.trim();
    newData["product"]["visibility"] = _privateKey.trim();
    newData["product"]["page_id"] = _pageId;
    // them vao product_options_attributes
    if (_isDetailProduct) {
      // them loai_1
      Map<String, dynamic> loai_1 = {
        "name": _categoryData["loai_1"]["name"].text.trim(),
        "position": 1,
        "values":
            _categoryData["loai_1"]["values"].map((e) => e.text.trim()).toList()
      };
      newData["product_options_attributes"].add(loai_1);

      // them loai_2 (neu co)
      if (_categoryData["loai_2"] != null) {
        Map<String, dynamic> loai_2 = {
          "name": _categoryData["loai_2"]["name"].text.trim(),
          "position": 2,
          "values": _categoryData["loai_2"]["values"]
              .map((e) => e["category_2_name"].text.trim())
              .toList()
        };
        newData["product_options_attributes"].add(loai_2);
      }
    } else {
      newData["product_options_attributes"] = null;
    }
    // them vao product_variants_attributes
    if (_isDetailProduct) {
      List<String> imgList = _categoryData["loai_1"]["images"].toList();
      List<String> imageIdList = await Future.wait(imgList.map((element) async {
        String fileName = element.split('/').last;
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(element, filename: fileName),
        });
        final response = await MediaApi().uploadMediaEmso(formData);
        return response["id"].toString();
      }).toList());
      if (_categoryData["loai_2"] == null) {
        for (int i = 0;
            i < newData["product_options_attributes"][0]["values"].length;
            i++) {
          newData["product_variants_attributes"].add({
            "title":
                "${_nameController.text.trim()} - ${newData["product_options_attributes"][0]["values"][i]}",
            "price": _categoryData["loai_1"]["contents"]["price"][i]
                .text
                .trim()
                .toString(),
            "sku": _categoryData["loai_1"]["contents"]["sku"][i]
                .text
                .trim()
                .toString(),
            "position": 1,
            "compare_at_price": null,
            "option1": newData["product_options_attributes"][0]["values"][i],
            "option2": null,
            "image_id": imageIdList[i],
            "weight": 0.25,
            "weight_unit": "Kg",
            "inventory_quantity": _categoryData["loai_1"]["contents"]
                    ["repository"][i]
                .text
                .trim(),
            "old_inventory_quantity": _categoryData["loai_1"]["contents"]
                    ["repository"][i]
                .text
                .trim(),
            "requires_shipping": true
          });
        }
      } else {
        for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
          for (int z = 0; z < _categoryData["loai_2"]["values"].length; z++) {
            newData["product_variants_attributes"].add({
              "title":
                  "${_nameController.text.trim()} -${_categoryData["loai_1"]["values"][i].text.trim()} - ${_categoryData["loai_2"]["values"][z]["category_2_name"].text.trim()}",
              "price": _categoryData["loai_2"]["values"][z]["price"][i]
                  .text
                  .trim()
                  .toString(),
              "sku": _categoryData["loai_2"]["values"][z]["sku"][i]
                  .text
                  .trim()
                  .toString(),
              "position": 2,
              "compare_at_price": null,
              "option1": _categoryData["loai_1"]["values"][i].text.trim(),
              "option2": _categoryData["loai_2"]["values"][z]["category_2_name"]
                  .text
                  .trim(),
              "image_id": imageIdList[i],
              "weight": 0.25,
              "weight_unit": "Kg",
              "inventory_quantity": _categoryData["loai_2"]["values"][z]
                      ["repository"][i]
                  .text
                  .trim(),
              "old_inventory_quantity": _categoryData["loai_2"]["values"][z]
                      ["repository"][i]
                  .text
                  .trim(),
              "requires_shipping": true
            });
          }
        }
      }
    } else {
      newData["product_variants_attributes"].add({
        "title": _nameController.text.trim(),
        "price": _priceController.text.trim(),
        "sku": _skuController.text.trim().toString(),
        "position": 1,
        "compare_at_price": null,
        "option1": null,
        "option2": null,
        "image_id": null,
        "weight": 0.25,
        "weight_unit": "Kg",
        "inventory_quantity": int.parse(_repositoryController.text.trim()),
        "old_inventory_quantity": int.parse(_repositoryController.text.trim()),
        "requires_shipping": true
      });
    }

    print("create new product: ${json.encode(newData)}");
    final response = Future.wait([postCreateProductApi(newData)]);
    print("create response: $response");
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      "Lưu thành công",
      style: TextStyle(color: Colors.green),
    )));

    ref.read(suggestProductsProvider.notifier).getSuggestProducts();
    pushToNextScreen(context, ManageOrderMarketPage());
    setState(() {
      _isLoading = false;
    });
  }

  Future postCreateProductApi(dynamic data) async {
    ref.read(newProductDataProvider.notifier).postCreateProduct(data);
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
                    title: const Text("Ảnh từ Camera"),
                    onTap: () {
                      getImage(ImageSource.camera);
                      popToPreviousScreen(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Ảnh từ thư viện"),
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

  void _addClassifyCategoryOne() {
    // them cac the input vao loai 1
    _categoryData["loai_1"]["values"].add(TextEditingController(text: ""));
    _categoryData["loai_1"]["images"].add("");
    _categoryData["loai_1"]["contents"]["price"]
        .add(TextEditingController(text: ""));
    _categoryData["loai_1"]["contents"]["repository"]
        .add(TextEditingController(text: ""));
    _categoryData["loai_1"]["contents"]["sku"]
        .add(TextEditingController(text: ""));
    // them cac the input vao loai 2 (neu co)

    if (_categoryData["loai_2"] != {} && _categoryData["loai_2"] != null) {
      for (int i = 0; i < _categoryData["loai_2"]?["values"]?.length; i++) {
        _categoryData["loai_2"]?["values"]?[i]["price"]
            .add(TextEditingController(text: ""));
        _categoryData["loai_2"]?["values"]?[i]["repository"]
            .add(TextEditingController(text: ""));
        _categoryData["loai_2"]?["values"]?[i]["sku"]
            .add(TextEditingController(text: ""));
      }
    }
    setState(() {});
  }

  void _deleteClassifyCategoryOne(int index) {
    // xoa trong loai_1
    if (_categoryData["loai_1"]["values"].length != 1) {
      _categoryData["loai_1"]["values"].removeAt(index);
      _categoryData["loai_1"]["contents"]["price"].removeAt(index);
      _categoryData["loai_1"]["contents"]["repository"].removeAt(index);
      _categoryData["loai_1"]["contents"]["sku"].removeAt(index);
      // xoa trong loai_2 (neu co)
      if (_categoryData["loai_2"] != null && _categoryData["loai_2"] != {}) {
        for (int i = 0; i < _categoryData["loai_2"]["values"].length; i++) {
          _categoryData["loai_2"]["values"][i]["price"].removeAt(index);
          _categoryData["loai_2"]["values"][i]["repository"].removeAt(index);
          _categoryData["loai_2"]["values"][i]["sku"].removeAt(index);
        }
      }
    }
    _warningForChildImage.removeAt(index);
    setState(() {});
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
    for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
      primaryData["values"][0]["price"].add(TextEditingController(text: ""));
      primaryData["values"][0]["repository"]
          .add(TextEditingController(text: ""));
      primaryData["values"][0]["sku"].add(TextEditingController(text: ""));
    }

    _categoryData["loai_2"] = primaryData;
    setState(() {});
  }

  void _addClassifyCategoryTwo() {
    // them cac the input vao loai 2
    List<dynamic> valuesCategory2 = _categoryData["loai_2"]["values"];
    Map<String, dynamic> primaryData = {
      "category_2_name": TextEditingController(text: ""),
      "price": [],
      "repository": [],
      "sku": []
    };

    for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
      primaryData["price"].add(TextEditingController(text: ""));
      primaryData["repository"].add(TextEditingController(text: ""));
      primaryData["sku"].add(TextEditingController(text: ""));
    }
    valuesCategory2.add(primaryData.cast<String, Object>());
    _categoryData["loai_2"]["values"] = valuesCategory2;
    setState(() {});
  }

  void _deleteClassifyCategoryTwo(int index) {
    // xoa phan tu trong phan loai 2
    if (_categoryData["loai_2"]["values"].length > 1) {
      _categoryData["loai_2"]["values"].removeAt(index);
      setState(() {});
    }
  }

  void _applyPriceRepositorySkuForAll() {
    // ap dung cho cac phan loai 1
    for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
      _categoryData["loai_1"]["contents"]["price"][i].text =
          _priceController.text.trim();
      _categoryData["loai_1"]["contents"]["repository"][i].text =
          _repositoryController.text.trim();
      _categoryData["loai_1"]["contents"]["sku"][i].text =
          _skuController.text.trim();
    }
    // ap dung cho cac phan loai 2
    if (_categoryData["loai_2"] != null && _categoryData["loai_2"] != {}) {
      for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
        for (int z = 0; z < _categoryData["loai_2"]["values"].length; z++) {
          _categoryData["loai_2"]["values"][z]["price"][i].text =
              _priceController.text.trim();
          _categoryData["loai_2"]["values"][z]["repository"][i].text =
              _repositoryController.text.trim();
          _categoryData["loai_2"]["values"][z]["sku"][i].text =
              _skuController.text.trim();
        }
      }
    }
    setState(() {});
  }

  void dialogInformartionImgSource(int index) {
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
                      getInformationImage(ImageSource.camera, index);
                      popToPreviousScreen(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Pick From Galery"),
                    onTap: () {
                      popToPreviousScreen(context);
                      getInformationImage(ImageSource.gallery, index);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource src) async {
    XFile getImage = XFile("");
    getImage = (await ImagePicker().pickImage(source: src))!;
    setState(() {
      _imgFiles.add(File(getImage.path != null ? getImage.path : ""));
    });
  }

  Future getVideo(ImageSource src) async {
    XFile selectedVideo = XFile("");
    selectedVideo = (await ImagePicker().pickVideo(source: src))!;
    setState(() {
      _videoFiles
          .add(File(selectedVideo.path != null ? selectedVideo.path : ""));
    });
  }

  Future getInformationImage(ImageSource src, int index) async {
    XFile getImage = XFile("");
    getImage = (await ImagePicker().pickImage(source: src))!;
    _categoryData["loai_1"]["images"][index] =
        getImage.path != "" ? getImage.path : null;
    _warningForChildImage[index] = "";
    setState(() {});
  }

  _questionForCreateProduct() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tạo mới"),
          content: const Text("Bạn thực sự muốn tạo mới sản phẩm ?"),
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
                _setDataForCreate();
              },
            ),
          ],
        );
      },
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
        maxLines: null,
        keyboardType: keyboardType ?? TextInputType.text,
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
            default:
              break;
          }
          setState(() {});
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
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
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
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

  Widget _buildSelectionsCategoryAndUnitComponents(
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
                  colorWord: greyColor, fontSize: 15),
              const SizedBox(height: 5),
              _category != "" &&
                      title ==
                          CreateProductMarketConstants
                              .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
                  ? buildTextContent(_category, false, fontSize: 17)
                  : const SizedBox(),
              _category != "" &&
                      _branch != "" &&
                      title ==
                          CreateProductMarketConstants
                              .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE
                  ? buildTextContent(_branch, false, fontSize: 17)
                  : const SizedBox(),
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
              showBottomSheetCheckImportantSettings(
                  context, 500, titleForBottomSheet,
                  bgColor: Colors.grey[300],
                  widget: SizedBox(
                    height: 400,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: title ==
                                CreateProductMarketConstants
                                    .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
                            ? productCategoriesData.length
                            : _childCategoriesList!.length,
                        itemBuilder: (context, index) {
                          final data = title ==
                                  CreateProductMarketConstants
                                      .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
                              ? productCategoriesData
                              : _childCategoriesList!;
                          return Container(
                            child: Column(
                              children: [
                                GeneralComponent(
                                  [
                                    buildTextContent(data[index]["text"], false)
                                  ],
                                  changeBackground: transparent,
                                  function: () {
                                    popToPreviousScreen(context);
                                    if (title ==
                                        CreateProductMarketConstants
                                            .CREATE_PRODUCT_MARKET_CATEGORY_TITLE) {
                                      _category = data[index]["text"];
                                      _productParentCategoryId =
                                          data[index]["id"];
                                      _validatorSelectionList["category"] =
                                          true;
                                      _childCategoriesList =
                                          data[index]["subcategories"];
                                      _branch = "";
                                    }
                                    if (title ==
                                        CreateProductMarketConstants
                                            .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE) {
                                      _productChildCategoryId =
                                          data[index]["id"];
                                      _branch = data[index]["text"];
                                      _validatorSelectionList["branch"] = true;
                                    }
                                    setState(() {});
                                  },
                                ),
                                buildDivider(color: red)
                              ],
                            ),
                          );
                        }),
                  ));
            },
          ),
          _validatorSelectionList["category"] == false &&
                  title ==
                      CreateProductMarketConstants
                          .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
              ? _buildWarningForSelections("Vui lòng chọn danh mục.")
              : const SizedBox(),
          _validatorSelectionList["branch"] == false &&
                  title ==
                      CreateProductMarketConstants
                          .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE
              ? _buildWarningForSelections("Vui lòng chọn ngành hàng.")
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildSelectionsPrivateRuleComponent(
      BuildContext context, String title, String titleForBottomSheet,
      {List<Map<String, dynamic>> privateDatas = CreateProductMarketConstants
          .CREATE_PRODUCT_MARKET_PRIVATE_RULE_SELECTIONS}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 15),
              const SizedBox(height: 5),
              _private != ""
                  ? buildTextContent(_private, false, fontSize: 17)
                  : const SizedBox(),
            ],
            prefixWidget: _private != ""
                ? Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: greyColor[400]),
                    child: Icon(
                      _private == privateDatas[0]["title"]
                          ? FontAwesomeIcons.earthAfrica
                          : _private == privateDatas[1]["title"]
                              ? FontAwesomeIcons.user
                              : FontAwesomeIcons.lock,
                      size: 18,
                    ),
                  )
                : null,
            suffixWidget: Container(
              alignment: Alignment.centerRight,
              height: 40,
              width: 40,
              margin: _private != ""
                  ? const EdgeInsets.only(right: 5)
                  : const EdgeInsets.only(right: 15),
              child: const Icon(
                FontAwesomeIcons.caretDown,
                size: 18,
              ),
            ),
            changeBackground: transparent,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            isHaveBorder: true,
            function: () {
              showBottomSheetCheckImportantSettings(
                  context, 500, titleForBottomSheet,
                  bgColor: Colors.grey[300],
                  widget: SizedBox(
                    height: 400,
                    child: ListView.builder(
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
                                  if (title ==
                                      CreateProductMarketConstants
                                          .CREATE_PRODUCT_MARKET_PRIVATE_RULE_TITLE) {
                                    _private = privateDatas[index]["title"];
                                    _privateKey = privateDatas[index]["key"];
                                    _validatorSelectionList["private"] = true;
                                  }
                                  setState(() {});
                                },
                              ),
                              buildDivider(color: red)
                            ],
                          );
                        }),
                  ));
            },
          ),
          _validatorSelectionList["private"] == false &&
                  title ==
                      CreateProductMarketConstants
                          .CREATE_PRODUCT_MARKET_PRIVATE_RULE_TITLE
              ? _buildWarningForSelections("Vui lòng chọn quyền riêng tư.")
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildContentForClassifyCategoryContents() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: buildTextContent("Phân loại hàng", true, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: buildTextContent(
                    !_isDetailProduct ? "Xem chi tiết" : "Thu gọn", false,
                    fontSize: 16,
                    iconData: !_isDetailProduct
                        ? FontAwesomeIcons.add
                        : FontAwesomeIcons.minus, function: () {
                  _isDetailProduct = !_isDetailProduct;
                  setState(() {});
                }),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            Column(
              children: [
                _isDetailProduct
                    ? Column(
                        children: [
                          buildSpacer(height: 10),
                          _buildInformationInput(
                              _categoryData["loai_1"]["name"],
                              width,
                              "Nhập tên phân loại 1"),
                          // phan loai 1
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Wrap(
                              children: List.generate(
                                  _categoryData["loai_1"]["values"].length,
                                  (indexDescription) => Padding(
                                        padding: EdgeInsets.only(
                                            right:
                                                indexDescription.isOdd ? 0 : 5,
                                            left: indexDescription.isEven
                                                ? 0
                                                : 5),
                                        child: _buildInformationInput(
                                            _categoryData["loai_1"]["values"]
                                                [indexDescription],
                                            width * 0.48,
                                            "Màu sắc ${indexDescription + 1}",
                                            suffixIconData: FontAwesomeIcons
                                                .close, suffixFunction: () {
                                          _deleteClassifyCategoryOne(
                                              indexDescription);
                                        }),
                                      )),
                            ),
                          ),
                          _categoryData["loai_1"]["values"].length != 10
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: buildTextContent(
                                      "Thêm mô tả cho phân loại 1: ${_categoryData["loai_1"]["values"].length}/10",
                                      false,
                                      fontSize: 13, function: () {
                                    _warningForChildImage
                                        .add("selectionImageWarning");
                                    _addClassifyCategoryOne();
                                  }),
                                )
                              : const SizedBox(),
                          _categoryData["loai_2"] == null ||
                                  _categoryData["loai_2"] == {} ||
                                  _categoryData["loai_2"].isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: buildTextContent(
                                      "Thêm nhóm phân loại", true,
                                      fontSize: 16,
                                      iconData: FontAwesomeIcons.add,
                                      isCenterLeft: false, function: () {
                                    _createClassifyCategoryTwo();
                                  }),
                                )
                              : const SizedBox(),
                          //loai 2
                          _categoryData["loai_2"] != null &&
                                  _categoryData["loai_2"] != {} &&
                                  _categoryData["loai_2"].isNotEmpty
                              ? Column(
                                  children: [
                                    buildSpacer(height: 10),
                                    _buildInformationInput(
                                        _categoryData["loai_2"]["name"],
                                        width,
                                        "Nhập tên phân loại 2"),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Wrap(
                                        children: List.generate(
                                            _categoryData["loai_2"]["values"]
                                                .length,
                                            (indexDescription) => Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          indexDescription.isOdd
                                                              ? 0
                                                              : 5,
                                                      left: indexDescription
                                                              .isEven
                                                          ? 0
                                                          : 5),
                                                  child: _buildInformationInput(
                                                      _categoryData["loai_2"]
                                                                  ["values"]
                                                              [indexDescription]
                                                          ["category_2_name"],
                                                      width * 0.48,
                                                      "Kích thước ${indexDescription + 1}",
                                                      suffixIconData:
                                                          FontAwesomeIcons
                                                              .close,
                                                      suffixFunction: () {
                                                    _deleteClassifyCategoryTwo(
                                                        indexDescription);
                                                  }),
                                                )),
                                      ),
                                    ),
                                    _categoryData["loai_2"]["values"].length !=
                                            10
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: buildTextContent(
                                                "Thêm mô tả cho phân loại 2: ${_categoryData["loai_2"]["values"].length}/10",
                                                false,
                                                fontSize: 13, function: () {
                                              _addClassifyCategoryTwo();
                                            }),
                                          )
                                        : const SizedBox(),
                                  ],
                                )
                              : const SizedBox(),
                          buildSpacer(height: 10),
                          buildDivider(color: red),
                        ],
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      _buildInformationInput(
                          _priceController, width, "Nhập giá sản phẩm",
                          keyboardType: TextInputType.number),
                      _buildInformationInput(
                          _repositoryController, width, "Nhập tên kho hàng",
                          keyboardType: TextInputType.number),
                      _buildInformationInput(
                          _skuController, width, "Nhập mã sản phẩm"),
                      _isDetailProduct
                          ? buildButtonForMarketWidget(
                              title: "Áp dụng cho tất cả ",
                              function: () {
                                if (_priceController.text.isNotEmpty &&
                                    _repositoryController.text.isNotEmpty &&
                                    _skuController.text.isNotEmpty) {
                                  _applyPriceRepositorySkuForAll();
                                }
                              })
                          : const SizedBox()
                    ],
                  ),
                ),
                // table
                _isDetailProduct
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: _categoryData["loai_2"] == {} ||
                                _categoryData["loai_2"] == null
                            ? _buildDataTableWithOneComponent()
                            : _buildDataTableForTwoComponents())
                    : const SizedBox(),
              ],
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildInformationInput(
      TextEditingController controller, double width, String hintText,
      {IconData? prefixIconData,
      IconData? suffixIconData,
      TextInputType? keyboardType,
      double? height,
      Function? suffixFunction}) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      width: width * 0.9,
      child: TextFormField(
        controller: controller,
        maxLines: null,
        keyboardType: keyboardType != null ? keyboardType : TextInputType.text,
        validator: (value) {
          if (_isDetailProduct) {
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
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
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

  Widget _buildIconAndAddImageText(String title, {Function? function}) {
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

  DataTable _buildDataTableWithOneComponent() {
    List<DataColumn> dataColumns = [];
    List<DataRow> dataRows = [];
    List<DataCell> dataCells = [];

    // phân loại hàng
    dataColumns.add(DataColumn(
        label: Text(
            _categoryData["loai_1"]["name"].text.length > 0
                ? _categoryData["loai_1"]["name"].text.trim()
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

    for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
      dataRows.add(DataRow(cells: [
        DataCell(
          Column(
            children: [
              buildSpacer(height: 5),

              buildTextContent(
                  _categoryData["loai_1"]["values"][i].text.trim(), true,
                  isCenterLeft: false, fontSize: 17),
              buildSpacer(height: 5),
              InkWell(
                onTap: () {
                  dialogInformartionImgSource(i);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: greyColor, width: 0.4)),
                  child: _categoryData["loai_1"]["images"][i] != "" &&
                          _categoryData["loai_1"]["images"][i] != null
                      ? Image.file(
                          File(_categoryData["loai_1"]["images"][i]),
                          fit: BoxFit.fitHeight,
                        )
                      : Image.asset(
                          "${MarketPlaceConstants.PATH_IMG}cat_1.png"),
                ),
              ),
              //
              _warningForChildImage[i] != null && _warningForChildImage[i] != ""
                  ? buildTextContent(
                      _warningForChildImage[i],
                      false,
                      colorWord: red,
                      fontSize: 12,
                    )
                  : const SizedBox()
            ],
          ),
        ),
        DataCell(_buildInput(
            _categoryData["loai_1"]["contents"]["price"][i], width * 0.5, "Gia",
            keyboardType: TextInputType.number)),
        DataCell(_buildInput(
            _categoryData["loai_1"]["contents"]["repository"][i],
            width * 0.5,
            "Kho hang",
            keyboardType: TextInputType.number)),
        DataCell(_buildInput(_categoryData["loai_1"]["contents"]["sku"][i],
            width * 0.5, "Ma phan loai")),
      ]));
    }
    return DataTable(
      columns: dataColumns,
      rows: dataRows,
      showBottomBorder: true,
      dataRowHeight: 100,
      dividerThickness: .4,
    );
  }

  DataTable _buildDataTableForTwoComponents() {
    List<DataColumn> dataColumns = [];
    List<DataRow> dataRows = [];
    List<DataCell> dataCells = [];

    dataColumns.add(DataColumn(
        label: Text(
            _categoryData["loai_1"]["name"].text.length > 0
                ? _categoryData["loai_1"]["name"].text.trim()
                : "Phân loại hàng 1",
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));

    dataColumns.add(DataColumn(
        label: Text(
            _categoryData["loai_2"]?["name"]?.text.length > 0
                ? _categoryData["loai_2"]["name"].text.trim()
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
    for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
      for (int z = 0; z < _categoryData["loai_2"]?["values"]?.length; z++) {
        dataRows.add(DataRow(cells: [
          z == 0
              ? DataCell(
                  Column(
                    children: [
                      buildSpacer(height: 5),
                      buildTextContent(
                          _categoryData["loai_1"]["values"][i].text.trim(),
                          true,
                          isCenterLeft: false,
                          fontSize: 17),
                      buildSpacer(height: 5),
                      InkWell(
                        onTap: () {
                          dialogInformartionImgSource(i);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: greyColor, width: 0.4)),
                          child: _categoryData["loai_1"]["images"][i] != "" &&
                                  _categoryData["loai_1"]["images"][i] != null
                              ? Image.file(
                                  File(_categoryData["loai_1"]["images"][i]),
                                  fit: BoxFit.fitHeight,
                                )
                              : Image.asset(
                                  "${MarketPlaceConstants.PATH_IMG}cat_1.png"),
                        ),
                      ),
                      _warningForChildImage[i] != null &&
                              _warningForChildImage[i] != ""
                          ? buildTextContent(
                              _warningForChildImage[i],
                              false,
                              colorWord: red,
                              fontSize: 8,
                            )
                          : const SizedBox()
                    ],
                  ),
                )
              : const DataCell(SizedBox()),
          DataCell(
            buildTextContent(
                _categoryData["loai_2"]?["values"][z]["category_2_name"]
                    .text
                    .trim(),
                true,
                isCenterLeft: false,
                fontSize: 17),
          ),
          DataCell(_buildInput(
              _categoryData["loai_2"]?["values"][z]["price"][i],
              width * 0.5,
              "Giá",
              keyboardType: TextInputType.number)),
          DataCell(_buildInput(
              _categoryData["loai_2"]?["values"][z]["repository"][i],
              width * 0.5,
              "Kho hàng",
              keyboardType: TextInputType.number)),
          DataCell(_buildInput(_categoryData["loai_2"]?["values"][z]["sku"][i],
              width * 0.5, "Mã phân loại")),
        ]));
      }
    }

    return DataTable(
      columns: dataColumns,
      rows: dataRows,
      showBottomBorder: true,
      dataRowHeight: 100,
      dividerThickness: .4,
    );
  }
}

Widget _buildDeleteOrFixIconForImageWidget(IconData iconData,
    {Function? function}) {
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

Widget _buildWarningForSelections(String warning) {
  return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: buildTextContent(warning, false,
          fontSize: 12, colorWord: Colors.red[800]));
}
