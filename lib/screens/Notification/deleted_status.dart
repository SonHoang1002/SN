import 'package:flutter/material.dart';

import '../../widgets/appbar_title.dart';
import '../../widgets/back_icon_appbar.dart';

class DeletedStatus extends StatelessWidget {
  String? type;
  DeletedStatus({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          children: const [
            BackIconAppbar(),
            SizedBox(width: 10.0),
            AppBarTitle(title: "Bài viết"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/wow-emo-2.gif",
                height: 125.0,
                width: 125.0,
              ),
            ),
            Text('Rất tiếc. $type này đã bị xóa.'),
          ],
        ),
      ),
    );
  }
}
