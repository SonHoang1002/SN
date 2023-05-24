import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';

class ReefHeader extends StatelessWidget {
  final Function? function;
  const ReefHeader({this.function, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              FontAwesomeIcons.film,
              size: 18,
            ),
            buildSpacer(width: 5),
            buildTextContent("Khoảnh khắc", true, fontSize: 17)
          ],
        ),
        GestureDetector(
            onTap: () {
              function != null ? function!() : null;
            },
            child: const Icon(FontAwesomeIcons.ellipsis)),
      ],
    );
  }
}
