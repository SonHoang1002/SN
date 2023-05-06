import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';

class PostFooterInformation extends ConsumerWidget {
  final dynamic post;
  final String? type;
  final dynamic preType;
  const PostFooterInformation({Key? key, this.post, this.type, this.preType})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dynamic meData = ref.read(meControllerProvider)[0];
    const style = TextStyle(color: greyColor, fontSize: 15);
    dynamic favourites = post['favourites'];
    String viewerReaction = post['viewer_reaction'] ?? '';
    String textRender = '${shortenLargeNumber(post?['favourites_count'] ?? 0)}';
    int reactionsCount = post['favourites_count'] ?? 0;
    List reactions = post['reactions'] ?? [];

    List sortReactions = reactions
        .map((element) => {
              "type": element['type'],
              "count": element['${element['type']}s_count']
            })
        .toList()
        .where((element) => element['count'] > 0)
        .toList()
      ..sort(
        (a, b) => a['count'].compareTo(b['count']),
      );

    List renderListReactions = sortReactions.reversed.toList();

    if (viewerReaction.isNotEmpty) {
      if (favourites != null && favourites.length == 2) {
        textRender =
            'Bạn, ${meData['id'] == favourites[0]['account']['id'] ? favourites[1]['account']['display_name'] : favourites[0]['account']['display_name']}${reactionsCount > 2 ? ' và ${shortenLargeNumber(reactionsCount - 2)} người khác' : ''}';
      } else {
        textRender =
            'Bạn ${reactionsCount > 1 ? 'và ${shortenLargeNumber(reactionsCount - 1)} người khác' : ''}';
      }
    }

    renderImage(link, key) {
      double size = key == 'love'
          ? 24
          : ['angry', 'sad', 'like'].contains(key)
              ? key == 'yay'
                  ? 28
                  : 16
              : 18;
      return Image.asset(
        link,
        height: size,
        width: size,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(FontAwesomeIcons.faceAngry),
      );
    }

    renderReaction(key) {
      if (key != null) {
        return renderImage('assets/reaction/$key.png', key);
      } else {
        return const SizedBox();
      }
    }

    double setHeight() {
      double height = 5;
      if ((post['favourites_count'] ?? 0) > 0 ||
          (post['replies_total'] ?? 0) > 0) {
        height = 40;
      }
      return height;
    }

    EdgeInsets setPadding() {
      EdgeInsets padding = const EdgeInsets.fromLTRB(8, 6, 8, 9);
      // if ((post['favourites_count'] ?? 0) > 0 ||
      //     (post['replies_total'] ?? 0) > 0) {
      //   if (favourites != null && favourites.length == 2) {
      //     padding = const EdgeInsets.fromLTRB(8, 3, 8, 6);
      //   } else {
      //     if (reactionsCount > 1) {
      //       //bajn va nguoi khac
      //       padding = const EdgeInsets.fromLTRB(8, 6, 8, 9);
      //     } else {
      //       //ban
      //       padding = const EdgeInsets.fromLTRB(8, 6, 8, 9);
      //     }
      //   }
      // }

      return padding;
    }

    return Container(
      height: setHeight(),
      padding: setPadding(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // (post['favourites_count'] ?? 0) > 0 ||
          //         (post['replies_total'] ?? 0) > 0
          //     ? SizedBox(height:5)
          //     : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (post['favourites_count'] ?? 0) > 0
                  ? Row(
                      children: [
                        renderListReactions.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Transform.translate(
                                      offset: const Offset(6, 0),
                                      child: renderReaction(
                                          renderListReactions[0]['type'])),
                                  renderListReactions.length >= 2
                                      ? Transform.translate(
                                          offset: const Offset(4, 0),
                                          child: renderReaction(
                                              renderListReactions[1]['type']),
                                        )
                                      : const SizedBox(),
                                  renderListReactions.length >= 3
                                      ? renderReaction(
                                          renderListReactions[2]['type'])
                                      : const SizedBox(),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(width: 8),
                        Text(
                          textRender,
                          style: style,
                        ),
                      ],
                    )
                  : const SizedBox(),
              type == postDetail
                  ? const SizedBox()
                  : Row(
                      children: [
                        (post['replies_total'] ?? 0) > 0
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${shortenLargeNumber(post['replies_total'])}",
                                    style: style,
                                  ),
                                  const SizedBox(
                                    width: 3.0,
                                  ),
                                  const Icon(
                                    FontAwesomeIcons.message,
                                    size: 14,
                                    color: greyColor,
                                  )
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        (post['reblogs_count'] ?? 0) > 0
                            ? Row(
                                children: [
                                  Text(
                                    '${shortenLargeNumber(post['reblogs_count'])}',
                                    style: style,
                                  ),
                                  const Icon(
                                    Icons.share,
                                    size: 14,
                                    color: greyColor,
                                  )
                                ],
                              )
                            : const SizedBox()
                      ],
                    )
            ],
          ),
        ],
      ),
    );
  }
}
