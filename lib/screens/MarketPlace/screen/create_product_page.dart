import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/brand_api.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/category_product_apis.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/products_api.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/page_list_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/product_categories_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/manage_product_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/add_media_widget.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/delete_fix_image.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/dialog_media_picker.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/video_player.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateProductMarketPage extends ConsumerStatefulWidget {
  // update product
  final dynamic id;
  const CreateProductMarketPage({super.key, this.id});

  @override
  ConsumerState<CreateProductMarketPage> createState() =>
      _DemoCreateProductMarketPageState();
}

String selectPageTitle = "Page của bạn";
String preOderProduct = "Hàng đặt trước";
List<dynamic> preOderSelections = [
  {
    "text": "Không",
  },
  {"text": "Đồng ý"}
];
String statusProduct = "Tình trạng";
List<dynamic> statusProductSelections = [
  {"text": "Mới"},
  {"text": "Đã sử dụng"}
];

class _DemoCreateProductMarketPageState
    extends ConsumerState<CreateProductMarketPage>
    with TickerProviderStateMixin {
  late double width = 0;
  late double height = 0;
  dynamic _branchSelectedValue;
  List<File> _imgFiles = [];
  List<File> _videoFiles = [];

  Map<String, bool> _validatorSelectionList = {
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

  late Map<String, dynamic> newData;
  bool _isLoading = false;
  // bao gom cac list category theo chieu cha den con
  List<dynamic> _listCategoryData = [];
  List<dynamic> _listCategoriesSelectedValue = [];

  /// cac form data được lay ra tu phuong thuc goi cac api con
  List<dynamic> _listDetailInforData = [];
  List<dynamic> _listDetailInforSelectedValue = [];
  dynamic _selectedPage;
  List _brandListFromCategory = [];
  List _listPage = [];
  List<String> _previewClassifyValues = ["", ""];
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
  TabController? _tabController;
  int _currentCategoryTabIndex = 0;
  dynamic _preOderSelectedValue;
  dynamic _statusProductSelectedValue;
  final int _preOrderTimeSelectedValue = 7;
  final TextEditingController _createOptionController =
      TextEditingController(text: "");

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
    _preOderSelectedValue = preOderSelections[0];
    _statusProductSelectedValue = statusProductSelections[0];
  }

  @override
  void dispose() {
    super.dispose();
    _listCategoryData = [];
    _listPage = [];
    newData = {};
    _imgFiles = [];
    _videoFiles = [];
    _validatorSelectionList = {};
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _repositoryController.dispose();
    _skuController.dispose();
    _weightController.dispose();
    _sizeLengthController.dispose();
    _sizeHeightController.dispose();
    _sizeWidthController.dispose();
    _listCategoryData = [];
    _listCategoriesSelectedValue = [];
    _listDetailInforData = [];
    _listDetailInforSelectedValue = [];
    _brandListFromCategory = [];
    _listPage = [];
    _previewClassifyValues = [];
    _categoryData = null;
    _createOptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
              const AppBarTitle(title: "Tạo sản phẩm"),
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
                              color: greyColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: buildTextContent("Thông tin cơ bản", true,
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
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: buildSpacer(
                            width: width,
                            color: greyColor[400],
                            height: 5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: buildTextContent("Thông tin chi tiết", true,
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
                                  (e['product_attribute']?['count_values'] ?? 0) <= 1
                                      ? "Chọn một "
                                      : "Chọn nhiều",
                                  isGrantedCreateOptions: true,
                                  useCheckbox:
                                      !((e['product_attribute']?['count_values'] ?? 0) <=
                                          1),
                                  useRatio: (e['product_attribute']?['count_values'] ?? 0) <=
                                      1,
                                  checkedList:
                                      _listDetailInforSelectedValue[_listDetailInforData.indexOf(e)]
                                          ['value'], onSelected: (newData) {
                                if (!_listDetailInforSelectedValue[
                                            _listDetailInforData.indexOf(e)]
                                        ['value']
                                    .contains(newData)) {
                                  if ((e?['product_attribute']
                                              ?['count_values'] ??
                                          0) <=
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
                                              _listDetailInforData.indexOf(e)]
                                          ['value'][0] = newData;
                                    }
                                  } else {
                                    _listDetailInforSelectedValue[
                                                _listDetailInforData.indexOf(e)]
                                            ['value']
                                        .add(newData);
                                  }
                                } else {
                                  _listDetailInforSelectedValue[
                                              _listDetailInforData.indexOf(e)]
                                          ['value']
                                      .remove(newData);
                                }
                              },
                                  renderedDataList: e['product_attribute']
                                      ['product_attribute_values'],
                                  isMultiSelect: (e['product_attribute']?['count_values'] ?? 0) > 1);
                            },
                          ).toList(),
                        ),

                        //////////////////////
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: buildSpacer(
                            width: width,
                            color: greyColor[400],
                            height: 5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: buildTextContent("Thông tin bán hàng", true,
                              fontSize: 20, isCenterLeft: false),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: _buildClassifyWidget(
                            context,
                            "Phân loại",
                          ),
                        ),
                        _buildGeneralInputWidget(),

                        //////////////////////
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: buildSpacer(
                            width: width,
                            color: greyColor[400],
                            height: 5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: buildTextContent("Thông tin vận chuyển", true,
                              fontSize: 20, isCenterLeft: false),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              buildTextContent(
                                  "Cân nặng (sau khi đóng gói, tính theo gram)",
                                  false,
                                  fontSize: 13),
                              buildSpacer(height: 5),
                              _buildInformationInput(
                                  _weightController, width, "Nhập cân nặng",
                                  maxLength: 12,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  keyboardType: TextInputType.number),
                              buildTextContent(
                                  "Kích thước đóng gói (sau khi đóng gói, tính theo cm)",
                                  false,
                                  fontSize: 13),
                              buildSpacer(height: 5),
                              _buildInformationInput(_sizeHeightController,
                                  width, "Nhập chiều cao",
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
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: buildSpacer(
                            width: width,
                            color: greyColor[400],
                            height: 5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: buildTextContent("Thông tin khác", true,
                              fontSize: 20, isCenterLeft: false),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
      if (_bottomFormKey.currentState!.validate()
          //  &&
          //     _categoryData!["loai_1"]["images"].every((element) {
          //       return element != "";
          //     })
          ) {
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
                                                                fontSize: 13,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis)),
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
      _previewClassifyValues = [];
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

  Future<dynamic> _callChildCategory(dynamic id, params) async {
    final response =
        await CategoryProductApis().getChildCategoryProductApi(id, params);
    return response;
  }

  Future<void> validateForCreate() async {
    _validatorSelectionList["category"] = true;
    _validatorSelectionList["branch"] = true;
    _validatorSelectionList["image"] = true;
    _validatorSelectionList["page"] = true;
    _validatorSelectionList['weight'] = true;
    _validatorSelectionList['description'] = true;
    if (_listCategoriesSelectedValue.any((element) => element.isEmpty)) {
      _validatorSelectionList["category"] = false;
    }
    if (_branchSelectedValue == null) {
      _validatorSelectionList["branch"] = false;
    }
    if (_selectedPage == null || _selectedPage.isEmpty) {
      _validatorSelectionList["page"] = false;
    }
    if (_imgFiles.isEmpty) {
      _validatorSelectionList["image"] = false;
    }
    if (_weightController.text.trim().isEmpty) {
      _validatorSelectionList['weight'] = false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _validatorSelectionList['description'] = false;
    }
    if (_formKey.currentState!.validate() &&
        _validatorSelectionList["branch"] == true &&
        _validatorSelectionList["category"] == true &&
        _validatorSelectionList["image"] == true &&
        _validatorSelectionList["page"] == true &&
        _validatorSelectionList["weight"] == true &&
        _validatorSelectionList['description'] == true) {
      _questionForCreateProduct();
    }
    setState(() {});
  }

  Future _setDataForCreate() async {
    setState(() {
      _isLoading = true;
    });
    List productImages = await uploadMedia(_imgFiles);
    newData["product_images"] = productImages;
    // them vao product_video
    if (_videoFiles.isNotEmpty) {
      List productVideos = await uploadMedia(_videoFiles);
      newData["product_video"] = productVideos[0];
    }
    // them vao product
    newData["product"]["title"] = _nameController.text.trim();
    newData["product"]["description"] = _descriptionController.text.trim();
    newData["product"]["product_category_id"] =
        _listCategoriesSelectedValue.last['id'];
    newData["product"]["brand_id"] = _branchSelectedValue['id'];
    newData["product"]["visibility"] = "public";
    newData["product"]["page_id"] = _selectedPage["id"];

    newData["product"]["weight_package"] = _weightController.text.trim();
    newData["product"]["length_package"] = _sizeLengthController.text.trim();
    newData["product"]["width_package"] = _sizeWidthController.text.trim();
    newData["product"]["height_package"] = _sizeHeightController.text.trim();

    newData["product"]["pre_order"] =
        _preOderSelectedValue['text'] == preOderSelections[0]['text']
            ? false
            : true;
    newData["product"]["condition"] = _statusProductSelectedValue['text'] ==
            statusProductSelections[0]['text']
        ? "new_product"
        : "used_product";
    newData["product"]["days_to_ship"] =
        _preOderSelectedValue['text'] == preOderSelections[0]['text']
            ? 2
            : _preOrderTimeSelectedValue;
    newData['product_attribute_informations_attributes'] =
        _listDetailInforSelectedValue;
    // _listDetailInforData
    //     .map(
    //       (e) => {
    //         "product_attribute_id": int.parse(e['product_attribute']['id']),
    //         "name": e['product_attribute']['name'],
    //         "value": _listDetailInforSelectedValue[
    //                 _listDetailInforData.indexOf(e)]
    //             .map((ele) {
    //           return ele['value'];
    //         }).toList(),
    //         "unit": ""
    //       },
    //     )
    //     .toList();
    // them vao product_options_attributes
    if (_previewClassifyValues[0] != "") {
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
    if (_previewClassifyValues[0] != "") {
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
        "inventory_quantity": 100
        // int.parse(_repositoryController.text.trim())
        ,
        "old_inventory_quantity": 100
        //  int.parse(_repositoryController.text.trim())
        ,
        "requires_shipping": true
      });
    }
    await ref.read(productsProvider.notifier).createProduct(newData);
    await ProductsApi().getProductsApi({
      "limit": 12,
      "visibility": "public",
    });
    buildMessageDialog(context, "Tạo sản phẩm thành công !!", oneButton: true);
    Future.delayed(const Duration(seconds: 1), () {
      popToPreviousScreen(context);
      pushAndReplaceToNextScreen(context, const ManageProductMarketPage());
    });

    setState(() {
      _isLoading = false;
      newData = {};
    });
  }

  // start table
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

  DataTable _buildOneDataTable() {
    List<DataColumn> dataColumns = [];
    List<DataRow> dataRows = [];

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

  // end table

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
                      popToPreviousScreen(context);
                      getInformationImage(ImageSource.camera, index,
                          function: function);
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

  Future<void> requestPermissionAndPickImage(ImageSource src) async {
    if (src == ImageSource.camera) {
      final XFile? pickedImage = await ImagePicker().pickImage(source: src);
      if (pickedImage != null) {
        setState(() {
          _imgFiles.add(File(pickedImage.path));
        });
      }
    } else if (src == ImageSource.gallery) {
      getImageFromGallery();
    }
  }

  Future<void> getImageFromGallery() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      List<Asset?> pickedImages = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
      );
      if (pickedImages.isNotEmpty) {
        setState(() {
          for (var element in pickedImages) {
            _imgFiles.add(File(element!.name!));
          }
        });
      } else {
        // Xử lý khi người dùng không chọn ảnh"
      }
    } else {
      // Xử lý khi người dùng từ chối quyền truy cập ảnh và thư viện"
    }
  }

  Future getVideo(ImageSource src) async {
    final XFile? pickedVideo = await ImagePicker().pickVideo(source: src);
    if (pickedVideo != null && pickedVideo.path.isNotEmpty) {
      setState(() {
        _videoFiles.add(File(pickedVideo.path));
      });
    }
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
              ? iconAndAddImage(
                  CreateProductMarketConstants
                      .CREATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER, function: () {
                  dialogMediaSource(context, requestPermissionAndPickImage);
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
                                  deleteOrFixIcon(Icons.close, function: () {
                                    _imgFiles.remove(_imgFiles[index]);
                                    setState(() {});
                                  }),
                                  deleteOrFixIcon(Icons.wifi_protected_setup,
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
                          child: iconAndAddImage(
                              CreateProductMarketConstants
                                  .CREATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER,
                              function: () {
                            dialogMediaSource(
                                context, requestPermissionAndPickImage);
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
              ? iconAndAddImage("Thêm video", function: () {
                  dialogMediaSource(context, getVideo);
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
                          child: iconAndAddImage("Thêm video", function: () {
                            dialogMediaSource(context, getVideo);
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
                                      child: deleteOrFixIcon(Icons.close,
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
                                                                  ? red
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
                                                                                        datas[subIndex]['has_children']
                                                                                            ? const Icon(
                                                                                                FontAwesomeIcons.chevronRight,
                                                                                                size: 20,
                                                                                              )
                                                                                            : const SizedBox()
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

  Widget _buildClassifyWidget(
    BuildContext context,
    String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 14),
              _categoryData!["loai_1"]["name"].text.trim() != ""
                  ? Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          buildTextContent(_previewClassifyValues[0], false,
                              fontSize: 17),
                          _previewClassifyValues[1] != ""
                              ? buildTextContent(
                                  _previewClassifyValues[1], false,
                                  fontSize: 17)
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
              if (controller.text.trim().isEmpty) {
                return "Trường này không được để trống";
              }
              return null;
            default:
              break;
          }
          // kiem tra validator cho cac phan khuc san pham
          if (_categoryData!["loai_1"]["name"].text.trim() != "") {
            if (hintText != "Nhập tồn kho" &&
                hintText != "Nhập mã sản phẩm" &&
                controller.text.trim().isEmpty) {
              return "Không hợp lệ";
            }
          } else {
            // if (controller.text.trim().isEmpty) {
            //   return "Không hợp lệ";
            // }
          }
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

  Widget _buildGeneralInputWidget({
    double? inputHeight,
    EdgeInsets? contentPadding,
    String? applyTitlte,
  }) {
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
}

Widget _buildWarningSelection(String warning) {
  return Column(
    children: [
      Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: buildTextContent(warning, false,
              fontSize: 12, colorWord: Colors.red[800])),
    ],
  );
}
