  // void _showShareDetailBottomSheet(BuildContext context) {
  //   showCustomBottomSheet(context, 250,
  //       title: "Chia sẻ",
  //       widget: ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: DetailProductMarketConstants
  //               .DETAIL_PRODUCT_MARKET_SHARE_SELECTIONS["data"].length,
  //           itemBuilder: (context, index) {
  //             final data = DetailProductMarketConstants
  //                 .DETAIL_PRODUCT_MARKET_SHARE_SELECTIONS["data"];
  //             return Column(
  //               children: [
  //                 GeneralComponent(
  //                   [
  //                     buildTextContent(data[index]["title"], true, fontSize: 16)
  //                   ],
  //                   prefixWidget: Container(
  //                     height: 25,
  //                     width: 25,
  //                     margin: const EdgeInsets.only(right: 10),
  //                     child: Icon(data[index]["icon"]),
  //                   ),
  //                   changeBackground: transparent,
  //                   padding: const EdgeInsets.all(5),
  //                   function: () {
  //                     String title = DetailProductMarketConstants
  //                             .DETAIL_PRODUCT_MARKET_SHARE_SELECTIONS["data"]
  //                         [index]["title"];
  //                     Widget body = const SizedBox();
  //                     switch (data[index]["key"]) {
  //                       // link
  //                       case link:
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                                 content: Text("Sao chép sản phẩm")));
  //                         popToPreviousScreen(context);
  //                         return;
  //                       case share_on_story_table:
  //                       //
  //                       case share_on_group:
  //                         body = ShareAndSearchWidget(
  //                             data: DetailProductMarketConstants
  //                                 .DETAIL_PRODUCT_MARKET_GROUP_SHARE_SELECTIONS,
  //                             placeholder: title);
  //                         break;
  //                       default:
  //                         body = ShareAndSearchWidget(
  //                             data: DetailProductMarketConstants
  //                                 .DETAIL_PRODUCT_MARKET_FRIEND_SHARE_SELECTIONS,
  //                             placeholder: title);
  //                         break;
  //                     }
  //                     showCustomBottomSheet(context, 600,
  //                         title: title,
  //                         iconData: FontAwesomeIcons.chevronLeft,
  //                         isBarrierTransparent: true,
  //                         widget: body);
  //                   },
  //                 ),
  //                 buildDivider(color: greyColor)
  //               ],
  //             );
  //           }));
  // }
