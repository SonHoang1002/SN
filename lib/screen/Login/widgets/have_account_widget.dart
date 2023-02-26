import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_button.dart';

import '../../../widget/GeneralWidget/divider_widget.dart';
import '../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../widget/GeneralWidget/text_content_widget.dart';

buildHaveAccountWidget({Function? function}) {
  return Column(
    children: [
      buildDivider(color: Colors.grey[800]),
      buildSpacer(height: 10),
      buildTextContentButton("Bạn đã có tài khoản", false,
          fontSize: 15,
          colorWord: Colors.blue,
          isCenterLeft: false, function: () {
        function != null ? function() : null;
      }),
      buildSpacer(height: 10),
    ],
  );
}
