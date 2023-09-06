import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:social_network_app_mobile/apis/market_place_apis/voucher_api.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';
import '../../../../theme/colors.dart';

class StorageVoucher extends ConsumerStatefulWidget {
  const StorageVoucher({super.key});

  @override
  ConsumerState<StorageVoucher> createState() => _StorageVoucherState();
}

class _StorageVoucherState extends ConsumerState<StorageVoucher> {
  late double width = 0;
  late double height = 0;
  Color? colorTheme;
  int _selectedTab = 0;
  int _selectedTime = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> tabList = ["Tất cả", "Emsocial", "Shop"];

    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    colorTheme = ThemeMode.dark == true
        ? Theme.of(context).cardColor
        : const Color(0xfff1f2f5);
    Color colorWord = ThemeMode.dark == true
        ? white
        : true == ThemeMode.light
            ? blackColor
            : greyColor;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Kho Voucher"),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  FontAwesomeIcons.search,
                  size: 18,
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: tabList.length,
                child: Scaffold(
                  body: Column(
                    children: [
                      TabBar(
                        onTap: (value) {
                          setState(() {
                            _selectedTab = value;
                          });
                        },
                        tabs: tabList.map((e) {
                          return Tab(
                            child: SizedBox(
                              width: width * 0.43,
                              child: buildTextContent(
                                e,
                                false,
                                isCenterLeft: false,
                                colorWord: colorWord,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedTime = 0;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    "Tất cả",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _selectedTime == 0
                                            ? primaryColor
                                            : colorWord),
                                  ),
                                ),
                              )),
                              Container(
                                color: Colors.grey.withOpacity(0.5),
                                width: 5,
                                height: 50,
                              ),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedTime = 1;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    "Đang diễn ra",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _selectedTime == 1
                                            ? primaryColor
                                            : colorWord),
                                  ),
                                ),
                              )),
                            ],
                          ),
                          const CrossBar(
                            height: 5,
                            margin: 0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedTime = 2;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Text("Sắp diễn ra",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: _selectedTime == 2
                                              ? primaryColor
                                              : colorWord)),
                                ),
                              )),
                              Container(
                                color: Colors.grey.withOpacity(0.5),
                                width: 5,
                                height: 50,
                              ),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedTime = 3;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Text("Đã kết thúc",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: _selectedTime == 3
                                              ? primaryColor
                                              : colorWord)),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ContentMyVouchers(
                              selectedTab: 0,
                              selectedTime: _selectedTime,
                            ),
                            ContentMyVouchers(
                              selectedTab: 1,
                              selectedTime: _selectedTime,
                            ),
                            ContentMyVouchers(
                              selectedTab: 2,
                              selectedTime: _selectedTime,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class ContentMyVouchers extends StatefulWidget {
  final int selectedTab;
  final int selectedTime;
  const ContentMyVouchers(
      {super.key, required this.selectedTab, required this.selectedTime});

  @override
  State<ContentMyVouchers> createState() => _ContentMyVouchersState();
}

class _ContentMyVouchersState extends State<ContentMyVouchers> {
  Future<List> getData() async {
    dynamic response;
    if (widget.selectedTab == 0) {
      if (widget.selectedTime == 0) {
        response = await VoucerApis().getMyVoucher(null, null);
      } else if (widget.selectedTime == 1) {
        response = await VoucerApis().getMyVoucher("now", null);
      } else if (widget.selectedTime == 2) {
        response = await VoucerApis().getMyVoucher("upcoming", null);
      } else if (widget.selectedTime == 3) {
        response = await VoucerApis().getMyVoucher("past", null);
      }
    } else if (widget.selectedTab == 1) {
      if (widget.selectedTime == 0) {
        response = await VoucerApis().getMyVoucher(null, "shipping_voucher");
      } else if (widget.selectedTime == 1) {
        response = await VoucerApis().getMyVoucher("now", "shipping_voucher");
      } else if (widget.selectedTime == 2) {
        response =
            await VoucerApis().getMyVoucher("upcoming", "shipping_voucher");
      } else if (widget.selectedTime == 3) {
        response = await VoucerApis().getMyVoucher("past", "shipping_voucher");
      }
    } else if (widget.selectedTab == 2) {
      if (widget.selectedTime == 0) {
        response = await VoucerApis().getMyVoucher(null, "shop_voucher");
      } else if (widget.selectedTime == 1) {
        response = await VoucerApis().getMyVoucher("now", "shop_voucher");
      } else if (widget.selectedTime == 2) {
        response = await VoucerApis().getMyVoucher("upcoming", "shop_voucher");
      } else if (widget.selectedTime == 3) {
        response = await VoucerApis().getMyVoucher("past", "shop_voucher");
      }
    }
    return response["data"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data, display a loading indicator
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If an error occurred, display an error message
          return const Center(child: Text('Có lỗi xảy ra'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // If no data is available, display a message
          return const Center(child: Text('Bạn chưa có voucher nào.'));
        } else {
          // If data is available, render the screen with the list
          List items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              String minimunBasketPrice =
                  items[index]["minimum_basket_price"].toString();
              if (minimunBasketPrice.endsWith('000')) {
                minimunBasketPrice =
                    '${minimunBasketPrice.substring(0, minimunBasketPrice.length - 3)}k';
              } else if (minimunBasketPrice.endsWith('000000')) {
                minimunBasketPrice =
                    '${minimunBasketPrice.substring(0, minimunBasketPrice.length - 3)}triệu';
              } else if (minimunBasketPrice.endsWith('000000000')) {
                minimunBasketPrice =
                    '${minimunBasketPrice.substring(0, minimunBasketPrice.length - 3)}tỷ';
              }
              double usedVoucher =
                  double.parse(items[index]["used_count"].toString());
              if (items[index]["used_count"] != 0) {
                usedVoucher =
                    usedVoucher / items[index]["usage_quantity"] * 100;
              }
              final themeManager =
                  pv.Provider.of<ThemeManager>(context, listen: true);
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        color: Colors.pink.shade50.withOpacity(0.8),
                        height: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      items[index]["page"]["avatar_media"]
                                          ["url"],
                                    ),
                                    radius:
                                        40, // Set the radius to half of the desired width/height
                                  ),
                                ),
                                Text(items[index]["page"]["title"]),
                              ],
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 80,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          const TextSpan(text: "Giảm "),
                                          if (items[index]["discount_type"] ==
                                              "fix_amount")
                                            const TextSpan(
                                              text: "đ",
                                              style: TextStyle(
                                                decoration: TextDecoration
                                                    .underline, // Underline the "₫" character
                                              ),
                                            ),
                                          TextSpan(
                                            text: items[index]["amount"]
                                                .toString(),
                                          ),
                                          if (items[index]["discount_type"] ==
                                              "by_percentage")
                                            const TextSpan(
                                              text: "%",
                                            ),
                                        ],
                                      ),
                                    ),
                                    buildTextContent(
                                        "Đơn tối thiểu ₫${items[index]["minimum_basket_price"].toString()}",
                                        false,
                                        fontSize: 12,
                                        colorWord: Colors.red,
                                        maxLines: 2),
                                    Text(
                                      "HSD: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(items[index]["end_time"]))}",
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "Đã dùng ${usedVoucher.toStringAsFixed(0)}%",
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                    onTap: () {},
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 2)),
                                        child: const Text(
                                          "Dùng ngay",
                                          style: TextStyle(color: Colors.red),
                                        ))),
                                InkWell(
                                    onTap: () {},
                                    child: const Text(
                                      "Điều kiện",
                                      style: TextStyle(color: Colors.blue),
                                    )),
                                InkWell(
                                    onTap: () {},
                                    child: const Text(
                                      "Xóa Voucher",
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: -6,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                                10,
                                (index) => CircleAvatar(
                                      backgroundColor: themeManager.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      radius: 6,
                                    ))),
                      ),
                    ],
                  ),
                  const CrossBar(
                    height: 14,
                    margin: 0,
                  )
                ],
              );
            },
          );
        }
      },
    );
  }
}
