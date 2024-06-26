import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/text_action.dart';

import '../../../widgets/GeneralWidget/spacer_widget.dart';

buildHaveAccountWidget({Function? function}) {
  return Column(
    children: [
      const CrossBar(height: 0.5),
      TextAction(
        fontSize: 15,
        title: "Bạn đã có tài khoản",
        action: () {
          function != null ? function() : null;
        },
      ),
      buildSpacer(height: 10),
    ],
  );
}
