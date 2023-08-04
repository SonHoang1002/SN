
// import 'package:chewie/chewie.dart';
// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:social_network_app_mobile/providers/video_repository.dart';
// import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';
// import 'package:social_network_app_mobile/theme/colors.dart';
// import 'package:social_network_app_mobile/widgets/FeedVideo/video_custom_control.dart';
// import 'package:social_network_app_mobile/widgets/image_cache.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// class VideoPlayerHasController extends ConsumerStatefulWidget {
//   final dynamic media;
//   final Widget? overlayWidget;
//   final double? aspectRatio;
//   final bool? hasDispose;
//   final String? type;
//   final ValueNotifier<int>? videoPositionNotifier;
//   final bool? isHiddenControl;
//   final double? timeStart;
//   final Function? handleDoubleTapAction;
//   final Function? handleTapAction;
//   final bool? isFocus;

//   const VideoPlayerHasController(
//       {Key? key,
//       this.media,
//       this.type,
//       this.handleDoubleTapAction,
//       this.overlayWidget,
//       this.aspectRatio,
//       this.hasDispose,
//       this.isHiddenControl,
//       this.timeStart,
//       this.videoPositionNotifier,
//       this.handleTapAction,
//       this.isFocus})
//       : super(key: key);

//   @override
//   ConsumerState<VideoPlayerHasController> createState() =>
//       _VideoPlayerHasControllerState();
// }

// class _VideoPlayerHasControllerState
//     extends ConsumerState<VideoPlayerHasController>
//     with WidgetsBindingObserver {
//   bool isVisible = false;
//   BetterState? betterPlayer;
//   VideoPlayerController? videoPlayerController;
//   ChewieController? chewieController;
//   bool isPlaying = true;
//   GlobalKey globalKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     betterPlayer = ref.read(betterPlayerControllerProvider);
//     if (betterPlayer!.videoId == widget.media?['id']) {
//       videoPlayerController = betterPlayer!.videoPlayerController;
//       chewieController = betterPlayer!.chewieController;
//     } else {
//       videoPlayerController = VideoPlayerController.networkUrl(
//         Uri.parse(widget.media['remote_url'] ?? widget.media['url']),
//         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
//       )..initialize().then((value) {
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             if (mounted) {
//               setState(() {
//                 chewieController = ChewieController(
//                   placeholder: Container(
//                       decoration: BoxDecoration(
//                     color: Color(int.parse(
//                         '0xFF${widget.media?['meta']?['small']?['average_color'].substring(1)}')),
//                   )),
//                   showControlsOnInitialize: false,
//                   videoPlayerController: videoPlayerController!,
//                   showControls: true,
//                   customControls: const CustomControlVideo(
//                     backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
//                     iconColor: Color.fromARGB(255, 200, 200, 200),
//                   ), 
//                   aspectRatio: videoPlayerController!.value.aspectRatio,
//                   progressIndicatorDelay: const Duration(seconds: 10)
//                 );
//               });
//             }
//           });
//         });
//     }
//   }

//   @override
//   void dispose() {
//     // WidgetsBinding.instance.removeObserver(this);

//     if (betterPlayer!.videoPlayerController != null &&
//         betterPlayer!.videoId != widget.media?['id']) {
//       chewieController!.pause();
//       videoPlayerController?.dispose();
//       chewieController?.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (widget.isHiddenControl != null && !widget.isHiddenControl!) {
//       setState(() {
//         chewieController = ChewieController(
//             placeholder: Container(
//                 decoration: BoxDecoration(
//               color: Color(int.parse(
//                   '0xFF${(widget.media?['meta']?['small']?['average_color']).substring(1)}')),
//             )),
//             showControlsOnInitialize: true,
//             videoPlayerController: videoPlayerController!,
//             aspectRatio: videoPlayerController!.value.aspectRatio,
//             showControls: true, 
//             customControls: const CustomControlVideo(
//               backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
//               iconColor: Color.fromARGB(255, 200, 200, 200),
//             ),
//             progressIndicatorDelay: const Duration(seconds: 10));
//       });
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.detached) {
//       if (chewieController != null && chewieController!.isPlaying) {
//         chewieController!.pause();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     dynamic selectedVideo = ref.watch(selectedVideoProvider);
//     // Size? sizeOfVideo;
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//     //   sizeOfVideo = globalKey.currentContext?.size;
//     // });
//     return AspectRatio(
//       aspectRatio: videoPlayerController!.value.aspectRatio > 1
//           ? 1
//           : videoPlayerController!.value.aspectRatio,
//       child: VisibilityDetector(
//           onVisibilityChanged: (visibilityInfo) {
//             // if (widget.isFocus!) {
//             if (isPlaying && visibilityInfo.visibleFraction > 0.7) {
//               setState(() {
//                 isVisible = visibilityInfo.visibleFraction > 0.7;
//                 if (mounted) {
//                   if (chewieController == null) return;
//                   if (isVisible) {
//                     if (selectedVideo == null) {
//                       chewieController?.videoPlayerController.play();
//                     } else {
//                       chewieController?.videoPlayerController.pause();
//                     }
//                   }
//                 }
//               });
//             } else {
//               chewieController?.videoPlayerController.pause();
//             }
//             // }
//           },
//           key: Key(widget.media['id'] ?? "111"),
//           child: Stack(
//             children: [
//               chewieController != null
//                   ? AspectRatio(
//                       key: globalKey,
//                       aspectRatio: videoPlayerController!.value.aspectRatio > 1
//                           ? 1
//                           : videoPlayerController!.value.aspectRatio,
//                       // (widget.type == postWatchDetail ||
//                       //         chewieController!
//                       //                 .videoPlayerController.value.aspectRatio >=
//                       //             3 / 4)
//                       //     ? chewieController!
//                       //         .videoPlayerController.value.aspectRatio
//                       // : 3 / 4,
//                       child: chewieController!
//                               .videoPlayerController.value.isInitialized
//                           ? selectedVideo != null &&
//                                   widget.type != 'miniPlayer' &&
//                                   widget.media['id'] ==
//                                       (selectedVideo?['media_attachments']?[0]
//                                           ?['id'])
//                               ? Stack(
//                                   children: [
//                                     Positioned.fill(
//                                       child: ExtendedImage.network(
//                                         ((widget.media?['preview_url']) ??
//                                             (widget
//                                                 .media?['preview_remote_url'])),
//                                         width: MediaQuery.sizeOf(context).width,
//                                         // height: sizeOfVideo?.height,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     Positioned.fill(
//                                         child: Container(
//                                       color: Colors.black.withOpacity(0.4),
//                                       child: const Center(
//                                         child: Text("Đang phát",
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 color: white,
//                                                 fontWeight: FontWeight.w500)),
//                                       ),
//                                     ))
//                                   ],
//                                 )
//                               : Stack(
//                                   children: [
//                                     Material(
//                                         child: Chewie(
//                                             controller: chewieController!)),
//                                     widget.handleTapAction != null
//                                         ? Positioned.fill(
//                                             child: GestureDetector(onTap: () {
//                                             chewieController!
//                                                 .videoPlayerController
//                                                 .pause();
//                                             widget.handleTapAction!();
//                                           }))
//                                         : const SizedBox(),
//                                     // Positioned.fill(
//                                     //     child: GestureDetector(
//                                     //       onTap: () {
//                                     //         if (widget.handleTapAction !=
//                                     //             null) {
//                                     //           widget.handleTapAction!();
//                                     //         } else {
//                                     //           if (betterPlayer!.videoId !=
//                                     //               (widget.media?['id'])) {
//                                     //             ref
//                                     //                 .read(
//                                     //                     betterPlayerControllerProvider
//                                     //                         .notifier)
//                                     //                 .initializeBetterPlayerController(
//                                     //                     (widget
//                                     //                         .media?['id']),
//                                     //                     videoPlayerController!,
//                                     //                     chewieController!);
//                                     //           }
//                                     //           setState(() {
//                                     //             isPlaying = !isPlaying;
//                                     //           });
//                                     //           // if (widget.isFocus!) {
//                                     //           if (isPlaying) {
//                                     //             chewieController!
//                                     //                 .videoPlayerController
//                                     //                 .play();
//                                     //           } else {
//                                     //             chewieController!
//                                     //                 .videoPlayerController
//                                     //                 .pause();
//                                     //           }
//                                     //         }
//                                     //         // }
//                                     //       },
//                                     //       onDoubleTap: () {
//                                     //         if (widget
//                                     //                 .handleDoubleTapAction !=
//                                     //             null) {
//                                     //           widget
//                                     //               .handleDoubleTapAction!();
//                                     //         }
//                                     //       },
//                                     //     ))
//                                   ],
//                                 )
//                           : Positioned.fill(
//                               child: ExtendedImage.network(
//                                 ((widget.media?['preview_url']) ??
//                                     (widget.media?['preview_remote_url'])),
//                                 width: MediaQuery.sizeOf(context).width,
//                                 // height: sizeOfVideo?.height,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                     )
//                   : Positioned.fill(
//                       child: ExtendedImage.network(
//                         ((widget.media?['preview_url']) ??
//                             (widget.media?['preview_remote_url'])),
//                         width: MediaQuery.sizeOf(context).width,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//               // const Positioned.fill(
//               //   child: Align(
//               //       alignment: Alignment.center,
//               //       child: Icon(
//               //         FontAwesomeIcons.play,
//               //         color: Colors.green,
//               //         size: 40,
//               //       )),
//               // ),
//             ],
//           )),
//     );
//   }
// }