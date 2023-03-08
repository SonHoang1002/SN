  
  // Padding(
  //                           padding:
  //                               const EdgeInsets.only(left: 10, bottom: 10),
  //                           child: buildTextContent(_detailData["title"], true,
  //                               fontSize: 20,
  //                               colorWord: primaryColor,
  //                               isCenterLeft: false),
  //                         ),
  //                         // nhan hieu
  //                         buildBetweenContent(
  //                           "Loại",
  //                           suffixWidget: buildTextContent(
  //                               _detailData["brand"], true,
  //                               fontSize: 15),
  //                         ),
  //                         // nhan hieu
  //                         buildBetweenContent(
  //                           "Nhãn hiệu",
  //                           suffixWidget: buildTextContent(
  //                               _detailData["brand"], true,
  //                               fontSize: 15),
  //                         ),
  //                         // danh gia
  //                         buildBetweenContent(
  //                           "Đánh giá",
  //                           suffixWidget: Row(
  //                             children: [
  //                               buildTextContent(
  //                                   "${_detailData["rating_count"]}", true,
  //                                   fontSize: 15),
  //                               const Icon(
  //                                 FontAwesomeIcons.star,
  //                                 size: 15,
  //                                 color: blackColor,
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         // da ban
  //                         buildBetweenContent(
  //                           "Đã bán",
  //                           suffixWidget: buildTextContent(
  //                               "${_detailData["sold"]}", true,
  //                               fontSize: 15),
  //                         ),
  //                         // thoi gian tao
  //                         buildBetweenContent(
  //                           "Tạo lúc",
  //                           suffixWidget: buildTextContent(
  //                               "${_detailData["created_at"]}", true,
  //                               fontSize: 15),
  //                         ),
  //                         // thoi gian cap nhat
  //                         _detailData["updated_at"] != _detailData["created_at"]
  //                             ? buildBetweenContent(
  //                                 "Câp nhật lúc",
  //                                 suffixWidget: buildTextContent(
  //                                     "${_detailData["updated_at"]}", true,
  //                                     fontSize: 15),
  //                               )
  //                             : SizedBox(),
  //                         _detailData["product_video"] != null
  //                             ? Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Padding(
  //                                     padding:
  //                                         const EdgeInsets.only(bottom: 10),
  //                                     child: buildTextContent("Video", true,
  //                                         fontSize: 17, colorWord: greyColor),
  //                                   ),
  //                                   Padding(
  //                                     padding:
  //                                         const EdgeInsets.only(bottom: 10),
  //                                     child: SizedBox(
  //                                       height: 200,
  //                                       width: 300,
  //                                       child: VideoPlayerRender(
  //                                           path: _detailData["product_video"]
  //                                               ["url"]),
  //                                     ),
  //                                   )
  //                                 ],
  //                               )
  //                             : const SizedBox(),
  //                         _detailData["product_image_attachments"].isNotEmpty
  //                             ? Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Padding(
  //                                     padding:
  //                                         const EdgeInsets.only(bottom: 10),
  //                                     child: buildTextContent("Hình ảnh", true,
  //                                         fontSize: 17, colorWord: greyColor),
  //                                   ),
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(left: 10),
  //                                     child: SingleChildScrollView(
  //                                       scrollDirection: Axis.horizontal,
  //                                       child: Row(
  //                                           children: List.generate(
  //                                               _detailData[
  //                                                       "product_image_attachments"]
  //                                                   .length, (index) {
  //                                         final childData = _detailData[
  //                                                 "product_image_attachments"]
  //                                             [index];
  //                                         return Padding(
  //                                           padding: const EdgeInsets.all(5.0),
  //                                           child: ImageCacheRender(
  //                                             path: childData["attachment"]
  //                                                 ["url"],
  //                                             height: 120.0,
  //                                             width: 120.0,
  //                                           ),
  //                                         );
  //                                       })),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               )
  //                             : const SizedBox()
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  // showCustomBottomSheet(
  //                 context, 500, "Chi tiết sản phẩm",
  //                 bgColor: greyColor[300],
  //                 widget: Container(
  //                   // margin: EdgeInsets.symmetric(vertical: 10),
  //                   child: Column(children: [
  //                     Row(
  //                       children: [
  //                         Flexible(
  //                           flex: 4,
  //                           child: buildTextContent("Tên sản phẩm", false,
  //                               fontSize: 14),
  //                         ),
  //                         Flexible(
  //                           flex: 10,
  //                           child: buildTextContent(data["title"], true,
  //                               fontSize: 18, colorWord: secondaryColor),
  //                         ),
  //                       ],
  //                     ),
  //                     buildDivider(color: primaryColor),
  //                     Container(
  //                       height: 290,
  //                       child: SingleChildScrollView(
  //                         scrollDirection: Axis.horizontal,
  //                         child: DataTable(columns: const [
  //                           DataColumn(
  //                               label: Text('Phân loại hàng',
  //                                   style: TextStyle(
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold))),
  //                           DataColumn(
  //                               label: Text('SKU phân loại',
  //                                   style: TextStyle(
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold))),
  //                           DataColumn(
  //                               label: Text('Giá',
  //                                   style: TextStyle(
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold))),
  //                           DataColumn(
  //                               label: Text('Kho hàng',
  //                                   style: TextStyle(
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold))),
  //                         ], rows: dataRowList),
  //                       ),
  //                     ),
  //                   ]),
  //                 ))









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
