import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/page_api.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class ReviewPage extends ConsumerStatefulWidget {
  final dynamic pageData;
  const ReviewPage(this.pageData, {Key? key}) : super(key: key);

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  final scrollController = ScrollController();
  TextEditingController reviewController = TextEditingController();

  int point = 5;
  String contentReview = '';

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Map<String, dynamic> paramsReviewPage = {
      "page": '0',
    };
    if (ref.read(pageControllerProvider).pageReview.isEmpty) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(pageControllerProvider.notifier)
              .getListPageReview(paramsReviewPage, widget.pageData['id']));
    }
    reviewController.addListener(() {
      if (mounted) {
        setState(() {
          contentReview = reviewController.text;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Widget summaryReview(double point, int totalReviewer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Đề xuất và đánh giá', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.star, size: 22, color: Colors.red),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${point.toStringAsFixed(1)}/5',
                  style: const TextStyle(fontSize: 15)),
              Text('Dựa trên đánh giá của $totalReviewer người')
            ])
          ],
        ),
      ]),
    );
  }

  void handeFeedback(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Nhận xét và đề xuất Trang.'),
              content:
                  const Text('Bạn chắc chắn muốn gửi đề xuất và đánh giá này.'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                CupertinoDialogAction(
                  onPressed: () async {
                    await PageApi().handleReviewPageApi(widget.pageData['id'],
                        {'rating': point, 'content': contentReview});
                    // ignore: use_build_context_synchronously
                    FocusScope.of(context).unfocus();

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    await Future.delayed(
                        Duration.zero,
                        () => ref
                            .read(pageControllerProvider.notifier)
                            .getListPageReview(
                                {'page': '0'}, widget.pageData['id']));
                    if (mounted) {
                      setState(() {
                        contentReview = '';
                        point = 5;
                        reviewController.text = '';
                      });
                    }
                  },
                  child: const Text('Xác nhận'),
                ),
              ],
            ));
  }

  Widget feedbackPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Đề xuất và đánh giá của bạn về Trang này',
            style: TextStyle(fontSize: 17)),
        const SizedBox(height: 12),
        const Text(
          'Điểm đánh giá',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 12),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
                5,
                (index) => index < point
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            point = index + 1;
                          });
                        },
                        child:
                            const Icon(Icons.star, size: 35, color: Colors.red))
                    : InkWell(
                        onTap: () {
                          setState(() {
                            point = index + 1;
                          });
                        },
                        child: const Icon(
                          Icons.star_border,
                          size: 35,
                          color: greyColor,
                        )))),
        const SizedBox(height: 12),
        const Text('Đề xuất', style: TextStyle(fontSize: 15)),
        const SizedBox(height: 12),
        TextFormField(
          controller: reviewController,
          maxLines: 4,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              hintText: "Đề xuất của bạn",
              hintStyle: TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
        ),
        const SizedBox(height: 12),
        ButtonPrimary(
          label: 'Gửi đánh giá',
          colorButton:
              contentReview != '' ? null : Colors.grey.withOpacity(0.6),
          handlePress: () => contentReview != '' ? handeFeedback(context) : {},
        )
      ]),
    );
  }

  void handleDelete(idPage, idReview) async {
    await Future.delayed(Duration.zero, () {
      PageApi().handleDeleteReviewPageApi(idPage, idReview);
    });
    ref.read(pageControllerProvider.notifier).deleteReviewPost(idReview);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List reviewPage = ref.watch(pageControllerProvider).pageReview;
    // bool isMoreReview = ref.watch(pageControllerProvider).isMoreReview;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              summaryReview(
                  widget.pageData['rating'], widget.pageData['review_count']),
              const CrossBar(height: 5),
              feedbackPage(),
              const CrossBar(
                height: 5,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: reviewPage.length + 1,
                  itemBuilder: (context, index) {
                    if (index < reviewPage.length) {
                      return BoxReview(
                        avatar: reviewPage[index]['account']['avatar_media']
                                ?['show_url'] ??
                            reviewPage[index]['account']['avatar_static'],
                        point: reviewPage[index]['rating'].toInt(),
                        title: reviewPage[index]['account']['display_name'],
                        maxPoint: 5,
                        content: reviewPage[index]['content'],
                        handleDelete: () => handleDelete(
                            widget.pageData['id'], reviewPage[index]['id']),
                      );
                    }
                    return null;
                    // else {
                    //   return isMoreReview == true
                    //       ? Center(
                    //           child: SkeletonCustom().postSkeleton(context),
                    //         )
                    //       : const SizedBox();
                    // }
                  }),
              // isMoreReview
              //     ? Center(child: SkeletonCustom().postSkeleton(context))
              //     : const Center(
              //         child: TextDescription(
              //             description: "Bạn đã xem hết các bài viết mới rồi"))
            ],
          ),
        ));
  }
}

class BoxReview extends StatelessWidget {
  final String avatar;
  final String title;
  final int point;
  final int maxPoint;
  final String content;
  final Function handleDelete;
  const BoxReview({
    super.key,
    required this.avatar,
    required this.title,
    required this.point,
    required this.maxPoint,
    required this.content,
    required this.handleDelete,
  });

  @override
  Widget build(BuildContext context) {
    void handleDeleteReview(BuildContext context) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Xóa đề xuất và đánh giá.'),
                content: const Text(
                    'Bạn chắc chắn muốn xóa đề xuất và đánh giá này.'),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Hủy'),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      handleDelete();
                    },
                    child: const Text('Xóa'),
                  ),
                ],
              ));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(children: [
                        AvatarSocial(width: 40, height: 40, path: avatar),
                        const SizedBox(width: 12),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .color)),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                      maxPoint,
                                      (index) => index < point
                                          ? const Icon(Icons.star,
                                              size: 15, color: Colors.red)
                                          : const Icon(Icons.star_border,
                                              size: 15)))
                            ])
                      ]),
                      IconButton(
                          onPressed: () {
                            showBarModalBottomSheet(
                                context: context,
                                topControl: const SizedBox(),
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                builder: (context) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      child: SizedBox(
                                        height: 50,
                                        child: ButtonPrimary(
                                          label: 'Xóa đánh giá',
                                          handlePress: () {
                                            Navigator.of(context).pop();
                                            handleDeleteReview(context);
                                          },
                                          isPrimary: true,
                                          // colorButton: secondaryColor,
                                        ),
                                      ),
                                    ));
                          },
                          icon: const Icon(
                            FontAwesomeIcons.ellipsis,
                            size: 19,
                          ))
                    ]),
              ),
              Text(content)
            ],
          ),
        ),
        const CrossBar(height: 5),
      ],
    );
  }
}
