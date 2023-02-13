import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/screen/Login/widgets/build_elevateButton_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../helper/push_to_new_screen.dart';
import '../../../../theme/colors.dart';

class SaleInformationMarketPage extends StatefulWidget {
  @override
  State<SaleInformationMarketPage> createState() =>
      _SaleInformationMarketPageState();
}

class _SaleInformationMarketPageState extends State<SaleInformationMarketPage> {
  late double width = 0;
  late double height = 0;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _priceController = TextEditingController(text: "");
  TextEditingController _repositoryController = TextEditingController(text: "");
  TextEditingController _skuController = TextEditingController(text: "");

  Map<String, dynamic> _categoryData = {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    print("_categoryData: ${_categoryData["loai_1"]["images"]}");
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
                  if (validateInputs()) {
                    Navigator.pop(context);
                  }
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
          child: Form(
            key: _formKey,
            child: Expanded(
              child: ListView(children: [
                // sales information
                _buildContentForClassifyCategoryContents()
              ]),
            ),
          ),
        ));
  }

  _buildContentForClassifyCategoryContents() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
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
            SizedBox()
          ],
        ),
        Container(
          // height: 300,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              Column(
                children: [
                  buildSpacer(height: 10),
                  _buildInput(_categoryData["loai_1"]["name"], width,
                      "Nhập tên phân loại 1"),

                  // phan loai 1
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Wrap(
                      children: List.generate(
                          _categoryData["loai_1"]["values"].length,
                          (indexDescription) => Padding(
                                padding: EdgeInsets.only(
                                    right: indexDescription.isOdd ? 0 : 5,
                                    left: indexDescription.isEven ? 0 : 5),
                                child: _buildInput(
                                    _categoryData["loai_1"]["values"]
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
                  _categoryData["loai_1"]["values"].length != 10
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: buildTextContent(
                              "Thêm mô tả cho phân loại 1: ${_categoryData["loai_1"]["values"].length}/10",
                              false,
                              fontSize: 13, function: () {
                            _addClassifyCategoryOne();
                          }),
                        )
                      : SizedBox(),
                  _categoryData["loai_2"] == null ||
                          _categoryData["loai_2"] == {}
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: buildTextContent("Thêm nhóm phân loại", true,
                              fontSize: 16,
                              iconData: FontAwesomeIcons.add,
                              isCenterLeft: false, function: () {
                            _createClassifyCategoryTwo();
                          }),
                        )
                      : SizedBox(),

                  //loai 2
                  _categoryData["loai_2"] != null &&
                          _categoryData["loai_2"] != {}
                      ? Column(
                          children: [
                            buildSpacer(height: 10),
                            _buildInput(_categoryData["loai_2"]["name"], width,
                                "Nhập tên phân loại 2"),

                            ///
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Wrap(
                                children: List.generate(
                                    _categoryData["loai_2"]["values"].length,
                                    (indexDescription) => Padding(
                                          padding: EdgeInsets.only(
                                              right: indexDescription.isOdd
                                                  ? 0
                                                  : 5,
                                              left: indexDescription.isEven
                                                  ? 0
                                                  : 5),
                                          child: _buildInput(
                                              _categoryData["loai_2"]["values"]
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
                            _categoryData["loai_2"]["values"].length != 10
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: buildTextContent(
                                        "Thêm mô tả cho phân loại 2: ${_categoryData["loai_2"]["values"].length}/10",
                                        false,
                                        fontSize: 13, function: () {
                                      _addClassifyCategoryTwo();
                                    }),
                                  )
                                : SizedBox(),
                          ],
                        )
                      : SizedBox(),

                  buildSpacer(height: 10),
                  buildDivider(color: red),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        _buildInput(
                            _priceController, width, "Nhập giá sản phẩm",
                            keyboardType: TextInputType.number),
                        _buildInput(
                            _repositoryController, width, "Nhập tên kho hàng",
                            keyboardType: TextInputType.number),
                        _buildInput(_skuController, width, "Nhập mã sản phẩm"),
                        buildElevateButtonWidget(
                            title: "Áp dụng cho tất cả ",
                            function: () {
                              if (_priceController.text.length > 0 &&
                                  _repositoryController.text.length > 0 &&
                                  _skuController.text.length > 0) {
                                _applyPriceRepositorySkuForAll();
                              }
                            })
                      ],
                    ),
                  ),
                  // table
                  SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: _categoryData["loai_2"] == {} ||
                              _categoryData["loai_2"] == null
                          ? _buildDataTableWithOneComponent()
                          : _buildDataTableForTwoComponents()),
                ],
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  _addClassifyCategoryOne() {
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
        _categoryData["loai_2"]?["values"]?[i]["classify"]
            .add(TextEditingController(text: ""));
        _categoryData["loai_2"]?["values"]?[i]["sku"]
            .add(TextEditingController(text: ""));
      }
    }
    setState(() {});
  }

  _deleteClassifyCategoryOne(int index) {
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
    for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
      primaryData["values"][0]["price"].add(TextEditingController(text: ""));
      primaryData["values"][0]["classify"].add(TextEditingController(text: ""));
      primaryData["values"][0]["sku"].add(TextEditingController(text: ""));
    }

    _categoryData["loai_2"] = primaryData;
    setState(() {});
  }

  _addClassifyCategoryTwo() {
    // them cac the input vao loai 2
    List<dynamic> valuesCategory2 = _categoryData["loai_2"]["values"];
    Map<String, dynamic> primaryData = {
      "category_2_name": TextEditingController(text: ""),
      "price": [],
      "classify": [],
      "sku": []
    };

    for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
      primaryData["price"].add(TextEditingController(text: ""));
      primaryData["classify"].add(TextEditingController(text: ""));
      primaryData["sku"].add(TextEditingController(text: ""));
    }
    valuesCategory2.add(primaryData.cast<String, Object>());
    _categoryData["loai_2"]["values"] = valuesCategory2;
    setState(() {});
  }

  _deleteClassifyCategoryTwo(int index) {
    // xoa phan tu trong phan loai 2
    if (_categoryData["loai_2"]["values"].length > 1) {
      _categoryData["loai_2"]["values"].removeAt(index);
      setState(() {});
    }
  }

  _applyPriceRepositorySkuForAll() {
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
          _categoryData["loai_2"]["values"][z]["classify"][i].text =
              _repositoryController.text.trim();
          _categoryData["loai_2"]["values"][z]["sku"][i].text =
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
            _categoryData["loai_1"]["name"].text.length > 0
                ? _categoryData["loai_1"]["name"].text.trim()
                : "Phân loại hàng 1",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));
    dataColumns.add(
      DataColumn(
          label: Text('Giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      DataColumn(
          label: Text('Kho hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      DataColumn(
          label: Text('Mã(sku) phân loại',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );

    for (int i = 0; i < _categoryData["loai_1"]["values"].length; i++) {
      dataRows.add(DataRow(cells: [
        DataCell(
          Column(
            children: [
              buildSpacer(height: 10),
              buildTextContent(
                  _categoryData["loai_1"]["values"][i].text.trim(), true,
                  isCenterLeft: false, fontSize: 17),
              buildSpacer(height: 10),
              InkWell(
                onTap: () {
                  dialogImgSource(i);
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
                          MarketPlaceConstants.PATH_IMG + "cat_1.png"),
                ),
              )
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));

    dataColumns.add(DataColumn(
        label: Text(
            _categoryData["loai_2"]?["name"]?.text.length > 0
                ? _categoryData["loai_2"]["name"].text.trim()
                : "Phân loại hàng 2",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))));

    dataColumns.add(
      DataColumn(
          label: Text('Giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      DataColumn(
          label: Text('Kho hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      DataColumn(
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
                      buildSpacer(height: 10),
                      buildTextContent(
                          _categoryData["loai_1"]["values"][i].text.trim(),
                          true,
                          isCenterLeft: false,
                          fontSize: 17),
                      buildSpacer(height: 10),
                      InkWell(
                        onTap: () {
                          dialogImgSource(i);
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
                                  MarketPlaceConstants.PATH_IMG + "cat_1.png"),
                        ),
                      )
                    ],
                  ),
                )
              : DataCell(SizedBox()),
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
              _categoryData["loai_2"]?["values"][z]["classify"][i],
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

  Widget _buildInput(
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
              controller.text.trim().length <= 0) {
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

  bool validateInputs() {
    return _formKey.currentState!.validate();
  }

  Future getImage(ImageSource src, int index) async {
    XFile getImage = XFile("");
    getImage = (await ImagePicker().pickImage(source: src))!;
    _categoryData["loai_1"]["images"][index] =
        getImage.path != null && getImage.path != "" ? getImage.path : null;
    setState(() {});
  }

  dialogImgSource(int index) {
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
                      getImage(ImageSource.camera, index);
                      popToPreviousScreen(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Pick From Galery"),
                    onTap: () {
                      popToPreviousScreen(context);
                      getImage(ImageSource.gallery, index);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

//  CHU Y:
// Map<String, dynamic> _categoryData = {
//     "loai_1": {
//       "name": TextEditingController(text: "loai 1"),
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
