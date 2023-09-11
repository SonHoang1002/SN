
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateMoment/moment_cover.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GalleryDevice/gallery_device.dart';
// import 'package:video_compress/video_compress.dart';

class CameraMomentController extends StatefulWidget {
  const CameraMomentController({Key? key}) : super(key: key);

  @override
  State<CameraMomentController> createState() => _CameraMomentControllerState();
}

class _CameraMomentControllerState extends State<CameraMomentController> {
  List<CameraDescription> cameras = [];
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();

    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);

    await controller!.initialize();
    setState(() {});
  }

  void switchCamera() async {
    var newCamera =
        controller!.description == cameras[0] ? cameras[1] : cameras[0];

    controller = CameraController(newCamera, ResolutionPreset.ultraHigh);

    await controller!.initialize();
    setState(() {});
  }

  startRecording() async {
    await controller!.startVideoRecording();
  }

  stopRecording() async {
    var navigate = Navigator.of(context);
    XFile videoFile = await controller!.stopVideoRecording();
    if (videoFile.path.isNotEmpty) {
      navigate.pushReplacement(CupertinoPageRoute(
          builder: (context) => MomentCover(
                videoPath: videoFile.path,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return controller != null && controller!.value.isInitialized
        ? SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: CameraPreview(controller!)),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: BottomAction(
                          startRecording: startRecording,
                          stopRecording: stopRecording)),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              CupertinoIcons.clear,
                              color: white,
                              size: 30,
                            ),
                          ),
                          IconButton(
                            onPressed: switchCamera,
                            icon: const Icon(
                              CupertinoIcons.camera_rotate_fill,
                              color: white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : const Center(child: CupertinoActivityIndicator());
  }
}

class BottomAction extends StatefulWidget {
  final Function startRecording;
  final Function stopRecording;
  const BottomAction({
    super.key,
    required this.startRecording,
    required this.stopRecording,
  });

  @override
  State<BottomAction> createState() => _BottomActionState();
}

class _BottomActionState extends State<BottomAction>
    with SingleTickerProviderStateMixin {
  bool isRecording = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Future<File> convertVideo(Uint8List videoData) async {
  //   final directory = await getTemporaryDirectory();
  //   final videoFile = File('${directory.path}/video.mp4');
  //   await videoFile.writeAsBytes(videoData, mode: FileMode.write);
  //   return videoFile;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              if (!isRecording) {
                widget.startRecording();
              } else {
                widget.stopRecording();
              }
              setState(() {
                isRecording = !isRecording;
                isRecording
                    ? _animationController.forward()
                    : _animationController.reverse();
              });
            },
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 65 + (10 * _animationController.value),
                  height: 65 + (10 * _animationController.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? Colors.red : Colors.white,
                  ),
                  child: Center(
                    child: Icon(
                      isRecording ? Icons.stop : Icons.fiber_manual_record,
                      color: isRecording ? Colors.white : Colors.red,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => GalleryDevice(
                          handleAction: (dynamic asset) async {
                            final navigate = Navigator.of(context);
                            // File videoFile = await convertVideo(asset!);
                            navigate.push(CupertinoPageRoute(
                                builder: (context) => MomentCover(
                                    videoPath: asset!['file'].path,
                                    videoPathUpload: asset!['filePath'])));
                          },
                          handleClose: () {})));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: white, width: 1),
                      borderRadius: BorderRadius.circular(4),
                      image: const DecorationImage(
                          image: AssetImage(
                            'assets/image_upload.png',
                          ),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Text('Tải lên',
                    style: customIbmPlexSans(const TextStyle(
                        color: white, fontWeight: FontWeight.w500)))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
