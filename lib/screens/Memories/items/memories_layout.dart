import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/screens/Memories/items/box.dart';

class LayoutsArea extends ConsumerWidget {
  const LayoutsArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.add_circle,
                  size: 35,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0, top: 10),
                  child: Text(
                    "Bố cục kỷ niệm",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BoxLayout(
                        title: "Ngày ấy & Bây giờ",
                        color: Colors.blue,
                        image: "assets/memories_layout_1.jpg",
                      ),
                      BoxLayout(
                        title: "Nổi bật",
                        color: Color(0xffed42a5),
                        image: "assets/memories_layout_2.jpg",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BoxLayout(
                        title: "Hành trình",
                        color: Color(0xfff24060),
                        image: "assets/memories_layout_3.jpg",
                      ),
                      BoxLayout(
                        title: "Đặt câu hỏi",
                        color: Color(0xffef6e1c),
                        image: "assets/memories_layout_4.jpg",
                      )
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
