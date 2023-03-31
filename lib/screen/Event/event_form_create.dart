import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/widget/CropImage/src/controllers/controller.dart';


import '../../widget/CropImage/src/painters/solid_path_painter.dart';
import '../../widget/CropImage/src/widgets/custom_image_crop_widget.dart';

class CreateEvent extends StatefulWidget {
  final String title;

  const CreateEvent({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CreateEvent> {
  late CustomImageCropController controller;
  File? _image;
  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        brightness: Brightness.dark,
      ),
      body: Column(
        children: [
          _image == null
              ? const Text('Không có ảnh được chọn')
              : Expanded(
                  child: CustomImageCrop(
                    cropController: controller,
                    shape: CustomCropShape.Square,
                    canRotate: false,
                    canMove: true,
                    canScale: false,
                    drawPath: SolidCropPathPainter.drawPath,
                    image: FileImage(
                        _image!),
                  ),
                ),
          Row(
            children: [
              ElevatedButton(
                onPressed: _getImage,
                child: Text('Chọn ảnh'),
              ),
              IconButton(
                icon: const Icon(Icons.crop),
                onPressed: () async {
                  final image = await controller.onCropImage();
                  if (image != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ResultScreen(image: image)));
                  }
                },
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final MemoryImage image;

  const ResultScreen({
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Image(
              image: image,
            ),
            ElevatedButton(
              child: const Text('Back'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
