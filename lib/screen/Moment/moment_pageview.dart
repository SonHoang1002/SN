import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_video.dart';
import 'package:social_network_app_mobile/screen/Moment/video_description.dart';

class MomentPageview extends ConsumerStatefulWidget {
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
  ConsumerState<MomentPageview> createState() => _MomentPageviewState();
}

class _MomentPageviewState extends ConsumerState<MomentPageview> {
  bool isDragSlider = false;

  @override
  Widget build(BuildContext context) {
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

    handleSlider(data) {
      setState(() {
        isDragSlider = data;
      });
    }

    return PreloadPageView.builder(
      physics: const CustomPageViewScrollPhysics(),
      controller: PreloadPageController(initialPage: widget.initialPage ?? 0),
      itemCount: widget.momentRender.length,
      scrollDirection: Axis.vertical,
      preloadPagesCount: 5,
      onPageChanged: (value) {
        widget.handlePageChange(value);
      },
      itemBuilder: (context, index) {
        return Stack(
          children: [
            MomentVideo(
                moment: widget.momentRender[index], handleSlider: handleSlider),
            isDragSlider
                ? const SizedBox()
                : Positioned(
                    bottom: 15,
                    left: 15,
                    child: VideoDescription(
                      moment: widget.momentRender[index],
                    )),
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
