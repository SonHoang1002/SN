import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';

class SuggestHeader extends StatelessWidget {
  final Function? settingFunction;
  final Function? closeFunction;
  final Widget? headerWidget;
  final Widget? subHeaderWidget;

  const SuggestHeader(
      {this.settingFunction,
      this.closeFunction,
      this.headerWidget,
      this.subHeaderWidget,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            headerWidget ?? const SizedBox(),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      settingFunction != null ? settingFunction!() : null;
                    },
                    child: const Icon(FontAwesomeIcons.ellipsis)),
                buildSpacer(width: 5),
                GestureDetector(
                    onTap: () {
                      closeFunction != null ? closeFunction!() : null;
                    },
                    child: const Icon(FontAwesomeIcons.xmark)),
              ],
            )
          ],
        ),
        subHeaderWidget ?? const SizedBox()
      ],
    );
  }
}
