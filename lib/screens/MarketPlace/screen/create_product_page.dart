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
import 'package:market_place/providers/market_place_providers/page_list_provider.dart';
import 'package:market_place/providers/market_place_providers/product_categories_provider.dart';
import 'package:market_place/providers/market_place_providers/products_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/manage_product_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/apis/market_place_apis/products_api.dart';
import 'package:market_place/apis/media_api.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';
import 'package:market_place/widgets/video_render_player.dart';

class CreateProductMarketPage extends ConsumerStatefulWidget {
  const CreateProductMarketPage({super.key});

  @override
  ConsumerState<CreateProductMarketPage> createState() =>
      _DemoCreateProductMarketPageState();
}

String selectPageTitle = "Chọn Page";

class _DemoCreateProductMarketPageState
    extends ConsumerState<CreateProductMarketPage> {
  late double width = 0;
  late double height = 0;
  String _category = "";
  String _branch = "";
  dynamic _private;
  Map<String, dynamic>? _privateData = {};
  final List<File> _imgFiles = [];
  final List<File> _videoFiles = [];

  final Map<String, bool> _validatorSelectionList = {
    "category": true,
    "branch": true,
    "private": true,
    "image": true,
    "page": true
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bottomFormKey = GlobalKey<FormState>();
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

  dynamic _selectParentCategory;
  dynamic _selectChildCategory;
  dynamic _selectedPage;
  List? _listPage;
  List<String> previewClassifyValues = ["", ""];
  Map<String, dynamic>? _categoryData = {
    "loai_1": {
      "name": TextEditingController(text: ""),
      "values": [
        TextEditingController(text: ""),
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
  bool? _isDetailEmpty = false;

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
    Future.delayed(Duration.zero, () {
      final listPage = ref.read(pageListProvider.notifier).getPageList();
    });

    setState(() {
      _private ??= CreateProductMarketConstants
          .CREATE_PRODUCT_MARKET_PRIVATE_RULE_SELECTIONS[0];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _childCategoriesList = [];
    productCategoriesData = [];
    _listPage = [];
    newData = {};
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Future.wait([_initSelections()]);

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
              const AppBarTitle(text: "Tạo sản phẩm"),
              const Icon(
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(children: [
                            buildDivider(
                              color: red,
                            ),
                            _categoryUnitPageSelection(
                              context,
                              selectPageTitle,
                              selectPageTitle,
                            ),
                            // ten san pham
                            _buildInformationInput(
                              _nameController,
                              width,
                              CreateProductMarketConstants
                                  .CREATE_PRODUCT_MARKET_PRODUCT_NAME_PLACEHOLDER,
                            ),
                            // danh muc
                            _categoryUnitPageSelection(
                              context,
                              CreateProductMarketConstants
                                  .CREATE_PRODUCT_MARKET_CATEGORY_TITLE,
                              "Chọn hạng mục",
                            ),
                            // nganh hang (option)
                            _category != ""
                                ? _categoryUnitPageSelection(
                                    context,
                                    CreateProductMarketConstants
                                        .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE,
                                    "Chọn ngành hàng",
                                  )
                                : const SizedBox(),
                            // mo ta san pham
                            _buildInformationInput(
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
                            _buildInformationInput(
                                _branchController,
                                width,
                                CreateProductMarketConstants
                                    .CREATE_PRODUCT_MARKET_BRAND_PLACEHOLDER),
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
                        _buildVideoSelection(),
                        // mô tả video
                        _buildVideoDescription(),
                        // thong tin chi tiet
                        buildSpacer(height: 10),
                        buildSpacer(
                            width: width, color: greyColor[400], height: 5),
                        buildSpacer(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: width,
                      child: GestureDetector(
                        onTap: () {},
                        child: buildMarketButton(
                            width: width,
                            bgColor: Colors.orange[300],
                            contents: [
                              buildTextContent("Tạo sản phẩm", false,
                                  fontSize: 13)
                            ],
                            function: () {
                              validateForCreate();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              _isLoading ? buildCircularProgressIndicator() : const SizedBox(),
            ],
          ),
        ));
  }

  dynamic showCategoryBottom() {
    return showCustomBottomSheet(context, height - 50,
        title: "Phân loại hàng",
        paddingHorizontal: 0,
        enableDrag: false,
        isDismissible: false, prefixFunction: () {
      if (_bottomFormKey.currentState!.validate() &&
          _categoryData!["loai_1"]["images"].every((element) {
            return element != "";
          })) {
        popToPreviousScreen(context);
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
                                      setStatefull(
                                        () {
                                          _isDetailEmpty = !_isDetailEmpty!;
                                        },
                                      );
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
                                          additionalFunction: () {
                                            setStatefull(() {});
                                          },
                                          maxLength: 14,
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
                                                          child: _categoryData!["loai_1"]
                                                                              [
                                                                              "images"]
                                                                          [
                                                                          index] !=
                                                                      null &&
                                                                  _categoryData!["loai_1"]
                                                                              [
                                                                              "images"]
                                                                          [
                                                                          index] !=
                                                                      ""
                                                              ? Image.file(
                                                                  File(_categoryData![
                                                                              "loai_1"]
                                                                          [
                                                                          "images"]
                                                                      [index]),
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
                                                              child: _buildInformationInput(
                                                                  _categoryData!["loai_2"]
                                                                              [
                                                                              "values"]
                                                                          [
                                                                          indexDescription]
                                                                      [
                                                                      "category_2_name"],
                                                                  width * 0.48,
                                                                  "Thuộc tính 2: ${indexDescription + 1}",
                                                                  additionalFunction:
                                                                      () {
                                                                    setStatefull(
                                                                        () {});
                                                                  },
                                                                  maxLength: 20,
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

  Future<int> _initSelections() async {
    if (_listPage == null || _listPage!.isEmpty) {
      _listPage = await ref.watch(pageListProvider).listPage;
    }
    if (productCategoriesData.isEmpty) {
      productCategoriesData = ref.watch(parentCategoryController).parentList;
    }
    if (_listPage!.isNotEmpty && _selectedPage == null) {
      _selectedPage = _listPage![0];
    }
    if (_selectParentCategory != null) {
      _childCategoriesList =
          await _callChildCategory(_selectParentCategory["id"]);
    }
    previewClassifyValues = ["", ""];
    if (_categoryData != null) {
      if (_categoryData!["loai_1"]["name"].text.trim() != "") {
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
    } else {
      previewClassifyValues = [];
    }
    setState(() {});
    return 0;
  }

  Future<dynamic> _callChildCategory(dynamic id) async {
    final response = await CategoryProductApis().getChildCategoryProductApi(id);
    return response;
  }

  Future<void> validateForCreate() async {
    _validatorSelectionList["category"] = true;
    _validatorSelectionList["branch"] = true;
    _validatorSelectionList["private"] = true;
    _validatorSelectionList["image"] = true;
    _validatorSelectionList["page"] = true;
    if (_category == "") {
      _validatorSelectionList["category"] = false;
    }
    if (_branch == "") {
      _validatorSelectionList["branch"] = false;
    }
    if (_selectedPage == null || _selectedPage.isEmpty) {
      _validatorSelectionList["page"] = false;
    }
    if (_private == null || _private.isEmpty) {
      _validatorSelectionList["private"] = false;
    }
    if (_imgFiles.isEmpty) {
      _validatorSelectionList["image"] = false;
    }
    // for(int i)hgj
    if (_formKey.currentState!.validate() &&
        _validatorSelectionList["private"] == true &&
        _validatorSelectionList["branch"] == true &&
        _validatorSelectionList["category"] == true &&
        _validatorSelectionList["image"] == true &&
        _validatorSelectionList["page"] == true) {
      _questionForCreateProduct();
    }
    setState(() {});
  }

  Future _setDataForCreate() async {
    setState(() {
      _isLoading = true;
    });
    newData = {
      "product_images": [],
      "product_video": null,
      "product": {},
      "product_options_attributes": [],
      "product_variants_attributes": []
    };
    List<String> productImages =
        await Future.wait(_imgFiles.map((element) async {
      String fileName = element.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(element.path, filename: fileName),
      });
      final response = await MediaApi().uploadMediaEmso(formData);
      return response["id"].toString();
    }).toList());
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
        _selectChildCategory["id"] ?? _selectParentCategory["id"];
    newData["product"]["brand"] = _branch.trim();
    newData["product"]["visibility"] = _private["key"].trim();
    newData["product"]["page_id"] = _selectedPage["id"];
    // them vao product_options_attributes
    if (previewClassifyValues[0] != "") {
      // them loai_1
      Map<String, dynamic> loai_1 = {
        "name": _categoryData!["loai_1"]["name"].text.trim(),
        "position": 1,
        "values": _categoryData!["loai_1"]["values"]
            .map((e) => e.text.trim())
            .toList()
      };
      newData["product_options_attributes"].add(loai_1);

      // them loai_2 (neu co)
      if (_categoryData!["loai_2"] != null) {
        Map<String, dynamic> loai_2 = {
          "name": _categoryData!["loai_2"]["name"].text.trim(),
          "position": 2,
          "values": _categoryData!["loai_2"]["values"]
              .map((e) => e["category_2_name"].text.trim())
              .toList()
        };
        newData["product_options_attributes"].add(loai_2);
      }
    } else {
      newData["product_options_attributes"] = null;
    }
    // them vao product_variants_attributes
    if (previewClassifyValues[0] != "") {
      List<String> imgList = _categoryData!["loai_1"]["images"].toList();
      List<String> imageIdList = await Future.wait(imgList.map((element) async {
        if (element == "") {
          return "";
        }
        String fileName = element.split('/').last;
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(element, filename: fileName),
        });
        final response = await MediaApi().uploadMediaEmso(formData);
        return response["id"].toString();
      }).toList());
      if (_categoryData!["loai_2"] == null) {
        for (int i = 0;
            i < newData["product_options_attributes"][0]["values"].length;
            i++) {
          newData["product_variants_attributes"].add({
            "title":
                "${_nameController.text.trim()} - ${newData["product_options_attributes"][0]["values"][i]}",
            "price": _categoryData!["loai_1"]["contents"]["price"][i]
                .text
                .trim()
                .toString(),
            "sku": _categoryData!["loai_1"]["contents"]["sku"][i]
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
            "inventory_quantity": _categoryData!["loai_1"]["contents"]
                    ["repository"][i]
                .text
                .trim(),
            "old_inventory_quantity": _categoryData!["loai_1"]["contents"]
                    ["repository"][i]
                .text
                .trim(),
            "requires_shipping": true
          });
        }
      } else {
        for (int i = 0; i < _categoryData!["loai_1"]["values"].length; i++) {
          for (int z = 0; z < _categoryData!["loai_2"]["values"].length; z++) {
            newData["product_variants_attributes"].add({
              "title":
                  "${_nameController.text.trim()} -${_categoryData!["loai_1"]["values"][i].text.trim()} - ${_categoryData!["loai_2"]["values"][z]["category_2_name"].text.trim()}",
              "price": _categoryData!["loai_2"]["values"][z]["price"][i]
                  .text
                  .trim()
                  .toString(),
              "sku": _categoryData!["loai_2"]["values"][z]["sku"][i]
                  .text
                  .trim()
                  .toString(),
              "position": 2,
              "compare_at_price": null,
              "option1": _categoryData!["loai_1"]["values"][i].text.trim(),
              "option2": _categoryData!["loai_2"]["values"][z]
                      ["category_2_name"]
                  .text
                  .trim(),
              "image_id": imageIdList[i],
              "weight": 0.25,
              "weight_unit": "Kg",
              "inventory_quantity": _categoryData!["loai_2"]["values"][z]
                      ["repository"][i]
                  .text
                  .trim(),
              "old_inventory_quantity": _categoryData!["loai_2"]["values"][z]
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
    final response = await postCreateApi(newData);
    final reloadSuggestData = await ProductsApi().getProductsApi();
    buildMessageDialog(context, "Tạo sản phẩm thành công =))", oneButton: true);
    Future.delayed(const Duration(seconds: 1), () {
      popToPreviousScreen(context);
      pushAndReplaceToNextScreen(context, const ManageProductMarketPage());
    });

    setState(() {
      _isLoading = false;
      newData = {};
    });
  }

  Future postCreateApi(dynamic data) async {
    ref.read(productsProvider.notifier).createProduct(data);
  }

  Future<dynamic> uploadMedia(List<dynamic> mediaList) async {
    return Future.wait(mediaList.map((element) async {
      String fileName = element.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(element.path, filename: fileName),
      });
      final response = await MediaApi().uploadMediaEmso(formData);
      return response["id"].toString();
    }));

    List<String> productImages =
        await Future.wait(mediaList.map((element) async {
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

  void _addItemCategoryOne() {
    // them cac the input vao loai 1
    _categoryData!["loai_1"]["values"].add(TextEditingController(text: ""));
    _categoryData!["loai_1"]["images"].add("");
    _categoryData!["loai_1"]["contents"]["price"]
        .add(TextEditingController(text: ""));
    _categoryData!["loai_1"]["contents"]["repository"]
        .add(TextEditingController(text: ""));
    _categoryData!["loai_1"]["contents"]["sku"]
        .add(TextEditingController(text: ""));
    // them cac the input vao loai 2 (neu co)

    if (_categoryData!["loai_2"] != {} && _categoryData!["loai_2"] != null) {
      for (int i = 0; i < _categoryData!["loai_2"]?["values"]?.length; i++) {
        _categoryData!["loai_2"]?["values"]?[i]["price"]
            .add(TextEditingController(text: ""));
        _categoryData!["loai_2"]?["values"]?[i]["repository"]
            .add(TextEditingController(text: ""));
        _categoryData!["loai_2"]?["values"]?[i]["sku"]
            .add(TextEditingController(text: ""));
      }
    }
    setState(() {});
  }

  void _deleteItemCategoryOne(int index) {
    // xoa trong loai_1
    if (_categoryData!["loai_1"]["values"].length != 1) {
      _categoryData!["loai_1"]["images"].removeAt(index);
      _categoryData!["loai_1"]["values"].removeAt(index);
      _categoryData!["loai_1"]["contents"]["price"].removeAt(index);
      _categoryData!["loai_1"]["contents"]["repository"].removeAt(index);
      _categoryData!["loai_1"]["contents"]["sku"].removeAt(index);
      // xoa trong loai_2 (neu co)
      if (_categoryData!["loai_2"] != null && _categoryData!["loai_2"] != {}) {
        for (int i = 0; i < _categoryData!["loai_2"]["values"].length; i++) {
          _categoryData!["loai_2"]["values"][i]["price"].removeAt(index);
          _categoryData!["loai_2"]["values"][i]["repository"].removeAt(index);
          _categoryData!["loai_2"]["values"][i]["sku"].removeAt(index);
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
    for (int i = 0; i < _categoryData!["loai_1"]["values"].length; i++) {
      primaryData["values"][0]["price"].add(TextEditingController(text: ""));
      primaryData["values"][0]["repository"]
          .add(TextEditingController(text: ""));
      primaryData["values"][0]["sku"].add(TextEditingController(text: ""));
    }

    setState(() {
      _categoryData!["loai_2"] = primaryData;
    });
  }

  void _addItemCategoryTwo() {
    // them cac the input vao loai 2
    List<dynamic> valuesCategory2 = _categoryData!["loai_2"]["values"];
    Map<String, dynamic> primaryData = {
      "category_2_name": TextEditingController(text: ""),
      "price": [],
      "repository": [],
      "sku": []
    };

    for (int i = 0; i < _categoryData!["loai_1"]["values"].length; i++) {
      primaryData["price"].add(TextEditingController(text: ""));
      primaryData["repository"].add(TextEditingController(text: ""));
      primaryData["sku"].add(TextEditingController(text: ""));
    }
    valuesCategory2.add(primaryData.cast<String, Object>());
    _categoryData!["loai_2"]["values"] = valuesCategory2;
    setState(() {});
  }

  void _deleteItemCategoryTwo(int index) {
    // xoa phan tu trong phan loai 2
    if (_categoryData!["loai_2"]["values"].length > 1) {
      _categoryData!["loai_2"]["values"].removeAt(index);
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
    for (int i = 0; i < _categoryData!["loai_1"]["values"].length; i++) {
      _categoryData!["loai_1"]["contents"]["price"][i].text =
          _priceController.text.trim();
      _categoryData!["loai_1"]["contents"]["repository"][i].text =
          _repositoryController.text.trim();
      _categoryData!["loai_1"]["contents"]["sku"][i].text =
          _skuController.text.trim();
    }
    // ap dung cho cac phan loai 2
    if (_categoryData!["loai_2"] != null && _categoryData!["loai_2"] != {}) {
      for (int i = 0; i < _categoryData!["loai_1"]["values"].length; i++) {
        for (int z = 0; z < _categoryData!["loai_2"]["values"].length; z++) {
          _categoryData!["loai_2"]["values"][z]["price"][i].text =
              _priceController.text.trim();
          _categoryData!["loai_2"]["values"][z]["repository"][i].text =
              _repositoryController.text.trim();
          _categoryData!["loai_2"]["values"][z]["sku"][i].text =
              _skuController.text.trim();
        }
      }
    }
    setState(() {});
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

  Future _questionForCreateProduct() {
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
                FocusManager.instance.primaryFocus!.unfocus();
                Navigator.of(context).pop();
                _setDataForCreate();
              },
            ),
          ],
        );
      },
    );
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

  Future getInformationImage(ImageSource src, int index,
      {Function? function}) async {
    XFile getImage = XFile("");
    getImage = (await ImagePicker().pickImage(source: src))!;
    _categoryData!["loai_1"]["images"][index] =
        getImage.path != "" ? getImage.path : null;
    setState(() {});
    function != null ? function() : null;
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
          decoration: _imgFiles.isEmpty
              ? BoxDecoration(
                  border: Border.all(color: greyColor, width: 0.4),
                  borderRadius: BorderRadius.circular(7))
              : null,
          child: _imgFiles.isEmpty
              ? _iconAndAddImage(
                  CreateProductMarketConstants
                      .CREATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER, function: () {
                  dialogImgSource();
                })
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(_imgFiles.length + 1, (index) {
                    if (index < _imgFiles.length) {
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
                                child: Image.file(
                                  _imgFiles[index],
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _deleteOrFixIcon(Icons.close, function: () {
                                    _imgFiles.remove(_imgFiles[index]);
                                    setState(() {});
                                  }),
                                  _deleteOrFixIcon(Icons.wifi_protected_setup,
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
    return _validatorSelectionList["image"] == false && _imgFiles.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
            ),
            child: _buildWarningSelection("Chọn ảnh để tiếp tục"),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10),
            child: buildTextContent(
                _imgFiles.length == 9
                    ? ""
                    : "Chọn ${_imgFiles.length}/9. Hãy nhập ảnh chính của bài niêm yết.",
                false,
                colorWord: greyColor,
                fontSize: 13),
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
                  child: _videoFiles.isEmpty
                      ? Container(
                          height: 150,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: greyColor, width: 0.4),
                              borderRadius: BorderRadius.circular(7)),
                          child: _iconAndAddImage("Thêm video", function: () {
                            dialogVideoSource();
                          }),
                        )
                      : Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 150,
                          width: 170,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 150,
                                width: 170,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: VideoPlayerRender(
                                    path: _videoFiles[0].path,
                                    // fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, right: 10),
                                      child: _deleteOrFixIcon(Icons.close,
                                          function: () {
                                        _videoFiles.remove(_videoFiles[0]);
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

  Widget _categoryUnitPageSelection(
    BuildContext context,
    String title,
    String titleForBottomSheet,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
              showCustomBottomSheet(context, 500,
                  title: titleForBottomSheet,
                  widget: SizedBox(
                    height: 400,
                    child: FutureBuilder(
                        future: _initSelections(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final data = title == selectPageTitle
                                ? _listPage!
                                : title ==
                                        CreateProductMarketConstants
                                            .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
                                    ? productCategoriesData
                                    : _childCategoriesList!;
                            return data.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          GeneralComponent(
                                            [
                                              buildTextContent(
                                                  data[index]["text"] ??
                                                      data[index]["title"],
                                                  false)
                                            ],
                                            changeBackground: transparent,
                                            function: () async {
                                              popToPreviousScreen(context);
                                              if (title ==
                                                  CreateProductMarketConstants
                                                      .CREATE_PRODUCT_MARKET_CATEGORY_TITLE) {
                                                _category = data[index]["text"];
                                                _selectParentCategory =
                                                    data[index];
                                                _validatorSelectionList[
                                                    "category"] = true;
                                                _childCategoriesList =
                                                    await _callChildCategory(
                                                        data[index]["id"]);
                                                _branch = "";
                                              }
                                              if (title ==
                                                  CreateProductMarketConstants
                                                      .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE) {
                                                _selectChildCategory =
                                                    data[index];
                                                _branch = data[index]["text"];
                                                _validatorSelectionList[
                                                    "branch"] = true;
                                              }
                                              if (title == selectPageTitle) {
                                                _selectedPage = data[index];
                                                _validatorSelectionList[
                                                    "page"] = true;
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          buildDivider(color: red)
                                        ],
                                      );
                                    })
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildTextContent(
                                          "Bạn chưa sở hữu trang nào, vui lòng tạo page trước",
                                          false,
                                          isCenterLeft: false),
                                      buildSpacer(height: 10),
                                      buildMarketButton(
                                          contents: [
                                            buildTextContent(
                                                "Tạo sản phẩm", false,
                                                fontSize: 13)
                                          ],
                                          width: width * 0.5,
                                          function: () {
                                            buildMessageDialog(context,
                                                "Vui lòng sang web tạo page nhé !!",
                                                oneButton: true);
                                          })
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
    if (_selectedPage != null && title == selectPageTitle) {
      return buildTextContent(_selectedPage["title"], false, fontSize: 17);
    }

    if (_category != "" &&
        title ==
            CreateProductMarketConstants.CREATE_PRODUCT_MARKET_CATEGORY_TITLE) {
      return buildTextContent(_category, false, fontSize: 17);
    }

    if (_category != "" &&
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
                  ? buildTextContent(_private["title"], false, fontSize: 17)
                  : _categoryData!["loai_1"]["name"].text.trim() != ""
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
                    ? _private["key"] == privateDatas[0]["key"]
                        ? FontAwesomeIcons.earthAfrica
                        : _private["key"] == privateDatas[1]["key"]
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
                      title: titleForBottomSheet ?? "",
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
                                    _private = privateDatas[index];
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
        keyboardType: keyboardType != null ? keyboardType : TextInputType.text,
        maxLength: maxLength,
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

          if (_categoryData!["loai_1"]["name"].text.trim() != "") {
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

  Widget _buildGeneralInputWidget(
      {double? inputHeight, EdgeInsets? contentPadding, String? applyTitlte}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _buildInformationInput(_priceController, width, "Nhập giá sản phẩm",
              height: inputHeight,
              maxLength: 12,
              contentPadding: contentPadding,
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
