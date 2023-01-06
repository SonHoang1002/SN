import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

class ImageVideo extends StatelessWidget {
  const ImageVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonPrimary(
                handlePress: () {},
                icon: const Icon(
                  FontAwesomeIcons.tableList,
                  size: 18,
                ),
                label: "Chọn bố cục hiển thị hình ảnh",
              ),
              const SizedBox(
                width: 12.0,
              ),
              InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.camera),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
