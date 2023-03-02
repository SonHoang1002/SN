import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class PostFooterInformation extends StatelessWidget {
  final dynamic post;
  const PostFooterInformation({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: greyColor, fontSize: 14);
    dynamic favourites = post['favourites'];
    String viewerReaction = post['viewer_reaction'] ?? '';
    String textRender = '${shortenLargeNumber(post['favourites_count'])}';
    int reactionsCount = post['favourites_count'];
    List reactions = post['reactions'];

    List sortReactions = reactions
        .map((element) => {
              "type": element['type'],
              "count": element['${element['type']}s_count']
            })
        .toList()
      ..sort(
        (a, b) => a['count'].compareTo(b['count']),
      );

    List renderListReactions = sortReactions.reversed.toList();

    if (viewerReaction.isNotEmpty) {
      if (favourites != null && favourites.isNotEmpty) {
        textRender =
            'Bạn, ${favourites[0]['account']['display_name']}${reactionsCount > 2 ? ' và ${reactionsCount - 2} người khác' : ''}';
      } else {
        textRender =
            'Bạn ${reactionsCount > 1 ? 'và ${reactionsCount - 1} người khác' : ''}';
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          post['favourites_count'] > 0
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
                    const SizedBox(width: 4),
                    Text(
                      textRender,
                      style: style,
                    ),
                  ],
                )
              : const SizedBox(),
          Row(
            children: [
              post['replies_total'] > 0
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
              post['reblogs_count'] > 0
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
    );
  }
}
