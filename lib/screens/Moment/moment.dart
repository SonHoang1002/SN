import 'dart:io';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screens/Moment/moment_pageview.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class Moment extends StatefulHookConsumerWidget {
  final bool? isBack;
  final String? typePage;
  final dynamic dataAdditional;
  final File? imageUpload;
  final dynamic dataUploadMoment;

  const Moment({
    Key? key,
    this.isBack,
    this.imageUpload,
    this.dataAdditional,
    this.dataUploadMoment,
    this.typePage,
  }) : super(key: key);

  @override
  ConsumerState<Moment> createState() => _MomentState();
}

class _MomentState extends ConsumerState<Moment>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);
  bool isPlay = false;
  bool isFly = true;
  bool isFlied = false;
  bool isShowMediaUpload = true;

  final GlobalKey widgetKey = GlobalKey();

  void listClick(GlobalKey widgetKey) async {
    setState(() {
      isFly = false;
    });
    await runAddToCartAnimation(widgetKey);
    setState(() {
      isFlied = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);

    if (mounted) {
      Future.delayed(Duration.zero, () {
        ref
            .read(momentControllerProvider.notifier)
            .getListMomentSuggest({"limit": 5});
      });

      if (widget.dataUploadMoment != null) {
        Future.delayed(Duration.zero, () {
          setState(() {
            isShowMediaUpload = true;
          });

          ref.read(momentControllerProvider.notifier).updateMomentUpload(
              widget.dataUploadMoment['videoPath'],
              widget.dataUploadMoment['imageCover'],
              {
                ...widget.dataUploadMoment,
                'imageCover': null,
                'videoPath': null
              },
              ScaffoldMessenger.of(context));
        });
      }
    }

    _tabController.addListener(() {
      if (_tabController.indexIsChanging &&
          _tabController.index == 0 &&
          ref.read(momentControllerProvider).momentFollow.isNotEmpty) {
        Future.delayed(Duration.zero, () {
          ref
              .read(momentControllerProvider.notifier)
              .getListMomentFollow({"limit": 5});
        });
      }
    });
  }

  final GlobalKey<ScaffoldState> key = GlobalKey();

  List iconAction = [
    {"icon": Icons.search, 'type': 'icon'},
  ];

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List momentFollow = ref.watch(momentControllerProvider).momentFollow;
    List momentSuggests = ref.watch(momentControllerProvider).momentSuggest;
    if (widget.dataAdditional != null && widget.dataAdditional.isNotEmpty) {
      if (momentSuggests.isNotEmpty &&
          momentSuggests[0]['id'] == widget.dataAdditional['id']) {
      } else {
        momentSuggests.insert(0, widget.dataAdditional);
      }
    }
    var momentUpload = ref.watch(momentControllerProvider).momentUpload;

    final size = MediaQuery.of(context).size;

    Widget noData = Container(
      color: Colors.black,
      width: size.width,
      height: size.height,
      child: Center(
        child: Text("Không có dữ liệu hiển thị",
            style: GoogleFonts.ibmPlexSans(
                textStyle: const TextStyle(color: white))),
      ),
    );

    useEffect(
      () {
        Future.delayed(const Duration(seconds: 1), () {
          if (widget.imageUpload != null) {
            listClick(widgetKey);
          }
        });
        return null;
      },
      [widget.imageUpload],
    );

    useEffect(
      () {
        Future.delayed(const Duration(seconds: 0), () {
          if (momentUpload != null && momentUpload.isNotEmpty) {
            setState(() {
              isShowMediaUpload = false;
            });
            ref.read(momentControllerProvider.notifier).clearMomentUpload();
          }
        });
        return null;
      },
      [momentUpload],
    );

    return AddToCartAnimation(
        cartKey: cartKey,
        height: 30,
        width: 30,
        opacity: 0.85,
        dragAnimation: const DragToCartAnimationOptions(
          rotation: true,
        ),
        jumpAnimation: const JumpAnimationOptions(),
        createAddToCartAnimation: (runAddToCartAnimation) {
          // You can run the animation by addToCartAnimationMethod, just pass trough the the global key of  the image as parameter
          this.runAddToCartAnimation = runAddToCartAnimation;
        },
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(children: <Widget>[
              TabBarView(controller: _tabController, children: [
                momentFollow.isNotEmpty
                    ? MomentPageview(
                        type: 'follow',
                        typePage: widget.typePage,
                        momentRender: momentFollow,
                        handlePageChange: (value) {
                          if (value == momentFollow.length - 3) {
                            ref
                                .read(momentControllerProvider.notifier)
                                .getListMomentFollow({
                              "limit": 5,
                              "max_id": momentFollow.last['score']
                            });
                          }
                        },
                      )
                    : noData,
                momentSuggests.isNotEmpty
                    ? Stack(
                        children: [
                          MomentPageview(
                            type: 'suggest',
                            typePage: widget.typePage,
                            momentRender: momentSuggests,
                            handlePageChange: (value) {
                              if (value == momentSuggests.length - 3) {
                                ref
                                    .read(momentControllerProvider.notifier)
                                    .getListMomentSuggest({
                                  "limit": 5,
                                  "max_id": momentSuggests.last['score']
                                });
                              }
                            },
                          ),
                        ],
                      )
                    : noData
              ]),
              if (widget.imageUpload != null && isShowMediaUpload)
                Positioned(
                  top: 120,
                  left: 18,
                  child: AddToCartIcon(
                      key: cartKey,
                      badgeOptions: const BadgeOptions(active: false),
                      icon: isFlied
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Stack(
                                children: [
                                  Image.file(widget.imageUpload!,
                                      width: 80, height: 80, fit: BoxFit.cover),
                                  Positioned.fill(
                                    child: Center(
                                      child: CircularPercentIndicator(
                                        radius: 20.0,
                                        animation: true,
                                        animationDuration: 2000,
                                        lineWidth: 3.0,
                                        percent: 0.99,
                                        center: Countup(
                                          begin: 0,
                                          end: 99,
                                          duration: const Duration(seconds: 2),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.butt,
                                        backgroundColor: Colors.transparent,
                                        progressColor: white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox()),
                ),
              if (widget.imageUpload != null)
                Positioned(
                  top: 120,
                  right: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                        key: widgetKey,
                        width: 100,
                        height: 150,
                        color: Colors.transparent,
                        child: isFly
                            ? Hero(
                                tag: widget.imageUpload!,
                                child: Image.file(widget.imageUpload!,
                                    fit: BoxFit.cover),
                              )
                            : const SizedBox()),
                  ),
                ),
              Positioned(
                  //Place it at the top, and not use the entire screen
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.isBack != null
                                  ? const BackButton()
                                  : InkWell(
                                      onTap: () =>
                                          key.currentState!.openDrawer(),
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 0),
                                        child: Icon(
                                          Icons.menu,
                                          color: white,
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                width: 7,
                              ),
                            ]),
                        TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            onTap: (index) {},
                            indicator: const BoxDecoration(),
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white.withOpacity(0.5),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 0,
                            labelStyle: GoogleFonts.ibmPlexSans(),
                            tabs: const [
                              Tab(
                                text: "Đang theo dõi",
                              ),
                              Tab(
                                text: "Dành cho bạn",
                              )
                            ]),
                        Row(
                          children: List.generate(
                              iconAction.length,
                              (index) => Container(
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.3)),
                                    child: Icon(
                                      iconAction[index]['icon'],
                                      size: 20,
                                      color: white,
                                    ),
                                  )),
                        ),
                      ],
                    ),
                    backgroundColor: transparent, //No more green
                    elevation: 0.0, //Shadow gone
                  ))
            ])));
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }
}
