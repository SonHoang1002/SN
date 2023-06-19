import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.0,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
    );
  }
}

class TitlePlaceholder extends StatelessWidget {
  final double width;

  const TitlePlaceholder({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: 12.0,
            color: Colors.white,
          ),
          const SizedBox(height: 8.0),
          Container(
            width: width,
            height: 12.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

enum ContentLineType {
  twoLines,
  threeLines,
}

class ContentPlaceholder extends StatelessWidget {
  final ContentLineType lineType;

  const ContentPlaceholder({
    Key? key,
    required this.lineType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96.0,
            height: 72.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
                if (lineType == ContentLineType.threeLines)
                  Container(
                    width: double.infinity,
                    height: 10.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8.0),
                  ),
                Container(
                  width: 100.0,
                  height: 10.0,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CollectionRowSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: width * 0.4,
          height: height > width ? height * 0.15 : height * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10.0),
        Container(
          width: width * 0.4,
          height: height > width ? height * 0.15 : height * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class CollectionListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              width: double.infinity,
              child: CollectionRowSkeleton(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              width: double.infinity,
              child: CollectionRowSkeleton(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              width: double.infinity,
              child: CollectionRowSkeleton(),
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
          ],
        ),
      ),
    );
  }
}

class SavedWaitingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 25.0),
            ContentPlaceholder(
              lineType: ContentLineType.threeLines,
            ),
            SizedBox(height: 40.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              width: double.infinity,
              child: CollectionRowSkeleton(),
            ),
            SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              width: double.infinity,
              child: CollectionRowSkeleton(),
            ),
          ],
        ),
      ),
    );
  }
}