import 'dart:io';
import 'dart:math';

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
import 'package:social_network_app_mobile/screen/MarketPlace/screen/create_product_module/sale_information_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/payment_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../update_product_module/update_information_market_page.dart';

class CreateProductMarketPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreateProductMarketPage> createState() =>
      _CreateProductMarketPageState();
}

class _CreateProductMarketPageState
    extends ConsumerState<CreateProductMarketPage> {
  late double width = 0;
  late double height = 0;
  String _category = "";
  String _branch = "";
  String _private = "";
  List<File> _imgFiles = [];
  final Map<String, bool> _validatorSelectionList = {
    "category": true,
    "branch": true,
    "private": true,
    "image": true
  };
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController(text: "jgh");
  final TextEditingController _descriptionController =
      TextEditingController(text: "jhjh");
  final TextEditingController _branchController =
      TextEditingController(text: "jhggjh");
  final TextEditingController _priceController =
      TextEditingController(text: "");
  final TextEditingController _repositoryController =
      TextEditingController(text: "");
  final TextEditingController _skuController = TextEditingController(text: "");

  //
  final List<TextEditingController> _categoryControllers = [
    TextEditingController(text: "")
  ];
  late Map<String, dynamic> newData;
  bool _isLoading = false;
  List<dynamic>? _parentCategoriesList;
  List<dynamic>? _childCategoriesList;
  List<dynamic> productcategoriesData = [];
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    // _buildParentCategoriesList();
    productcategoriesData = ref.watch(productCategoriesProvider).list;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(title: "Thêm sản phẩm"),
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
                              // dataList: CreateProductMarketConstants
                              //     .CREATE_PRODUCT_MARKET_PRIVATE_RULE_SELECTIONS
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
                              decoration: _imgFiles.length == 0
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: greyColor, width: 0.4),
                                      borderRadius: BorderRadius.circular(7))
                                  : null,
                              child: _imgFiles.length == 0
                                  ? _buildIconAndAddImageText()
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
                                            // decoration: BoxDecoration(
                                            //     border: Border.all(
                                            //         color: greyColor, width: 0.4),
                                            //     borderRadius:
                                            //         BorderRadius.circular(7)),
                                            child: Stack(
                                              children: [
                                                Container(
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
                                              child:
                                                  _buildIconAndAddImageText(),
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
                        _validatorSelectionList["image"] == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 10),
                                child: buildTextContent(
                                    _imgFiles.length == 9
                                        ? ""
                                        : "Chọn ${_imgFiles.length}/9. Hãy nhập ảnh chính của bài niêm yết.",
                                    false,
                                    colorWord: greyColor,
                                    fontSize: 13),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                ),
                                child: _buildWarningForSelections(
                                    "Chọn ảnh để tiếp tục"),
                              ),
                        // sales information
                        buildDivider(color: red),
                        buildSpacer(height: 10),
                        buildTextContent("Thông tin bán hàng", true,
                            isCenterLeft: false),
                        // classify category
                        buildSpacer(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildTextContent("Phân loại hàng", true,
                                fontSize: 16),
                            buildTextContent(
                                Random().nextInt(1) == 0
                                    ? "Xem chi tiết"
                                    : "Thêm nhóm phân loại",
                                false,
                                fontSize: 16,
                                iconData: FontAwesomeIcons.add, function: () {
                              pushToNextScreen(
                                  context, SaleInformationMarketPage());
                            })
                          ],
                        ),
                        buildSpacer(height: 10),
                        (ref
                                        .watch(newProductDataProvider)
                                        .data["product_options_attributes"] ==
                                    null ||
                                ref
                                    .watch(newProductDataProvider)
                                    .data["product_options_attributes"]
                                    .isEmpty)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    _buildInput(_priceController, width,
                                        "Nhập giá sản phẩm",
                                        keyboardType: TextInputType.number),
                                    _buildInput(_repositoryController, width,
                                        "Nhập tên kho hàng"),
                                    _buildInput(_skuController, width,
                                        "Nhập mã sản phẩm"),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        // CircularProgressIndicator()
                      ]),
                    ),
                    // add to cart and buy now
                    Container(
                      // height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: buildButtonForMarketWidget(
                                width: width,
                                bgColor: Colors.orange[300],
                                title: "Tạo sản phẩm",
                                function: () {
                                  validateForCreateProduct();
                                }),
                          ),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        child: const CircularProgressIndicator(
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

  validateForCreateProduct() async {
    if (_category == "") {
      _validatorSelectionList["category"] = false;
    }
    if (_branch == "") {
      _validatorSelectionList["branch"] = false;
    }
    if (_private == "") {
      _validatorSelectionList["private"] = false;
    }
    if (_imgFiles.length == 0) {
      _validatorSelectionList["image"] = false;
    }
    if (_formKey.currentState!.validate() &&
        _validatorSelectionList["private"] == true &&
        _validatorSelectionList["branch"] == true &&
        _validatorSelectionList["category"] == true &&
        _validatorSelectionList["image"] == true) {
      setState(() {
        _isLoading = true;
      });
      List<String> product_images =
          await Future.wait(_imgFiles.map((element) async {
        String fileName = element.path.split('/').last;
        FormData formData = FormData.fromMap({
          "file":
              await MultipartFile.fromFile(element.path, filename: fileName),
        });
        final response = await MediaApi().uploadMediaEmso(formData);
        return response["id"].toString();
      }));

      // Future.delayed(Duration(seconds: 10), () {
      newData["product_images"] = product_images;

      // them vao product_video
      // them vao product
      newData["product"]["title"] = _nameController.text.trim();
      newData["product"]["description"] = _descriptionController.text.trim();
      newData["product"]["product_category_id"] = null;
      newData["product"]["brand"] = _branch.trim();
      newData["product"]["visibility"] = _private.trim();
      newData["product"]["page_id"] = null;
      // them vao product_options_attributes
      /////////////////// được thêm từ trang sale_information_market_page.dart
      ///
      // them vao product_variants_attributes
      /////////////////// được thêm từ trang sale_information_market_page.dart
      // sua ten san pham trong truong hop khi sang trang kia null ma khi luu lai co gia tri khac null
      for (int i = 0; i < newData["product_variants_attributes"].length; i++) {
        newData["product_variants_attributes"][i] =
            "${_nameController.text.trim()} - ${newData["product_variants_attributes"][i]["option1"]}${newData["product_variants_attributes"][i]["option2"] == null ? "" : " - ${newData["product_variants_attributes"][i]["option2"]}"}";
      }

      ref.read(newProductDataProvider.notifier).updateNewProductData(newData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Lưu thành công",
        style: TextStyle(color: Colors.green),
      )));

      setState(() {
        _isLoading = false;
      });
      // });
    }
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
        keyboardType: keyboardType != null ? keyboardType : TextInputType.text,
        validator: (value) {
          switch (hintText) {
            case CreateProductMarketConstants
                .CREATE_PRODUCT_MARKET_PRODUCT_NAME_PLACEHOLDER:
              if (value!.length <= 0) {
                return CreateProductMarketConstants
                    .CREATE_PRODUCT_MARKET_PRODUCT_NAME_WARING;
              }
              break;
            case CreateProductMarketConstants
                .CREATE_PRODUCT_MARKET_BRAND_PLACEHOLDER:
              if (value!.length <= 0) {
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

  _buildSelectionsCategoryAndUnitComponents(
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
            suffixWidget: Container(
              height: 40,
              width: 40,
              child: const Icon(
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
                  widget: Container(
                    height: 400,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: title ==
                                CreateProductMarketConstants
                                    .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
                            ? productcategoriesData.length
                            : _childCategoriesList!.length,
                        itemBuilder: (context, index) {
                          final data = title ==
                                  CreateProductMarketConstants
                                      .CREATE_PRODUCT_MARKET_CATEGORY_TITLE
                              ? productcategoriesData
                              : _childCategoriesList!;
                          return Container(
                            child: Column(
                              children: [
                                GeneralComponent(
                                  [buildTextContent(data[index].text, false)],
                                  changeBackground: transparent,
                                  function: () {
                                    popToPreviousScreen(context);
                                    if (title ==
                                        CreateProductMarketConstants
                                            .CREATE_PRODUCT_MARKET_CATEGORY_TITLE) {
                                      _category = data[index]["text"];
                                      _validatorSelectionList["category"] =
                                          true;
                                      _childCategoriesList =
                                          data[index]["subcategories"];
                                      _branch = "";
                                    }
                                    if (title ==
                                        CreateProductMarketConstants
                                            .CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE) {
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

  _buildSelectionsPrivateRuleComponent(
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
                  widget: Container(
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
                                prefixWidget: Container(
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

  Future getImage(ImageSource src) async {
    XFile getImage = XFile("");
    getImage = (await ImagePicker().pickImage(source: src))!;
    setState(() {
      _imgFiles.add(File(getImage.path != null ? getImage.path : ""));
    });
  }

  dialogImgSource() {
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

  Widget _buildIconAndAddImageText() {
    return InkWell(
      onTap: () {
        dialogImgSource();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            MarketPlaceConstants.PATH_ICON + "add_img_file_icon.svg",
            height: 20,
          ),
          buildSpacer(width: 5),
          buildTextContent(
              CreateProductMarketConstants
                  .CREATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER,
              false,
              isCenterLeft: false,
              fontSize: 15),
        ],
      ),
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
