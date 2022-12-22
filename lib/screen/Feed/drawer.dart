import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class DrawerFeed extends StatelessWidget {
  const DrawerFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerHeader(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Lối tắt',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 5,
            ),
            TextDescription(
                description:
                    "Với lối tắt, bạn có thể nhanh chóng truy cập vào những việc mình hay làm nhất trên Emso Social, giúp cho bạn có được trải nghiệm tốt nhất, nhanh nhất khi sử dụng.")
          ],
        ))
      ],
    );
  }
}
