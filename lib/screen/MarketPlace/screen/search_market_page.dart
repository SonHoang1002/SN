import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/cart_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../../../helper/push_to_new_screen.dart';

class SearchMarketPage extends StatefulWidget {
  @override
  State<SearchMarketPage> createState() => _SearchMarketPageState();
}

class _SearchMarketPageState extends State<SearchMarketPage> {
  late double width = 0;
  late double height = 0;
  bool _isOpenProductOfYou = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return DefaultTabController(
        length: 2, // Added
        initialIndex: 0,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackIconAppbar(),
                Expanded(
                    child: SearchInput(
                  title: "Tìm kiếm trên Market Place",
                )),
                InkWell(
                  onTap: () {
                    pushToNextScreen(context, CartMarketPage());
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Icon(
                      FontAwesomeIcons.cartArrowDown,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  // icon: Icon(FontAwesomeIcons.list),
                  child: Text("Hạng mục"),
                ),
                Tab(
                    // icon: Icon(FontAwesomeIcons.searchengin),
                    child: Text("Tìm kiếm")),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              categoryBodyWidget(),
              searchBodyWidget(width),
            ],
          ),
        ));
  }
}

Widget categoryBodyWidget() {
  return GestureDetector(
    onTap: (() {
      FocusManager.instance.primaryFocus!.unfocus();
    }),
    child: Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              // tim kiem gan day
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextContent("Tìm kiếm gần đây", true,
                            fontSize: 20),
                        buildTextContent("Xóa tất cả", true,
                            fontSize: 15, colorWord: blueColor),
                      ],
                    ),
                  ),
                  Column(
                    children: List.generate(
                        4,
                        (index) => Column(
                              children: [
                                _buildSearchItemWithContentAndDeleteIcon(
                                    "Xe o to", index),
                                buildDivider(color: greyColor, height: 10)
                              ],
                            )),
                  )
                ],
              ),
              buildSpacer(height: 10),
              // hang muc tim kiem
              buildTextContent("Hạng mục tìm kiếm", true, fontSize: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      children: List.generate(
                    MainMarketBodyConstants
                        .MAIN_MARKETPLACE_BODY_CATEGORY_SELECTIONS["data"]
                        .length,
                    (index) {
                      final data = MainMarketBodyConstants
                          .MAIN_MARKETPLACE_BODY_CATEGORY_SELECTIONS["data"];
                      return GeneralComponent(
                        [
                          buildTextContent(
                            data[index]["title"], false,
                            // colorWord: Colors.black
                          )
                        ],
                        changeBackground: transparent,
                        prefixWidget: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(right: 5),
                            // padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(data[index]["icon"]))),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      );
                    },
                  )),
                ),
              )
            ]),
          ),
        )
      ],
    ),
  );
}

Widget searchBodyWidget(double width) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 20),
        child: buildTextContent("Nội dung tìm kiếm", true, fontSize: 20),
      ),
      buildTextContent(
          "Bạn chưa lưu nội dung tìm kiếm nào. Hãy thử tìm kiếm dung mới",
          false,
          fontSize: 16,
          isCenterLeft: false),
      buildButtonForMarketWidget(
          width: width * 0.8,
          iconData: FontAwesomeIcons.search,
          title: "Tìm kiếm trên Marketplace")
    ]),
  );
}

_buildSearchItemWithContentAndDeleteIcon(String searchTitle, int index) {
  return InkWell(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(5),
                child: const Icon(
                  FontAwesomeIcons.clock,
                  size: 18,
                ),
              ),
              buildTextContent(
                "${searchTitle} - ${index}",
                false,
                fontSize: 17,
              ),
            ],
          ),
          Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
            child: const Icon(
              FontAwesomeIcons.close,
              size: 18,
            ),
          ),
        ],
      ),
    ),
  );

  // GeneralComponent(
  //   [
  //     buildTextContent("Xe o to", true, fontSize: 20),
  //   ],
  //   suffixWidget: Container(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         const SizedBox(),
  //         Container(
  //           height: 30,
  //           width: 30,
  //           padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
  //           child: const Icon(
  //             FontAwesomeIcons.close,
  //             size: 18,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  //   prefixWidget: Container(
  //     height: 30,
  //     width: 30,
  //     padding: const EdgeInsets.all(5),
  //     child: const Icon(
  //       FontAwesomeIcons.clock,
  //       size: 18,
  //     ),
  //   ),
  //   padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
  //   changeBackground: transparent,
  // );
}
