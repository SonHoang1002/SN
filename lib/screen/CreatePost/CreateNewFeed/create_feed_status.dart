import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/background_post.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_status_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import "package:collection/collection.dart";
import 'package:social_network_app_mobile/widget/text_description.dart';

class CreateFeedStatus extends StatefulWidget {
  final String? content;
  final bool isShowBackground;
  final dynamic checkin;
  final dynamic visibility;
  final dynamic statusActivity;
  final dynamic backgroundSelected;
  final Function handleUpdateData;
  final List friendSelected;
  final Function handleGetPreviewUrl;
  const CreateFeedStatus(
      {Key? key,
      required this.visibility,
      this.backgroundSelected,
      required this.handleUpdateData,
      required this.handleGetPreviewUrl,
      required this.isShowBackground,
      this.statusActivity,
      required this.friendSelected,
      this.checkin,
      this.content})
      : super(key: key);

  @override
  State<CreateFeedStatus> createState() => _CreateFeedStatusState();
}

class _CreateFeedStatusState extends State<CreateFeedStatus> {
  final TextEditingController controller = TextEditingController();
  bool isActiveBackground = false;

  @override
  void initState() {
    if (!mounted) return;

    if (widget.content!.trim().isNotEmpty) {
      controller.text = widget.content ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String description = '';

    if (widget.statusActivity == null) {
      description = '';
    } else if (widget.statusActivity['parent'] == null) {
      description = ' đang cảm thấy ${widget.statusActivity['name']}';
    } else {
      description =
          ' ${widget.statusActivity['parent']['name'].toLowerCase()} ${widget.statusActivity['name'].toLowerCase()}';
    }

    if (widget.friendSelected.isNotEmpty) {
      description = '$description cùng với ';
    }

    if (widget.checkin != null) {
      description = '$description đang ở ${widget.checkin['title']}';
    }

    double marginContainer = widget.backgroundSelected != null ? 0.0 : 8.0;
    double paddingContainer = widget.backgroundSelected != null ? 8.0 : 0;

    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(width: 0.2, color: greyColor)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: CreateFeedStatusHeader(
              description: description,
              friendSelected: widget.friendSelected,
              statusActivity: widget.statusActivity,
              visibility: widget.visibility,
              handleUpdateData: widget.handleUpdateData,
            ),
          ),
          Container(
            height: widget.backgroundSelected != null ? 230 : null,
            width: size.width,
            margin: EdgeInsets.only(
                left: marginContainer, right: marginContainer, bottom: 8.0),
            padding: EdgeInsets.symmetric(horizontal: paddingContainer),
            decoration: BoxDecoration(
              image: widget.backgroundSelected != null
                  ? DecorationImage(
                      image: NetworkImage(widget.backgroundSelected['url']),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  autofocus: false,
                  onChanged: (value) {
                    widget.handleUpdateData('update_content', value);
                    widget.handleGetPreviewUrl(value);
                  },
                  maxLines: null,
                  textAlign: widget.backgroundSelected != null
                      ? TextAlign.center
                      : TextAlign.left,
                  controller: controller,
                  style: widget.backgroundSelected != null
                      ? TextStyle(
                          color: Color(int.parse(
                              '0xFF${widget.backgroundSelected['style']['fontColor'].substring(1)}')),
                          fontWeight: FontWeight.w700,
                          fontSize: 22)
                      : null,
                  decoration: InputDecoration(
                    hintText: "Bạn đang nghĩ gì?",
                    hintStyle: TextStyle(
                        color: widget.backgroundSelected != null
                            ? Color(int.parse(
                                '0xFF${widget.backgroundSelected['style']['fontColor'].substring(1)}'))
                            : null,
                        fontSize: widget.backgroundSelected != null ? 22 : 15),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class WrapBackground extends StatelessWidget {
  final Widget widgetChild;
  const WrapBackground({
    super.key,
    required this.widgetChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 0.1, color: greyColor)),
      child: widgetChild,
    );
  }
}

class PostBackground extends StatelessWidget {
  final dynamic backgroundSelected;
  final Function updateBackgroundSelected;

  const PostBackground(
      {super.key,
      this.backgroundSelected,
      required this.updateBackgroundSelected});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    dynamic listGroupBg =
        groupBy(backgroundPost, (obj) => obj['category_name']);
    List<dynamic> listKeysBg = listGroupBg.keys.toList();
    return SizedBox(
      height: size.height * 0.45,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  listKeysBg.length,
                  (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            listKeysBg[index],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 4,
                                crossAxisCount: 5,
                              ),
                              itemCount: listGroupBg[listKeysBg[index]].length,
                              itemBuilder: (context, indexBg) => BackgroundItem(
                                    updateBackgroundSelected:
                                        updateBackgroundSelected,
                                    backgroundSelected: backgroundSelected,
                                    background: listGroupBg[listKeysBg[index]]
                                        [indexBg],
                                  )),
                        ],
                      )),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundItem extends StatelessWidget {
  const BackgroundItem({
    super.key,
    required this.updateBackgroundSelected,
    required this.backgroundSelected,
    this.background,
  });

  final Function updateBackgroundSelected;
  final dynamic backgroundSelected;
  final dynamic background;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        updateBackgroundSelected(background);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 5),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
            border: backgroundSelected != null &&
                    backgroundSelected['id'] == background['id']
                ? Border.all(width: 1, color: primaryColor)
                : null,
            borderRadius: BorderRadius.circular(5)),
        child: WrapBackground(
            widgetChild: WrapBackground(
                widgetChild: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: ImageCacheRender(
              width: 26.0, height: 26.0, path: background['url']),
        ))),
      ),
    );
  }
}
