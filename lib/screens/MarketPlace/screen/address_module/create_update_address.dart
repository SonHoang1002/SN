import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/delivery_addresses_provider.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/apis/market_place_apis/delivery_address_apis.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

class AddressMarketPage extends ConsumerStatefulWidget {
  final dynamic oldData;
  const AddressMarketPage({super.key, this.oldData});

  @override
  ConsumerState<AddressMarketPage> createState() =>
      _DemoAddressMarketPageState();
}

List<String> setSelections = ["home", "send", "get"];
List addressCategoryList = [
  {"key": 'office', "title": "Văn phòng"},
  {"key": "home", "title": "Nhà Riêng"}
];
const String name = "Họ và tên";
const String phone = "Số điện thoại";
const String location = "Tên đường, Tòa nhà, Số nhà.";
const String province = "Tỉnh/Thành phố, Quận/Huyện, Phường/Xã";

class _DemoAddressMarketPageState extends ConsumerState<AddressMarketPage> {
  late double width = 0;
  late double height = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _phoneController =
      TextEditingController(text: "");
  dynamic _provinceValue;
  dynamic _addressValue;
  final TextEditingController _provinceController =
      TextEditingController(text: "");
  final TextEditingController _addressController =
      TextEditingController(text: "");

  dynamic _selectedCategory;
  dynamic _defaultAddress;
  bool? _isCreate;
  dynamic _mainData;
  String mainTitleUpper = "Tạo";
  String mainTitleLower = "tạo";
  List<dynamic> _warningSelection = [
    {"vali": true, "title": ""},
    {"vali": true, "title": ""},
  ];
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();
    Future.wait([_init()]);
  }

  @override
  void dispose() {
    super.dispose();
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
              const BackIconAppbar(),
              AppBarTitle(
                  text: _isCreate! ? "Địa chỉ mới" : "Cập nhật địa chỉ"),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        _buildOpenTitle("Liên hệ"),
                        _informationInput(
                          _nameController,
                          width,
                          name,
                        ),
                        _informationInput(_phoneController, width, phone,
                            keyboardType: TextInputType.number),
                        _buildOpenTitle("Địa chỉ"),
                        _selectionWidget(context, province, province,
                            suffixIcon: const Icon(
                              FontAwesomeIcons.chevronRight,
                              size: 14,
                            )),
                        _warningSelection[0]["vali"]
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: buildTextContent(
                                    _warningSelection[0]["title"].toString(),
                                    false,
                                    colorWord: red,
                                    maxLines: 2,
                                    fontSize: 11),
                              ),
                        _selectionWidget(
                          context,
                          location,
                          "Địa chỉ mới",
                        ),
                        _warningSelection[0]["vali"]
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: buildTextContent(
                                    _warningSelection[1]["title"].toString(),
                                    false,
                                    colorWord: red,
                                    maxLines: 2,
                                    fontSize: 11),
                              ),
                        _buildOpenTitle("Cài đặt"),
                        _selectionWidget(
                          context,
                          "Loại địa chỉ",
                          "Chọn địa chỉ",
                          suffixIcon: const Icon(
                            FontAwesomeIcons.caretDown,
                            size: 18,
                          ),
                        ),
                        _setAddressForTarget("Đặt làm địa chỉ mặc định"),
                      ]),
                    ],
                  ),
                ),
              ),
              buildMarketButton(
                  width: width,
                  height: 40,
                  bgColor: Colors.orange[300],
                  contents: [
                    buildTextContent(_isCreate! ? "Tạo" : "Cập nhật", false,
                        fontSize: 13)
                  ],
                  marginTop: 0,
                  radiusValue: 0,
                  isHaveBoder: false,
                  isVertical: true,
                  function: () {
                    _validate();
                  }),
            ],
          ),
        ));
  }

  Widget _buildOpenTitle(String title, {double? horizontal, double? vertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 10, vertical: vertical ?? 5),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTextContent(title, true, fontSize: 15, isCenterLeft: false)
        ],
      ),
    );
  }

  Future<int> _init() async {
    _isCreate = widget.oldData == null;

    if (!_isCreate!) {
      mainTitleUpper = "Cập nhật";
      mainTitleLower = "cập nhật";
      // update
      _defaultAddress ??= widget.oldData!["address_default"];
      _nameController.text = widget.oldData["name"];
      _phoneController.text = widget.oldData["phone_number"];
      _provinceValue = widget.oldData["addresses"];
      _addressValue = widget.oldData["detail_addresses"];
      if (_selectedCategory == null) {
        for (var element in addressCategoryList) {
          if (element["key"] == widget.oldData["address_type"]) {
            _selectedCategory = element;
          }
          _selectedCategory ??= {"key": "error", "title": "Lỗi dữ liệu"};
        }
      }
    } else {
      //create
      _selectedCategory ??= addressCategoryList[0];
      _defaultAddress ??= false;
    }
    setState(() {});
    return 0;
  }

  Future<dynamic> _createAddress() async {
    if (_isCreate!) {
      _mainData = {
        "name": _nameController.text.trim(),
        "phone_number": _phoneController.text.trim(),
        "addresses": _provinceValue,
        "detail_addresses": _addressValue,
        "address_type": _selectedCategory["key"],
        "address_default": _defaultAddress,
        "location": {"lat": 21.0, "lng": 105.8}
      };
    } else {
      _mainData = {
        "name": _nameController.text.trim(),
        "phone_number": _phoneController.text.trim(),
        "addresses": _provinceValue,
        "detail_addresses": _addressValue,
        "location": {"lat": 21.0, "lng": 105.8}
      };
    }
    var response;
    if (_isCreate!) {
      response = await DeliveryAddressApis().postDeliveryAddressApi(_mainData);
    } else {
      response = await DeliveryAddressApis()
          .updateDeliveryAddressApi(widget.oldData["id"], _mainData);
    }
    await ref.read(deliveryAddressProvider.notifier).getDeliveryAddressList();
    if (response != null) {
      if (response.isNotEmpty) {
        buildMessageDialog(
            context,
            _isCreate!
                ? "$mainTitleUpper thành công"
                : "$mainTitleUpper thành công",
            oneButton: true);
      } else {
        buildMessageDialog(context,
            "${_isCreate! ? "$mainTitleUpper không thành công" : "$mainTitleUpper không thành công"}",
            oneButton: true);
      }
    }
  }

  void _validate() {
    _warningSelection = [
      {"vali": true, "title": ""},
      {"vali": true, "title": ""},
    ];
    if (_provinceValue == null || _provinceValue == "") {
      _warningSelection[0]["vali"] = false;
      _warningSelection[0]["title"] =
          "Vui lòng thêm thông tin về Tỉnh/Thành phố,..";
    }
    if (_addressValue == null || _addressValue == "") {
      _warningSelection[1]["vali"] = false;
      _warningSelection[1]["title"] = "Vui lòng điền địa chỉ cụ thể";
    }
    if (_formKey.currentState!.validate() &&
        _provinceValue != null &&
        _addressValue != null) {
      buildMessageDialog(context, "Bạn chắc chắn muốn $mainTitleLower mới",
          oKFunction: () {
        popToPreviousScreen(context);
        _createAddress();
      });
    }
    setState(() {});
  }

  Widget _informationInput(
      TextEditingController controller, double width, String hintText,
      {IconData? prefixIconData,
      IconData? suffixIconData,
      TextInputType? keyboardType,
      double? height,
      EdgeInsets? contentPadding,
      bool? enabled,
      Function? additionalFunction,
      Function? suffixFunction}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: width,
      height: enabled == false ? 50 : height,
      decoration: enabled == false
          ? BoxDecoration(
              border: Border.all(color: blackColor, width: 0.4),
              borderRadius: BorderRadius.circular(5))
          : null,
      child: TextFormField(
        controller: controller,
        maxLines: null,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
        enabled: enabled ?? true,
        keyboardType: keyboardType ?? TextInputType.text,
        maxLength: keyboardType != null ? 10 : null,
        validator: (value) {
          if (controller.text.trim() == "") {
            String? warning;
            switch (hintText) {
              case name:
                warning = "Vui lòng nhập Họ tên";
                break;
              case phone:
                warning = "Vui lòng nhập Số điện thoại";
                break;
              default:
                break;
            }
            return warning;
          }
          if (hintText == phone) {
            if (controller.text.trim().length < 10) {
              return "Số điện thoại phải có 10 số";
            }
          }
        },
        onChanged: (value) {
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
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                )),
            hintText: hintText,
            labelText: hintText,
            border: enabled == false ? InputBorder.none : null,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
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

  Widget _selectionWidget(
      BuildContext context, String title, String titleForBottomSheet,
      {Icon? suffixIcon}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 12),
              title == province
                  ? _provinceValue != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: buildTextContent(
                              _provinceValue.toString(), true,
                              colorWord: greyColor, fontSize: 14),
                        )
                      : const SizedBox()
                  : title == location
                      ? _addressValue != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: buildTextContent(
                                  _addressValue.toString(), true,
                                  colorWord: greyColor, fontSize: 14),
                            )
                          : const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: buildTextContent(
                              _selectedCategory["title"].toString(), true,
                              colorWord: greyColor, fontSize: 14),
                        )
            ],
            suffixWidget: SizedBox(height: 40, width: 40, child: suffixIcon),
            changeBackground: transparent,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            isHaveBorder: true,
            function: () {
              switch (title) {
                case province:
                  _buildProviceBottomSheet(titleForBottomSheet);
                  break;
                case location:
                  _buildLocationBottomSheet(titleForBottomSheet);
                  break;
                default:
                  _buildCategoryBottomSheet(titleForBottomSheet);
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  dynamic _buildCategoryBottomSheet(String titleForBottomSheet) {
    showCustomBottomSheet(context, 160,
        title: titleForBottomSheet,
        widget: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: addressCategoryList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  index == 0
                      ? buildDivider(height: 2, color: red)
                      : const SizedBox(),
                  GeneralComponent(
                    [
                      buildTextContent(
                          addressCategoryList[index]["title"], false)
                    ],
                    changeBackground: transparent,
                    padding: const EdgeInsets.all(10),
                    isHaveBorder: false,
                    borderRadiusValue: 0,
                    function: () {
                      setState(() {
                        _selectedCategory = addressCategoryList[index];
                      });
                      popToPreviousScreen(context);
                    },
                  ),
                  buildDivider(height: 2, color: red)
                ],
              );
            }));
  }

  dynamic _buildProviceBottomSheet(String titleForBottomSheet) {
    showCustomBottomSheet(context, height - 50, title: titleForBottomSheet,
        widget: StatefulBuilder(builder: (context, setStatefull) {
      return Column(children: [
        buildTextContent(
            "Hiện tại chưa làm xong nên bạn hãy chịu khó nhập địa chỉ vào đây :))",
            true,
            fontSize: 12,
            colorWord: red),
        _informationInput(_provinceController, width, "Nhập tỉnh thành phố",
            additionalFunction: () {
          setStatefull(() {});
          setState(() {
            _provinceValue = _provinceController.text.trim();
            if (_provinceValue != null && _provinceValue != "") {
              _warningSelection[0]["vali"] = true;
            }
          });
        }),
      ]);
    }));
  }

  dynamic _buildLocationBottomSheet(String titleForBottomSheet) {
    showCustomBottomSheet(context, height - 50, title: titleForBottomSheet,
        widget: StatefulBuilder(builder: (context, setStatefull) {
      return Column(children: [
        buildTextContent(
            "Hiện tại chưa làm xong nên bạn hãy chịu khó nhập địa chỉ vào đây :))",
            true,
            fontSize: 12,
            colorWord: red),
        _informationInput(_addressController, width, "Nhập địa chỉ cụ thể",
            additionalFunction: () {
          setStatefull(() {});
          setState(() {
            _addressValue = _addressController.text.trim();
            if (_addressValue != null && _addressValue != "") {
              _warningSelection[1]["vali"] = true;
            }
          });
        }),
      ]);
    }));
  }

  Widget _setAddressForTarget(
    String title,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: greyColor, width: 0.6),
          borderRadius: BorderRadius.circular(7)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        buildTextContent(title, true, fontSize: 13, colorWord: greyColor),
        Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
                value: _defaultAddress,
                onChanged: (value) {
                  setState(() {
                    _defaultAddress = value;
                  });
                }))
      ]),
    );
  }
}
