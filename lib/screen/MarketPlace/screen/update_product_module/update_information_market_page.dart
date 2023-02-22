import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/data/market_place_datas/suggest_products_data.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/update_product_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../helper/push_to_new_screen.dart';
import '../../../../theme/colors.dart';

class UpdateInformationMarketPage extends ConsumerStatefulWidget {
  dynamic data;
  UpdateInformationMarketPage({super.key, this.data});
  @override
  ConsumerState<UpdateInformationMarketPage> createState() =>
      _UpdateInformationMarketPageState();
}

class _UpdateInformationMarketPageState
    extends ConsumerState<UpdateInformationMarketPage> {
  late double width = 0;
  late double height = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _priceController =
      TextEditingController(text: "");
  final TextEditingController _repositoryController =
      TextEditingController(text: "");
  final TextEditingController _skuController = TextEditingController(text: "");

  Map<String, dynamic>? _categoryData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              InkWell(
                onTap: () {
                  popToPreviousScreen(context);
                },
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Theme.of(context).textTheme.displayLarge!.color,
                ),
              ),
              const AppBarTitle(title: "Thông tin bán hàng"),
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
                        // sales information
                        _buildContentForClassifyCategoryContents()
                        // Container(color: red,)
                      ]),
                    ),
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
                            title: "Lưu",
                            function: () async {
                              if (validateInformationInputs()) {
                                List list = await Future.wait(
                                  [_setInformationData()],
                                );
                                if (list.isNotEmpty && mounted) {
                                  popToPreviousScreen(context);
                                }
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? const Center(
                      child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: red,
                      ),
                    ))
                  : const SizedBox(),
            ],
          ),
        ));
  }

  _buildContentForClassifyCategoryContents() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        // classify category
        buildSpacer(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: buildTextContent("Phân loại hàng", true, fontSize: 16),
            ),
            const SizedBox()
          ],
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            Column(
              children: [
                buildSpacer(height: 10),
                _buildInformationInput(_categoryData?["loai_1"]["name"], width,
                    "Nhập tên phân loại 1"),

                // phan loai 1
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Wrap(
                    children: List.generate(
                        _categoryData?["loai_1"]["values"].length,
                        (indexDescription) => Padding(
                              padding: EdgeInsets.only(
                                  right: indexDescription.isOdd ? 0 : 5,
                                  left: indexDescription.isEven ? 0 : 5),
                              child: _buildInformationInput(
                                  _categoryData?["loai_1"]["values"]
                                      [indexDescription],
                                  width * 0.48,
                                  "Màu sắc ${indexDescription + 1}",
                                  suffixIconData: FontAwesomeIcons.close,
                                  suffixFunction: () {
                                _deleteClassifyCategoryOne(indexDescription);
                              }),
                            )),
                  ),
                ),
                _categoryData?["loai_1"]["values"].length != 10
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: buildTextContent(
                            "Thêm mô tả cho phân loại 1: ${_categoryData?["loai_1"]["values"].length}/10",
                            false,
                            fontSize: 13, function: () {
                          _addClassifyCategoryOne();
                        }),
                      )
                    : const SizedBox(),
                _categoryData?["loai_2"] == null ||
                        _categoryData?["loai_2"] == {}
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: buildTextContent("Thêm nhóm phân loại", true,
                            fontSize: 16,
                            iconData: FontAwesomeIcons.add,
                            isCenterLeft: false, function: () {
                          _createClassifyCategoryTwo();
                        }),
                      )
                    : const SizedBox(),

                //loai 2
                _categoryData?["loai_2"] != null &&
                        _categoryData?["loai_2"] != {}
                    ? Column(
                        children: [
                          buildSpacer(height: 10),
                          _buildInformationInput(_categoryData?["loai_2"]["name"], width,
                              "Nhập tên phân loại 2"),

                          ///
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            child: Wrap(
                              children: List.generate(
                                  _categoryData?["loai_2"]["values"].length,
                                  (indexDescription) => Padding(
                                        padding: EdgeInsets.only(
                                            right: indexDescription.isOdd
                                                ? 0
                                                : 5,
                                            left: indexDescription.isEven
                                                ? 0
                                                : 5),
                                        child: _buildInformationInput(
                                            _categoryData?["loai_2"]["values"]
                                                    [indexDescription]
                                                ["category_2_name"],
                                            width * 0.48,
                                            "Kích thước ${indexDescription + 1}",
                                            suffixIconData: FontAwesomeIcons
                                                .close, suffixFunction: () {
                                          _deleteClassifyCategoryTwo(
                                              indexDescription);
                                        }),
                                      )),
                            ),
                          ),
                          _categoryData?["loai_2"]["values"].length != 10
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: buildTextContent(
                                      "Thêm mô tả cho phân loại 2: ${_categoryData?["loai_2"]["values"].length}/10",
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
                      _buildInformationInput(_skuController, width, "Nhập mã sản phẩm"),
                      buildButtonForMarketWidget(
                          title: "Áp dụng cho tất cả ",
                          function: () {
                            if (_priceController.text.isNotEmpty &&
                                _repositoryController.text.isNotEmpty &&
                                _skuController.text.isNotEmpty) {
                              _applyPriceRepositorySkuForAll();
                            }
                          })
                    ],
                  ),
                ),
                // table
                SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: _categoryData?["loai_2"] == {} ||
                            _categoryData?["loai_2"] == null
                        ? _buildDataTableWithOneComponent()
                        : _buildDataTableForTwoComponents()),
              ],
            ),
          ]),
        ),
      ]),
    );
  }

  _addClassifyCategoryOne() {
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

    if (_categoryData?["loai_2"] != {} && _categoryData?["loai_2"] != null) {
      for (int i = 0; i < _categoryData?["loai_2"]?["values"]?.length; i++) {
        _categoryData?["loai_2"]?["values"]?[i]["price"]
            .add(TextEditingController(text: ""));
        _categoryData?["loai_2"]?["values"]?[i]["classify"]
            .add(TextEditingController(text: ""));
        _categoryData?["loai_2"]?["values"]?[i]["sku"]
            .add(TextEditingController(text: ""));
      }
    }
    setState(() {});
  }

  _deleteClassifyCategoryOne(int index) {
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
          _categoryData?["loai_2"]["values"][i]["classify"].removeAt(index);
          _categoryData?["loai_2"]["values"][i]["sku"].removeAt(index);
        }
      }
    }

    setState(() {});
  }

  _createClassifyCategoryTwo() {
    Map<String, dynamic> primaryData = {
      "name": TextEditingController(text: ""),
      "values": [
        {
          "category_2_name": TextEditingController(text: ""),
          "price": [],
          "classify": [],
          "sku": []
        },
      ]
    };
    for (int i = 0; i < _categoryData?["loai_1"]["values"].length; i++) {
      primaryData["values"][0]["price"].add(TextEditingController(text: ""));
      primaryData["values"][0]["classify"].add(TextEditingController(text: ""));
      primaryData["values"][0]["sku"].add(TextEditingController(text: ""));
    }

    _categoryData?["loai_2"] = primaryData;
    setState(() {});
  }

  _addClassifyCategoryTwo() {
    // them cac the input vao loai 2
    List<dynamic> valuesCategory2 = _categoryData?["loai_2"]["values"];
    Map<String, dynamic> primaryData = {
      "category_2_name": TextEditingController(text: ""),
      "price": [],
      "classify": [],
      "sku": []
    };

    for (int i = 0; i < _categoryData?["loai_1"]["values"].length; i++) {
      primaryData["price"].add(TextEditingController(text: ""));
      primaryData["classify"].add(TextEditingController(text: ""));
      primaryData["sku"].add(TextEditingController(text: ""));
    }
    valuesCategory2.add(primaryData.cast<String, Object>());
    _categoryData?["loai_2"]["values"] = valuesCategory2;
    setState(() {});
  }

  _deleteClassifyCategoryTwo(int index) {
    // xoa phan tu trong phan loai 2
    if (_categoryData?["loai_2"]["values"].length > 1) {
      _categoryData?["loai_2"]["values"].removeAt(index);
      setState(() {});
    }
  }

  _applyPriceRepositorySkuForAll() {
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
          _categoryData?["loai_2"]["values"][z]["classify"][i].text =
              _repositoryController.text.trim();
          _categoryData?["loai_2"]["values"][z]["sku"][i].text =
              _skuController.text.trim();
        }
      }
    }
    setState(() {});
  }

  DataTable _buildDataTableWithOneComponent() {
    List<DataColumn> dataColumns = [];
    List<DataRow> dataRows = [];
    List<DataCell> dataCells = [];

    // phân loại hàng
    dataColumns.add(DataColumn(
        label: Text(
            _categoryData?["loai_1"]["name"].text.length > 0
                ? _categoryData!["loai_1"]["name"].text.trim()
                : "Phân loại hàng 1",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));
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

    for (int i = 0; i < _categoryData?["loai_1"]["values"].length; i++) {
      dataRows.add(DataRow(cells: [
        DataCell(
          Column(
            children: [
              buildSpacer(height: 10),
              buildTextContent(
                  _categoryData?["loai_1"]["values"][i].text.trim(), true,
                  isCenterLeft: false, fontSize: 17),
              buildSpacer(height: 10),
              InkWell(
                onTap: () {
                  dialogInformationImgSource(i);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: greyColor, width: 0.4)),
                  child: _categoryData?["loai_1"]["images"][i] != "" &&
                          _categoryData?["loai_1"]["images"][i] != null
                      ? _categoryData!["loai_1"]["images"][i] is File
                          ? Image.file(
                              _categoryData?["loai_1"]["images"][i],
                              fit: BoxFit.fitHeight,
                            )
                          : ImageCacheRender(
                              path: _categoryData?["loai_1"]["images"][i],
                              height: 50.0,
                              width: 50.0,
                            )
                      : Image.asset(
                          MarketPlaceConstants.PATH_IMG + "cat_1.png"),
                ),
              )
            ],
          ),
        ),
        DataCell(_buildInformationInput(_categoryData?["loai_1"]["contents"]["price"][i],
            width * 0.5, "Gia",
            keyboardType: TextInputType.number)),
        DataCell(_buildInformationInput(
            _categoryData?["loai_1"]["contents"]["repository"][i],
            width * 0.5,
            "Kho hang",
            keyboardType: TextInputType.number)),
        DataCell(_buildInformationInput(_categoryData?["loai_1"]["contents"]["sku"][i],
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
            _categoryData?["loai_1"]["name"].text.length > 0
                ? _categoryData!["loai_1"]["name"].text.trim()
                : "Phân loại hàng 1",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));

    dataColumns.add(DataColumn(
        label: Text(
            _categoryData?["loai_2"]?["name"]?.text.length > 0
                ? _categoryData!["loai_2"]["name"].text.trim()
                : "Phân loại hàng 2",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));

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
    for (int i = 0; i < _categoryData?["loai_1"]["values"].length; i++) {
      for (int z = 0; z < _categoryData?["loai_2"]?["values"]?.length; z++) {
        dataRows.add(DataRow(cells: [
          z == 0
              ? DataCell(
                  Column(
                    children: [
                      buildSpacer(height: 10),
                      buildTextContent(
                          _categoryData?["loai_1"]["values"][i].text.trim(),
                          true,
                          isCenterLeft: false,
                          fontSize: 17),
                      buildSpacer(height: 10),
                      InkWell(
                        onTap: () {
                          dialogInformationImgSource(i);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: greyColor, width: 0.4)),
                          child: _categoryData?["loai_1"]["images"][i] != "" &&
                                  _categoryData?["loai_1"]["images"][i] != null
                              ? _categoryData!["loai_1"]["images"][i] is File
                                  ? Image.file(
                                      _categoryData?["loai_1"]["images"][i],
                                      fit: BoxFit.fitHeight,
                                    )
                                  : ImageCacheRender(
                                      path: _categoryData?["loai_1"]["images"]
                                          [i],
                                      height: 50.0,
                                      width: 50.0,
                                    )
                              : Image.asset(
                                  MarketPlaceConstants.PATH_IMG + "cat_1.png"),
                        ),
                      )
                    ],
                  ),
                )
              : const DataCell(SizedBox()),
          DataCell(
            buildTextContent(
                _categoryData?["loai_2"]?["values"][z]["category_2_name"]
                    .text
                    .trim(),
                true,
                isCenterLeft: false,
                fontSize: 17),
          ),
          DataCell(_buildInformationInput(
              _categoryData?["loai_2"]?["values"][z]["price"][i],
              width * 0.5,
              "Giá",
              keyboardType: TextInputType.number)),
          DataCell(_buildInformationInput(
              _categoryData?["loai_2"]?["values"][z]["classify"][i],
              width * 0.5,
              "Kho hàng",
              keyboardType: TextInputType.number)),
          DataCell(_buildInformationInput(_categoryData?["loai_2"]?["values"][z]["sku"][i],
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
      // height: height ?? 50,
      child: TextFormField(
        controller: controller,
        maxLines: null,
        keyboardType: keyboardType != null ? keyboardType : TextInputType.text,
        validator: (value) {
          if (hintText != "Nhập giá sản phẩm" &&
              hintText != "Nhập tên kho hàng" &&
              hintText != "Nhập mã sản phẩm" &&
              controller.text.trim().isEmpty) {
            return "Không hợp lệ";
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

  bool validateInformationInputs() {
    return _formKey.currentState!.validate();
  }

  Future<int> _setInformationData() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> newUpdateData = ref.watch(updateProductProvider).data;

    // set product_options_attributes
    // reset list
    newUpdateData["product_options_attributes"] = [];
    newUpdateData["product_variants_attributes"] = [];
    // add loai_1
    Map<String, dynamic> loai_1 = {
      "name": _categoryData?["loai_1"]["name"].text.trim(),
      "position": 1,
      "values":
          _categoryData?["loai_1"]["values"].map((e) => e.text.trim()).toList()
    };
    newUpdateData["product_options_attributes"].add(loai_1);

    // add loai_2 (neu co)
    if (_categoryData?["loai_2"] != null) {
      Map<String, dynamic> loai_2 = {
        "name": _categoryData?["loai_2"]["name"].text.trim(),
        "position": 2,
        "values": _categoryData?["loai_2"]["values"]
            .map((e) => e["category_2_name"].text.trim())
            .toList()
      };
      newUpdateData["product_options_attributes"].add(loai_2);
    }

    // set product_variants_attributes
    if (_categoryData?["loai_2"] == null) {
      List<String> imgList = _categoryData?["loai_1"]["images"].toList();
      List<String> imageIdList = await Future.wait(imgList.map((element) async {
        String fileName = element.split('/').last;
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(element, filename: fileName),
        });
        final response = await MediaApi().uploadMediaEmso(formData);
        return response["id"].toString();
      }).toList());
      for (int i = 0;
          i < newUpdateData["product_options_attributes"][0]["values"].length;
          i++) {
        newUpdateData["product_variants_attributes"].add({
          "title":
              "${newUpdateData["product"]["title"]} - ${newUpdateData["product_options_attributes"][0]["values"][i]}",
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
          "option1": newUpdateData["product_options_attributes"][0]["values"]
              [i],
          "option2": null,
          "image_id": imageIdList[i],
          "weight": 0.25,
          "weight_unit": "Kg",
          "inventory_quantity": 100,
          "old_inventory_quantity": 100,
        });
      }
    } else {
      for (int i = 0; i < _categoryData?["loai_1"]["values"].length; i++) {
        for (int z = 0; z < _categoryData?["loai_2"]["values"].length; z++) {
          newUpdateData["product_variants_attributes"].add({
            "title":
                "${newUpdateData["product"]["title"]} -${_categoryData?["loai_1"]["values"][i].text.trim()} - ${_categoryData?["loai_2"]["values"][z]["category_2_name"].text.trim()}",
            "price": _categoryData?["loai_2"]["values"][z]["price"][i]
                .text
                .trim()
                .toString(),
            "sku": _categoryData?["loai_2"]["values"][z]["sku"][i]
                .text
                .trim()
                .toString(),
            "position": 2,
            "compare_at_price": null,
            "option1": _categoryData?["loai_1"]["values"][i].text.trim(),
            "option2": _categoryData?["loai_2"]["values"][z]["category_2_name"]
                .text
                .trim(),
            // "image_id": imageIdList[i],
            "weight": 0.25,
            "weight_unit": "Kg",
            "inventory_quantity": 100,
            "old_inventory_quantity": 100,
            "requires_shipping": true
          });
        }
      }
    }

    ref.read(updateProductProvider.notifier).updateProductData(newUpdateData);
    print(
        "update updateProductProvider :  ${ref.watch(updateProductProvider).data}");
    setState(() {
      _isLoading = false;
    });
    return 0;
  }

  Future getInformationImage(ImageSource src, int index) async {
    XFile getImage = XFile("");
    getImage = (await ImagePicker().pickImage(source: src))!;
    _categoryData?["loai_1"]["images"][index] =
        getImage.path != null && getImage.path != "" ? getImage.path : null;
    setState(() {});
  }

  dialogInformationImgSource(int index) {
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

  _initData() {
    // if (widget.data != null &&
    //     widget.data["product_options_attributes"].isNotEmpty &&
    //     widget.data["product_variants_attributes"].isNotEmpty) {
    //khoi tao voi noi dung co ban
    final Map<String, dynamic> data;
    // final updateDataFromProvider = ref.watch(updateProductProvider).data;
    // final abc = Provider
    // if (updateDataFromProvider["product_variants_attributes"] != null &&
    //     updateDataFromProvider["product_variants_attributes"].isNotEmpty &&
    //     updateDataFromProvider["product_options_attributes"] != null &&
    //     updateDataFromProvider["product_options_attributes"].isNotEmpty) {
    if (widget.data != null) {
      data = widget.data;
    }
    else{
      data = suggestData[0];
    }
    // } else {
    //   data = updateDataFromProvider;
    // }

    _categoryData = {
      "loai_1": {
        "name": TextEditingController(
          text: data["product_variants_attributes"][0]["name"],
        ),
        "values":
            data["product_variants_attributes"][0]["values"].map((element) {
          return TextEditingController(text: element.toString());
        }).toList(),
        "images": data["product_options_attributes"].map((element) {
          return element["image"]["url"].toString();
        }).toList(),
        "contents": {"price": [], "repository": [], "sku": []}
      },
    };
    // khoi tao content loai 1 voi cac the input rong
    data["product_variants_attributes"][0]["values"].forEach((elementOfOne) {
      _categoryData!["loai_1"]["contents"]["price"]
          .add(TextEditingController(text: ""));
      _categoryData!["loai_1"]["contents"]["repository"]
          .add(TextEditingController(text: ""));
      _categoryData!["loai_1"]["contents"]["sku"]
          .add(TextEditingController(text: ""));
    });
    // khoi tao cac the input neu co loai 2
    if (data["product_variants_attributes"].length > 1) {
      _categoryData!["loai_2"] = {
        "name": TextEditingController(
          text: data["product_variants_attributes"][1]["name"],
        ),
        "values": []
      };
      List<Map<String, dynamic>> valuesOfLoai2 = [];
      for (int i = 0;
          i < data["product_variants_attributes"][1]["values"].length;
          i++) {
        valuesOfLoai2.add({
          "category_2_name": TextEditingController(
            text: data["product_variants_attributes"][1]["values"][i],
          ),
          "price": [],
          "classify": [],
          "sku": []
        });
      }
      List<Map<String, dynamic>> price_classify_sku_list = [];
      data["product_variants_attributes"][0]["values"].forEach((nameOfOne) {
        for (int indexOfTwo = 0;
            indexOfTwo <
                data["product_variants_attributes"][1]["values"].length;
            indexOfTwo++) {
          for (int i = 0; i < data["product_options_attributes"].length; i++) {
            if (data["product_options_attributes"][i]["option1"] == nameOfOne) {
              if (data["product_options_attributes"][i]["option2"] ==
                  data["product_variants_attributes"][1]["values"]
                      [indexOfTwo]) {
                price_classify_sku_list.add({
                  "name_1": data["product_options_attributes"][i]["option1"],
                  "name_2": data["product_options_attributes"][i]["option2"],
                  "price": data["product_options_attributes"][i]["price"],
                  "classify": 123,
                  "sku": data["product_options_attributes"][i]["sku"]
                });

                valuesOfLoai2[indexOfTwo]["price"].add(TextEditingController(
                    text: data["product_options_attributes"][i]["price"]
                        .toString()));
                valuesOfLoai2[indexOfTwo]["classify"].add(TextEditingController(
                    text:
                        // "${data["product_options_attributes"][i]["option1"]} - ${data["product_options_attributes"][i]["option2"]}"));
                        data["product_options_attributes"][i]
                                ["inventory_quantity"]
                            .toString()));
                valuesOfLoai2[indexOfTwo]["sku"].add(TextEditingController(
                    text: data["product_options_attributes"][i]["sku"]));
              }
            }
          }
        }
      });

      print("test market valuesOfLoai2: ${_categoryData!["loai_1"]["images"]}");
      _categoryData!["loai_2"]["values"] = valuesOfLoai2;
    } else {
      // gan gia tri cac the input cua loai neu khong co loai 2
      data["product_variants_attributes"][0]["values"].forEach((elementOfOne) {
        data["product_options_attributes"].forEach((valueOfOption1) {
          if (valueOfOption1["option1"] == elementOfOne) {
            _categoryData!["loai_1"]["contents"]["price"].add(
                TextEditingController(
                    text: valueOfOption1["price"].toString()));
            _categoryData!["loai_1"]["contents"]["repository"].add(
                TextEditingController(
                    text: valueOfOption1["inventory_quantity"].toString()));
            _categoryData!["loai_1"]["contents"]["sku"].add(
                TextEditingController(text: valueOfOption1["sku"].toString()));
          }
        });
      });
    }
  }

  // }
}

//  CHU Y:
// Map<String, dynamic> _categoryData = {
//     "loai_1": {
//       "name": TextEditingController(text: "loai 1"),
//       "images": [""],
//       "values": [
//         TextEditingController(text: "xanh"),
//         TextEditingController(text: "do"),
//         TextEditingController(text: "tim")
//       ],
//       "contents": {
//         "price": [
//           TextEditingController(text: "01"),
//           TextEditingController(text: "02"),
//           TextEditingController(text: "03")
//         ],
//         "repository": [
//           TextEditingController(text: "11"),
//           TextEditingController(text: "12"),
//           TextEditingController(text: "13")
//         ],
//         "sku": [
//           TextEditingController(text: "s1"),
//           TextEditingController(text: "s2"),
//           TextEditingController(text: "s3")
//         ],
//       },
//     },
// "loai_2": {
// "name": TextEditingController(text: ""),
// "values": [
// {
//   "category_2_name": TextEditingController(text: "x"),
//   "price": [
//     TextEditingController(text: ""),
//     TextEditingController(text: ""),
//     TextEditingController(text: ""),
//   ],
//   "classify": [
//     TextEditingController(text: ""),
//     TextEditingController(text: ""),
//     TextEditingController(text: ""),
//   ],
//   "sku": [
//     TextEditingController(text: ""),
//     TextEditingController(text: ""),
//     TextEditingController(text: ""),
//   ]
// },
//   {
//     "category_2_name": TextEditingController(text: "l"),
//     "price": [
//       TextEditingController(text: ""),
//       TextEditingController(text: ""),
//       TextEditingController(text: ""),
//     ],
//     "classify": [
//       TextEditingController(text: ""),
//       TextEditingController(text: ""),
//       TextEditingController(text: ""),
//     ],
//     "sku": [
//       TextEditingController(text: ""),
//       TextEditingController(text: ""),
//       TextEditingController(text: ""),
//     ]
//   },
// ]
// }
// };
//     //   dong 1 : xanh      - x                             - 12000                             - 123                               - s1
//     //   dong 1 : colors[0] - description_category[0][main] - description_category[0][price][0] - description_category[0][class][0] - description_category[0][sku][0]
//     //   dong 2 : xanh      - l - 4000 - 848 - s11
//     //   dong 2 : colors[0] - description_category[1][main] - description_category[1][price][0] - description_category[1][class][0]  - description_category[1][sku][0]
//     //  dong 3  : do-x-20000-213-s2
//     //  dong 3 : colors[1] - description_category[0][main] - description_category[0][price][1] - description_category[0][class][1] - description_category[0][sku][1]
//     //  dong 3  : do-l-30000-423-s21
//     //  dong 3 : colors[1] - description_category[1][main] - description_category[1][price][1] - description_category[1][class][1] - description_category[1][sku][1]
