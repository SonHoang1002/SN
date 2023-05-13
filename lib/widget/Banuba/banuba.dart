import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/widget/Banuba/audio_browser.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// The entry point for Audio Browser implementation
@pragma('vm:entry-point')
void audioBrowser() => runApp(AudioBrowserWidget());

class Banuba extends StatelessWidget {
  const Banuba({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Banuba Video Editor SDK Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    this.title = '',
  }) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// Set Banuba license token for Video Editor SDK
  static const String LICENSE_TOKEN =
      "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";

  static const channelName = 'startActivity/VideoEditorChannel';

  static const methodInitVideoEditor = 'InitBanubaVideoEditor';
  static const methodStartVideoEditor = 'StartBanubaVideoEditor';
  static const methodStartVideoEditorPIP = 'StartBanubaVideoEditorPIP';
  static const methodStartVideoEditorTrimmer = 'StartBanubaVideoEditorTrimmer';
  static const methodDemoPlayExportedVideo = 'PlayExportedVideo';

  static const errMissingExportResult = 'ERR_MISSING_EXPORT_RESULT';
  static const errStartPIPMissingVideo = 'ERR_START_PIP_MISSING_VIDEO';
  static const errStartTrimmerMissingVideo = 'ERR_START_TRIMMER_MISSING_VIDEO';
  static const errExportPlayMissingVideo = 'ERR_EXPORT_PLAY_MISSING_VIDEO';

  static const errEditorNotInitializedCode = 'ERR_VIDEO_EDITOR_NOT_INITIALIZED';
  static const errEditorNotInitializedMessage =
      'Banuba Video Editor SDK is not initialized: license token is unknown or incorrect.\nPlease check your license token or contact Banuba';
  static const errEditorLicenseRevokedCode = 'ERR_VIDEO_EDITOR_LICENSE_REVOKED';
  static const errEditorLicenseRevokedMessage =
      'License is revoked or expired. Please contact Banuba https://www.banuba.com/faq/kb-tickets/new';

  static const argExportedVideoFile = 'exportedVideoFilePath';
  static const argExportedVideoCoverPreviewPath =
      'exportedVideoCoverPreviewPath';

  static const platform = MethodChannel(channelName);

  String _errorMessage = '';

  Future<void> _initVideoEditor() async {
    await platform.invokeMethod(methodInitVideoEditor, LICENSE_TOKEN);
  }

  Future<void> _startVideoEditorDefault() async {
    try {
      await _initVideoEditor();

      final result = await platform.invokeMethod(methodStartVideoEditor);

      _handleExportResult(result);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  void _handleExportResult(dynamic result) {
    debugPrint('Export result = $result');

    // You can use any kind of export result passed from platform.
    // Map is used for this sample to demonstrate playing exported video file.
    if (result is Map) {
      final exportedVideoFilePath = result[argExportedVideoFile];

      // Use video cover preview to meet your requirements
      final exportedVideoCoverPreviewPath =
          result[argExportedVideoCoverPreviewPath];

      _showConfirmation(context, "Play exported video file?", () {
        platform.invokeMethod(
            methodDemoPlayExportedVideo, exportedVideoFilePath);
      });
    }
  }

  Future<void> _startVideoEditorPIP() async {
    try {
      await _initVideoEditor();

      // Use your implementation to provide correct video file path to start Video Editor SDK in PIP mode
      final ImagePicker _picker = ImagePicker();
      final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

      if (file == null) {
        debugPrint(
            'Cannot open video editor with PIP - video was not selected!');
      } else {
        debugPrint('Open video editor in pip with video = ${file.path}');
        final result =
            await platform.invokeMethod(methodStartVideoEditorPIP, file.path);

        _handleExportResult(result);
      }
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  Future<void> _startVideoEditorTrimmer() async {
    try {
      await _initVideoEditor();

      // Use your implementation to provide correct video file path to start Video Editor SDK in Trimmer mode
      final ImagePicker _picker = ImagePicker();
      final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);

      if (file == null) {
        debugPrint(
            'Cannot open video editor with Trimmer - video was not selected!');
      } else {
        debugPrint('Open video editor in trimmer with video = ${file.path}');
        final result = await platform.invokeMethod(
            methodStartVideoEditorTrimmer, file.path);

        _handleExportResult(result);
      }
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'The sample demonstrates how to run Banuba Video Editor SDK with Flutter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Linkify(
                text: _errorMessage,
                onOpen: (link) async {
                  if (await canLaunchUrlString(link.url)) {
                    await launchUrlString(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: const EdgeInsets.all(12.0),
              splashColor: Colors.blueAccent,
              minWidth: 240,
              onPressed: () => _startVideoEditorDefault(),
              child: const Text(
                'Open Video Editor - Default',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            SizedBox(height: 24),
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: const EdgeInsets.all(16.0),
              splashColor: Colors.greenAccent,
              minWidth: 240,
              onPressed: () => _startVideoEditorPIP(),
              child: const Text(
                'Open Video Editor - PIP',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            SizedBox(height: 24),
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: const EdgeInsets.all(16.0),
              splashColor: Colors.redAccent,
              minWidth: 240,
              onPressed: () => _startVideoEditorTrimmer(),
              child: const Text(
                'Open Video Editor - Trimmer',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handle exceptions thrown on Android, iOS platform while opening Video Editor SDK
  void _handlePlatformException(PlatformException exception) {
    debugPrint("Error: '${exception.message}'.");

    String errorMessage = '';
    switch (exception.code) {
      case errEditorLicenseRevokedCode:
        errorMessage = errEditorLicenseRevokedMessage;
        break;
      case errEditorNotInitializedCode:
        errorMessage = errEditorNotInitializedMessage;
        break;
      default:
        errorMessage = 'unknown error';
    }

    _errorMessage = errorMessage;
    setState(() {});
  }

  void _showConfirmation(
      BuildContext context, String message, VoidCallback block) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          MaterialButton(
            color: Colors.red,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: const EdgeInsets.all(12.0),
            splashColor: Colors.redAccent,
            onPressed: () => {Navigator.pop(context)},
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          MaterialButton(
            color: Colors.green,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: const EdgeInsets.all(12.0),
            splashColor: Colors.greenAccent,
            onPressed: () {
              Navigator.pop(context);
              block.call();
            },
            child: const Text(
              'Ok',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
