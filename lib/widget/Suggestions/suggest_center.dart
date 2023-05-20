import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Suggestions/suggest_item.dart';

class SuggestCenter extends StatefulWidget {
  final List<dynamic> suggestList;
  final dynamic type;
  final double? viewportFraction;
  final Function? loadMoreFunction;
   final Function? reloadFunction;
  const SuggestCenter(
      {required this.suggestList,
      this.type,
      this.viewportFraction,
      this.loadMoreFunction,
      this.reloadFunction,
      super.key});

  @override
  State<SuggestCenter> createState() => _SuggestCenterState();
}

class _SuggestCenterState extends State<SuggestCenter> {
  bool isScrollToLimit = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List _suggestList = widget.suggestList;
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.52,
      padding: EdgeInsets.zero,
      child: buildPageView(_suggestList, widget.type, size),
    );
  }

  Widget buildPageView(List _suggestList, dynamic type, Size size,
      {double? viewportFraction}) {
    return SizedBox(
      height: size.height * 0.52,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: viewportFraction ?? (size.width > 400 ? 0.8 : 0.75),
          initialPage: 0,
        ),
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: _suggestList.length,
        padEnds: isScrollToLimit ? false : true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (ctx, index) {
          return Container(
            margin: const EdgeInsets.only(
              right: 10,
            ),
            width: size.width * 0.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: greyColor, width: 0.3)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SuggestItem(
                  suggestData: _suggestList[index],
                  type: type,
                  reloadFunction:widget.reloadFunction,
                )),
          );
        },
        onPageChanged: (value) {
          if (isScrollToLimit == false &&
              (value == 0 || value == widget.suggestList.length)) {
            setState(() {
              isScrollToLimit = true;
            });
          } else {
            if (isScrollToLimit == true) {
              setState(() {
                isScrollToLimit = false;
              });
            }
          } 
          setState(() {
            currentIndex = value;
          });
          if (currentIndex == widget.suggestList.length - 6 ||
              widget.suggestList.length < 6) {
            widget.loadMoreFunction != null ? widget.loadMoreFunction!() : null;
          }
        },
      ),
    );
  }
}
