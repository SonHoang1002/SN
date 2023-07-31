import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

class SuggestFooter extends StatelessWidget {
  final String title;
  final Function? function;
  final dynamic suggestData;

  const SuggestFooter(
      {required this.title, this.suggestData, this.function, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function != null ? function!() : null;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTextContent(title, false, fontSize: 14, isCenterLeft: false),
          buildSpacer(width: 7),
          const Icon(FontAwesomeIcons.chevronDown, size: 14),
        ],
      ),
    );
  }
}
