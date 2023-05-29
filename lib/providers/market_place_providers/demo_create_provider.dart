// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class DemoCreateProvider with ChangeNotifier {
// //   dynamic demoCreateProduct = {
// //     "loai_1": {
// //       "name": TextEditingController(text: "Màu sắc"),
// //       "values": [
// //         TextEditingController(text: "xanh"),
// //       ],
// //       "images": [""],
// //       "contents": {
// //         "price": [
// //           TextEditingController(text: ""),
// //         ],
// //         "repository": [
// //           TextEditingController(text: ""),
// //         ],
// //         "sku": [
// //           TextEditingController(text: ""),
// //         ],
// //       },
// //     },
// //   };
// //   set setDemoCreateProduct(dynamic newDemo) {
// //     demoCreateProduct = newDemo;
// //     notifyListeners();
// //   }

// //   get getDemoCreateProduct => demoCreateProduct;
// // }

// class DemoCreateProductState {
//   Map<String, dynamic> demoCreate;
//   DemoCreateProductState({this.demoCreate = const {}});
//   DemoCreateProductState copyWith(Map<String, dynamic> newDemo) {
//     return DemoCreateProductState(demoCreate: newDemo);
//   }
// }

// final demoCreateProductProvider =
//     StateNotifierProvider<DetailProductController, DemoCreateProductState>(
//         (ref) => DetailProductController());

// class DetailProductController extends StateNotifier<DemoCreateProductState> {
//   DetailProductController() : super(DemoCreateProductState());

//   initDemoCreateProduct() async {
//     state = state.copyWith({
//       "loai_1": {
//         "name": TextEditingController(text: "Màu sắc"),
//         "values": [
//           TextEditingController(text: "xanh"),
//         ],
//         "images": [""],
//         "contents": {
//           "price": [
//             TextEditingController(text: ""),
//           ],
//           "repository": [
//             TextEditingController(text: ""),
//           ],
//           "sku": [
//             TextEditingController(text: ""),
//           ],
//         },
//       },
//     });
//   }

//   updateDemoCreateProduct(Map<String, dynamic> newDemo) async {
//     state = state.copyWith(newDemo);
//   }
// }
