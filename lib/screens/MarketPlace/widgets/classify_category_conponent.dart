import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'product_item_widget.dart';

Widget buildSuggestListComponent(
    {required BuildContext context,
    required Widget title,
    required List<dynamic> contentList,
    Function? titleFunction,
    ScrollController? controller,
    Axis? axis = Axis.vertical,
    bool? isLoading = false,
    bool? isLoadingMore = false}) {
  final width = MediaQuery.sizeOf(context).width;
  final height = MediaQuery.sizeOf(context).height;

  return axis == Axis.vertical
      ? SingleChildScrollView(
          controller: controller,
          scrollDirection: axis!,
          child: Column(
            children: [
              title,
              GridView.builder(
                  scrollDirection: axis,
                  padding: const EdgeInsets.only(top: 10, left: 7),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 6,
                      crossAxisCount: 2,
                      childAspectRatio: height > 800
                          ? 0.75
                          : (width / (height - 190) > 0
                              ? width / (height - 275)
                              : 0.81)),
                  itemCount: contentList.length,
                  itemBuilder: (context, index) {
                    return buildProductItem(
                        context: context, data: contentList[index]);
                  }),
              _buildLoadingWidget(isLoadingMore, isLoading)
            ],
          ))
      : Column(
          children: [
            title,
            buildSpacer(height: 10),
            SizedBox(
              height: 250,
              width: width,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: contentList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            buildProductItem(
                              context: context,
                              data: contentList[index],
                              // isHaveFlagship: true,
                              // saleBanner: {}
                            ),
                            axis == Axis.horizontal &&
                                    index == contentList.length - 1
                                ? _buildLoadingWidget(isLoadingMore, isLoading)
                                : const SizedBox()
                          ],
                        ));
                  }),
            ),
          ],
        );
}

_buildLoadingWidget(bool? isLoadingMore, bool? isLoading) {
  return isLoadingMore!
      ? isLoading!
          ? buildCircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: buildTextContent("Đã hết sản phẩm gợi ý hôm nay rồi", true,
                  isCenterLeft: false),
            )
      : const SizedBox();
}

class SuggestListComponent extends StatefulWidget {
  final BuildContext context;
  final Widget title;
  final List<dynamic> contentList;
  final Function? titleFunction;
  final ScrollController? controller;
  final Axis? axis;
  final bool? isLoading;
  final bool? isLoadingMore;
  final bool? isShowAll;
  final bool? productIsVertical;
  final bool? isHaveFlagship;
  final dynamic saleBanner;

  /// call callbackFunction when user scroll to max extendent position
  final Function? callbackFunction;

  const SuggestListComponent(
      {super.key,
      required this.context,
      required this.title,
      required this.contentList,
      this.titleFunction,
      this.controller,
      this.axis = Axis.vertical,
      this.isLoading = false,
      this.isLoadingMore = false,
      this.isShowAll,
      this.productIsVertical = true,
      this.isHaveFlagship = false,
      this.saleBanner,
      this.callbackFunction});

  @override
  State<SuggestListComponent> createState() => _SuggestListComponentState();
}

class _SuggestListComponentState extends State<SuggestListComponent> {
  List? _contentList;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() async {
      if (double.parse((scrollController.offset).toStringAsFixed(0)) ==
          (double.parse((scrollController.position.maxScrollExtent)
              .toStringAsFixed(0)))) {
        EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 300),
            () async {
          if (widget.callbackFunction != null) {
            await widget.callbackFunction!();
          }
        });
      }
    });
    _contentList = widget.isShowAll == true
        ? [...widget.contentList, {}]
        : widget.contentList;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;
    return widget.axis == Axis.vertical
        ? SingleChildScrollView(
            controller: scrollController,
            scrollDirection: widget.axis!,
            child: Column(
              children: [
                widget.title,
                GridView.builder(
                    scrollDirection: widget.axis!,
                    padding: const EdgeInsets.only(top: 10, left: 7),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 6,
                        crossAxisCount:
                            widget.productIsVertical == false ? 1 : 2,
                        childAspectRatio: widget.productIsVertical == false
                            ? 3.1
                            : height > 800
                                ? 0.75
                                : (width / (height - 190) > 0
                                    ? width / (height - 275)
                                    : 0.81)),
                    itemCount: _contentList!.length,
                    itemBuilder: (context, index) {
                      if (widget.isShowAll == true &&
                          index == _contentList!.length - 1) {
                        return const SizedBox();
                      }
                      return buildProductItem(
                          context: context,
                          data: _contentList![index],
                          isVertical: widget.productIsVertical,
                          saleBanner: widget.saleBanner,
                          isHaveFlagship: widget.isHaveFlagship!);
                    }),
                _buildLoadingWidget(widget.isLoadingMore, widget.isLoading)
              ],
            ))
        : Column(
            children: [
              widget.title,
              buildSpacer(height: 10),
              SizedBox(
                height: 250,
                width: width,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _contentList!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {},
                          child: widget.isShowAll == true &&
                                  index == _contentList!.length - 1
                              ? buildSeeAllProductItem(context: context)
                              : Row(
                                  children: [
                                    buildProductItem(
                                        context: context,
                                        data: _contentList![index],
                                        isVertical: widget.productIsVertical),
                                    widget.axis == Axis.horizontal &&
                                            index == _contentList!.length - 1
                                        ? _buildLoadingWidget(
                                            widget.isLoadingMore,
                                            widget.isLoading)
                                        : const SizedBox()
                                  ],
                                ));
                    }),
              ),
            ],
          );
  }
}
