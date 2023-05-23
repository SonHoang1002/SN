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

class _MomentPageviewState extends ConsumerState<MomentPageview>
    with AutomaticKeepAliveClientMixin {
  double currentPage = 0;
  final PreloadPageController _pageController = PreloadPageController();

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      controller: _pageController,
      itemCount: widget.momentRender.length,
      scrollDirection: Axis.vertical,
      preloadPagesCount: 5,
      onPageChanged: (value) {
        widget.handlePageChange(value);
      },
      itemBuilder: (context, index) {
        double opacity = 1.0 - (index - currentPage).abs().clamp(0.0, 1.0);
        return Opacity(
            opacity: opacity,
            child: MomentVideo(
              moment: widget.momentRender[index],
            ));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
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
