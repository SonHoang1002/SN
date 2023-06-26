import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screens/Moment/moment_video.dart';
import 'package:social_network_app_mobile/screens/Post/comment_post_modal.dart';

class MomentPageview extends ConsumerStatefulWidget {
  final List momentRender;
  final Function handlePageChange;
  final int? initialPage;
  final String type;
  final String? typePage;

  const MomentPageview(
      {Key? key,
      required this.type,
      required this.momentRender,
      required this.handlePageChange,
      this.initialPage,
      this.typePage})
      : super(key: key);

  @override
  ConsumerState<MomentPageview> createState() => _MomentPageviewState();
}

class _MomentPageviewState extends ConsumerState<MomentPageview>
    with AutomaticKeepAliveClientMixin {
  double currentPage = 0;
  late PreloadPageController _pageController;

  @override
  void initState() {
    super.initState();

    currentPage = widget.initialPage?.toDouble() ?? 0;

    _pageController =
        PreloadPageController(initialPage: widget.initialPage ?? 0);

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.typePage != null && widget.typePage == 'home'
        ? RenderPageView(
            pageController: _pageController,
            currentPage: currentPage,
            widget: widget)
        : Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 80,
                child: RenderPageView(
                    pageController: _pageController,
                    currentPage: currentPage,
                    widget: widget),
              ),
              GestureDetector(
                onTap: () {
                  showBarModalBottomSheet(
                      context: context,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: CommentPostModal(
                              post: widget.momentRender[currentPage.toInt()])));
                },
                child: Container(
                    height: 80,
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        Text("Thêm bình luận...",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ],
                    )),
              ),
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}

class RenderPageView extends StatelessWidget {
  const RenderPageView({
    super.key,
    required PreloadPageController pageController,
    required this.widget,
    required this.currentPage,
  }) : _pageController = pageController;

  final PreloadPageController _pageController;
  final MomentPageview widget;
  final double currentPage;

  @override
  Widget build(BuildContext context) {
    return PreloadPageView.builder(
      physics: const CustomPageViewScrollPhysics(),
      controller: _pageController,
      itemCount: widget.momentRender.length,
      scrollDirection: Axis.vertical,
      preloadPagesCount: 3,
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
