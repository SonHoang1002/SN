import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/constant/marketPlace_constants.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/delivery_addresses_provider.dart';
import 'package:market_place/providers/market_place_providers/repo_variables/order_data_saver.dart';
import 'package:market_place/screens/MarketPlace/screen/address_module/create_update_address.dart';
import 'package:market_place/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

import '../../../../theme/colors.dart';

class ChooseAddressPage extends ConsumerStatefulWidget {
  const ChooseAddressPage({super.key});

  @override
  ConsumerState<ChooseAddressPage> createState() => _ChooseAddressPageState();
}

class _ChooseAddressPageState extends ConsumerState<ChooseAddressPage> {
  late double width = 0;
  late double height = 0;
  bool _isLoading = true;
  List<dynamic>? _addressList;
  List<String>? idList = [];
  String? selectedId;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (ref.watch(deliveryAddressProvider).addressList.isEmpty) {
        final addressData = await ref
            .read(deliveryAddressProvider.notifier)
            .getDeliveryAddressList();
      }
    });
  }

  Future _initData() async {
    _addressList = ref.watch(deliveryAddressProvider).addressList;
    final currentSelectedAddress =
        ref.watch(selectedAddressSaverProvider).selectedAddressSaver;
    if (_addressList!.isNotEmpty) {
      for (int i = 0; i < _addressList!.length; i++) {
        idList!.add(_addressList![i]["id"]);
      }
      if (currentSelectedAddress.isNotEmpty) {
        idList!.forEach((element) {
          if (element == currentSelectedAddress["id"]) {
            selectedId ??= idList![idList!.indexOf(element)];
          }
        });
      } else {
        selectedId ??= idList![0];
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future _updateSelectedData() async {
    await ref
        .watch(selectedAddressSaverProvider.notifier)
        .updateSelectedAddressSaver(newAddress: _addressList![selectedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    Future.wait([_initData()]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  await _updateSelectedData();
                  popToPreviousScreen(context);
                },
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Theme.of(context).textTheme.displayLarge!.color,
                ),
              ),
              const AppBarTitle(text: "Địa chỉ của bạn"),
              GestureDetector(
                onTap: () async {
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
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  _isLoading
                      ? buildCircularProgressIndicator()
                      : Column(
                          children:
                              List.generate(_addressList!.length, (index) {
                          return addressItem(_addressList![index], index);
                        })),
                  buildSpacer(height: 10),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Container(
                  color: white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // margin:
                  //     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: width,
                  child: _buildSelectedWidget("Thêm mới địa chỉ", function: () {
                    pushToNextScreen(context, const AddressMarketPage());
                  }),
                ),
              ],
            )
          ],
        ));
  }

  Widget addressItem(dynamic data, dynamic index) {
    return Column(
      children: [
        GeneralComponent(
          [
            Row(
              children: [
                buildTextContent(data["name"], true, fontSize: 14),
                buildSpacer(width: 10),
                buildTextContent("|", false, fontSize: 14),
                buildSpacer(width: 10),
                buildTextContent(data["phone_number"].toString(), false,
                    fontSize: 14),
              ],
            )
          ],
          prefixWidget: Container(
              margin: const EdgeInsets.only(right: 5),
              height: 30,
              width: 30,
              child: Radio(
                  value: idList![index],
                  groupValue: selectedId,
                  onChanged: (value) async {
                    setState(() {
                      selectedId = value;
                      selectedIndex = index;
                    });
                    await _updateSelectedData();
                  })),
          suffixWidget: GestureDetector(
              onTap: () {
                pushToNextScreen(
                    context,
                    AddressMarketPage(
                      oldData: data,
                    ));
              },
              child:
                  buildTextContent("Sửa", false, colorWord: red, fontSize: 16)),
          isHaveBorder: false,
          borderRadiusValue: 0,
          changeBackground: transparent,
          padding: const EdgeInsets.only(left: 10),
        ),
        buildSpacer(height: 7),
        GeneralComponent(
          [
            buildTextContent(data["detail_addresses"].toString(), false,
                fontSize: 13),
            buildSpacer(height: 7),
            buildTextContent(data["addresses"].toString(), false, fontSize: 13),
          ],
          prefixWidget: const Padding(
            padding: EdgeInsets.only(right: 15),
            child: SizedBox(),
          ),
          isHaveBorder: false,
          borderRadiusValue: 0,
          changeBackground: transparent,
          padding: const EdgeInsets.only(left: 15),
        ),
        buildSpacer(height: 7),
        selectedId == idList![index]
            ? GeneralComponent(
                [
                  Row(
                    children: [
                      _buildSelectedWidget(
                        "Mặc định",
                      ),
                      buildSpacer(width: 7),
                      _buildSelectedWidget("Địa chỉ lấy hàng",
                          textColor: greyColor, color: greyColor),
                    ],
                  ),
                ],
                prefixWidget: const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: SizedBox(),
                ),
                isHaveBorder: false,
                borderRadiusValue: 0,
                changeBackground: transparent,
                padding: const EdgeInsets.only(left: 15),
              )
            : const SizedBox(),
        buildSpacer(height: 15),
        buildDivider(height: 1, color: greyColor, left: 65)
      ],
    );
  }

  Widget _buildSelectedWidget(String title,
      {Color? textColor, Color? color, Function? function}) {
    return InkWell(
      onTap: () {
        function != null ? function() : null;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
        decoration: BoxDecoration(
            border: Border.all(color: color ?? red, width: 0.4),
            borderRadius: BorderRadius.circular(2)),
        child: buildTextContent(title, false,
            isCenterLeft: false, fontSize: 12, colorWord: textColor),
      ),
    );
  }
}




  // Widget buildCustomMarketInput(
  //     TextEditingController controller, double width, String hintText,
  //     {double? height,
  //     IconData? iconData,
  //     TextInputType? keyboardType,
  //     void Function(String)? onChangeFunction}) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(
  //       vertical: 5,
  //     ),
  //     height: height ?? 40,
  //     width: width,
  //     child: TextFormField(
  //       controller: controller,
  //       maxLines: null,
  //       keyboardType: keyboardType ?? TextInputType.text,
  //       onChanged: (value) {},
  //       decoration: InputDecoration(
  //         contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
  //         enabledBorder: const OutlineInputBorder(
  //             borderSide: BorderSide(color: Colors.grey),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(5),
  //             )),
  //         errorBorder: const OutlineInputBorder(
  //             borderSide: BorderSide(color: red),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(5),
  //             )),
  //         focusedBorder: const OutlineInputBorder(
  //             borderSide: BorderSide(color: Colors.blue),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(5),
  //             )),
  //         hintText: hintText,
  //       ),
  //     ),
  //   );
  // }
