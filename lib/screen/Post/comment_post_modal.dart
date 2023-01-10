import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/comment_textfield.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';

class CommentPostModal extends StatelessWidget {
  final dynamic post;
  const CommentPostModal({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(),
            const AppBarTitle(title: 'Bình luận'),
            TextAction(
              title: 'Xong',
              fontSize: 17,
              action: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 0.5, color: greyColor))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Icon(
                    FontAwesomeIcons.solidComments,
                    size: 150,
                    color: Theme.of(context).canvasColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    width: 300,
                    child: Text(
                      'Chưa có bình luận nào, hãy trở thành người bình luận đầu tiên!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: greyColor, letterSpacing: 0.3),
                    ),
                  )
                ],
              ),
            )),
            const Align(
              alignment: Alignment.bottomCenter,
              child: CommentTextfield(),
            )
          ],
        ),
      ),
    );
  }
}
