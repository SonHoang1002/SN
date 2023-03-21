// import 'dart:async';
//
// import 'package:flutter/material.dart';
// // import 'package:helpers/helpers/misc.dart';
// // import 'package:helpers/helpers/print.dart';
// // import 'package:native_device_orientation/native_device_orientation.dart';
// // import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/bloc/controller.dart';
// // import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/entities/styles/video_viewer.dart';
// // import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/entities/subtitle.dart';
// // import 'package:social_network_app_mobile/widget/videoViewer/lib/domain/entities/video_source.dart';
// // import 'package:social_network_app_mobile/widget/videoViewer/lib/video_viewer.dart';
//
// class UsingVideoControllerExample extends StatefulWidget {
//   final String path;
//   const UsingVideoControllerExample({super.key, required this.path});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _UsingVideoControllerExampleState createState() =>
//       _UsingVideoControllerExampleState();
// }
//
// class _UsingVideoControllerExampleState
//     extends State<UsingVideoControllerExample> {
//   final VideoViewerController controller = VideoViewerController();
//
//   @override
//   Widget build(BuildContext context) {
//     return VideoViewerOrientation(
//       controller: controller,
//       child: VideoViewer(
//         controller: controller,
//         onFullscreenFixLandscape: false,
//         style: VideoViewerStyle(
//           thumbnail: Image.network(
//             "https://play-lh.googleusercontent.com/aA2iky4PH0REWCcPs9Qym2X7e9koaa1RtY-nKkXQsDVU6Ph25_9GkvVuyhS72bwKhN1P",
//           ),
//         ),
//         source: {
//           "1080p": VideoSource(video: VideoPlayerController.network(widget.path)),
//         },
//       ),
//     );
//   }
//
//   VideoPlayerController getVideoPlayer() => controller.controller;
//   String? getActiveSourceNameName() => controller.activeSourceName;
//   String? getActiveCaption() => controller.activeCaption;
//   bool isFullScreen() => controller.isFullScreen;
//   bool isBuffering() => controller.isBuffering;
//   bool isPlaying() => controller.isPlaying;
// }
//
// class VideoViewerOrientation extends StatefulWidget {
//   const VideoViewerOrientation({
//     Key? key,
//     required this.child,
//     required this.controller,
//   }) : super(key: key);
//
//   final Widget child;
//   final VideoViewerController controller;
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _VideoViewerOrientationState createState() => _VideoViewerOrientationState();
// }
//
// class _VideoViewerOrientationState extends State<VideoViewerOrientation> {
//   late StreamSubscription<NativeDeviceOrientation> _subscription;
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     _subscription = NativeDeviceOrientationCommunicator()
//         .onOrientationChanged()
//         .listen(_onOrientationChanged);
//     super.initState();
//   }
//
//   void _onOrientationChanged(NativeDeviceOrientation orientation) {
//     final bool isFullScreen = widget.controller.isFullScreen;
//     final bool isLandscape =
//         orientation == NativeDeviceOrientation.landscapeLeft ||
//             orientation == NativeDeviceOrientation.landscapeRight;
//     if (!isFullScreen && isLandscape) {
//       printGreen("OPEN FULLSCREEN");
//       widget.controller.openFullScreen();
//     } else if (isFullScreen && !isLandscape) {
//       printRed("CLOSING FULLSCREEN");
//       widget.controller.closeFullScreen();
//       Misc.delayed(300, () {
//         Misc.setSystemOverlay(SystemOverlay.values);
//         Misc.setSystemOrientation(SystemOrientation.values);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) => widget.child;
// }
