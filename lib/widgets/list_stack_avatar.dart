import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

class ListStackAvatar extends StatelessWidget {
  final List listStack;
  final double? width;
  final double? height;
  final int maxItem;
  final String keyPath;

  const ListStackAvatar(
      {super.key,
      required this.listStack,
      this.width,
      this.height,
      required this.maxItem,
      required this.keyPath});

  @override
  Widget build(BuildContext context) {
    List listStackNew = listStack.sublist(
        0, (maxItem - listStack.length > 0 ? listStack.length : maxItem));
    return Center(
      child: Stack(
        children: List.generate(
            listStackNew.length,
            (index) => Padding(
                  padding: EdgeInsets.only(
                      left: width != null
                          ? width! * index * 0.85
                          : 40 * index * 0.85),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2),
                        borderRadius: BorderRadius.circular(50)),
                    child: AvatarSocial(
                        width: width ?? 40,
                        height: height ?? 40,
                        path: listStackNew[index][keyPath]),
                  ),
                )),
      ),
    );
  }
}
