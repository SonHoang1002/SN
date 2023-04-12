import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheRender extends StatefulWidget {
  final String path;
  final double? width;
  final double? height;
  double? scale;

  ImageCacheRender(
      {Key? key, required this.path, this.width, this.height, this.scale})
      : super(key: key);

  @override
  State<ImageCacheRender> createState() => _ImageCacheRenderState();
}

class _ImageCacheRenderState extends State<ImageCacheRender> {
  final cacheManager = DefaultCacheManager();

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: UniqueKey(),
      cacheManager: cacheManager,
      cacheKey: widget.path,
      placeholder: (context, url) => Image.asset(
        'assets/grey.png',
        fit: BoxFit.cover,
      ),
      imageUrl: widget.path,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              widget.path,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
      fadeInDuration: Duration.zero,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => SizedBox(
        child: Image.asset(
          'assets/grey.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:transparent_image/transparent_image.dart';

// class ImageCacheRender extends StatefulWidget {
//   final String path;
//   final width;
//   final height;

//   const ImageCacheRender(
//       {Key? key, required this.path, this.width, this.height})
//       : super(key: key);

//   @override
//   State<ImageCacheRender> createState() => _ImageCacheRenderState();
// }
// class _ImageCacheRenderState extends State<ImageCacheRender> {
//   final cacheManager = DefaultCacheManager();

//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: widget.key??UniqueKey(),
//       child: CachedNetworkImage(
//         // key: UniqueKey(),
//         key: widget.key,
//         cacheManager: cacheManager,
//         cacheKey: widget.path,
//         placeholder: (context, url) => Image.asset(
//           'assets/grey.png',
//           width: widget.width,
//           height: widget.height,
//           fit: BoxFit.cover,
//         ),
//         imageUrl: widget.path,
//         imageBuilder: (context, imageProvider) => Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: CachedNetworkImageProvider(widget.path),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         fadeInDuration : Duration.zero,
//         width: widget.width,
//         height: widget.height,
//         fit: BoxFit.cover,
//         errorWidget: (context, url, error) => const SizedBox(
//           child: Text('Lỗi'),
//         ),
//       ),
//     );
//   }
// }
