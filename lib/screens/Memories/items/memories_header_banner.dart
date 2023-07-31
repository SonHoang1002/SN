import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/memories_banner.jpg"),
        Container(
          padding: const EdgeInsets.all(25),
          child: const Text(
            "Chúng tôi hy vọng bạn thích ôn lại và chia sẻ kỷ niệm trên Facebook, từ các kỷ niệm gần đây nhất đến những kỷ niệm ngày xa xưa.",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
