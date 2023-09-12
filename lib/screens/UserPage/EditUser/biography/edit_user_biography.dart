import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../../../constant/common.dart';
import '../../../../providers/UserPage/user_information_provider.dart';
import '../../../../widgets/avatar_social.dart';
import '../../../../widgets/back_icon_appbar.dart';

class EditUserBiography extends ConsumerStatefulWidget {
  final dynamic dataPage;
  final Function onUpdate;
  const EditUserBiography(
      {super.key, required this.dataPage, required this.onUpdate});

  @override
  EditUserBiographyState createState() => EditUserBiographyState();
}

class EditUserBiographyState extends ConsumerState<EditUserBiography> {
  TextEditingController descriptionTxtCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userAbout = ref.watch(userInformationProvider).userMoreInfor;
    final generalInformation = userAbout['general_information'];
    descriptionTxtCtrl.text = generalInformation['description']!=null?generalInformation['description'].toString():"";
    return Scaffold(
      appBar: AppBar(title: Text("Chỉnh sửa tiểu sử", style: TextStyle(color: colorWord(context)),), actions: [
        TextButton(
            onPressed: () {
              if (descriptionTxtCtrl.text.split('').isNotEmpty) {
                ref.read(userInformationProvider.notifier).updateDescription(
                      widget.dataPage['id'],
                      descriptionTxtCtrl.text.trim(),
                    );
                Navigator.pop(context);
                widget.onUpdate();
              } else {
                ref.read(userInformationProvider.notifier).updateDescription(
                      widget.dataPage['id'],
                      descriptionTxtCtrl.text.trim(),
                    );
                Navigator.pop(context);
                widget.onUpdate();
              }

              setState(() {});
            },
            child: const Text(
              "Lưu",
              style: TextStyle(fontSize: 18),
            ))
      ],
      leading: const BackIconAppbar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.1, color: greyColor),
                  ),
                  child: AvatarSocial(
                    width: 50,
                    height: 50,
                    path: widget.dataPage['avatar_media']?['preview_url'] ??
                        linkAvatarDefault,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.dataPage["display_name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              typeVisibility[0]['icon'],
                              size: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            typeVisibility[0]['label'],
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[600]),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.sizeOf(context).height / 3 - 38,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: colorWord(context), width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double
                          .infinity, // Đảm bảo rằng Container có chiều rộng tối đa
                      child: Align(
                        alignment:
                            Alignment.topLeft, // Căn đoạn văn bản về phía trái
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                            children: const [
                              TextSpan(
                                text:
                                    "Bạn có thể thêm tiểu sử ngắn để cho mọi người biết thêm về bản thân mình. Hãy thêm bất cứ thứ gì bạn muốn, chẳng hạn như châm ngôn yêu thích hoặc điều làm mình vui.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      autofocus: false,
                      maxLines: 5,
                      maxLength: 101,
                      controller: descriptionTxtCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Hãy nhập tiểu sử ở đây',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
