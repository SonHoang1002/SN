import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_video.dart';
import 'package:social_network_app_mobile/screen/Moment/video_description.dart';

class MomentPageview extends ConsumerWidget {
  final List momentRender;
  final Function handlePageChange;
  final int? initialPage;
  final String type;

  const MomentPageview(
      {Key? key,
      required this.type,
      required this.momentRender,
      required this.handlePageChange,
      this.initialPage})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    handleAction(type, data) async {
      dynamic response;
      if (type == 'reaction') {
        if (data['viewer_reaction'] != null) {
          response = await PostApi()
              .reactionPostApi(data['id'], {"custom_vote_type": 'love'});

          {
            response = {
              ...response,
              "viewer_reaction": 'love',
              "favourites_count": response['favourites_count'] + 1
            };
          }
        } else {
          response = await PostApi().unReactionPostApi(data['id']);

          response = {
            ...response,
            "viewer_reaction": null,
            "favourites_count": response['favourites_count'] - 1
          };
        }
      }

      ref
          .read(momentControllerProvider.notifier)
          .updateMomentDetail(data['typeAction'], response);
    }

    return PreloadPageView.builder(
      physics: const CustomPageViewScrollPhysics(),
      controller: PreloadPageController(initialPage: initialPage ?? 0),
      itemCount: momentRender.length,
      scrollDirection: Axis.vertical,
      preloadPagesCount: 5,
      onPageChanged: (value) {
        handlePageChange(value);
      },
      itemBuilder: (context, index) {
        return Stack(
          children: [
            MomentVideo(
                type: type,
                moment: momentRender[index],
                handleAction: handleAction),
            Positioned(
                bottom: 15,
                left: 15,
                child: VideoDescription(
                    type: type,
                    moment: momentRender[index],
                    handleAction: handleAction)),
          ],
        );
      },
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}
