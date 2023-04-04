import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/widget/CustomCropImage/crop_your_image.dart';

class CreateEvents extends StatefulWidget {
  const CreateEvents({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CropSampleState createState() => _CropSampleState();
}

class _CropSampleState extends State<CreateEvents> {
  final _cropController = CropController();
  final _imageDataList = <Uint8List>[];

  var _loadingImage = false;
  final _isSumbnail = false;
  var _isCropping = false;
  final _isCircleUi = false;
  Uint8List? _croppedData;
  var _statusText = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadAllImages() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageData = await _load(File(pickedFile.path));
      setState(() {
        _imageDataList.add(imageData);
        _loadingImage = false;
      });
    }
  }

  Future<Uint8List> _load(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Visibility(
          visible: !_loadingImage && !_isCropping,
          replacement: const CircularProgressIndicator(),
          child: Column(
            children: [
              Expanded(
                child: Visibility(
                  visible: _croppedData == null,
                  replacement: Center(
                    child: _croppedData == null
                        ? const SizedBox.shrink()
                        : Image.memory(_croppedData!),
                  ),
                  child: Stack(
                    children: [
                      if (_imageDataList.isNotEmpty) ...[
                        Crop(
                          controller: _cropController,
                          image: _imageDataList.last,
                          onCropped: (croppedData) {
                            setState(() {
                              _croppedData = croppedData;
                              _isCropping = false;
                            });
                          },
                          aspectRatio: 16 / 9,
                          withCircleUi: false,
                          onStatusChanged: (status) => setState(() {
                            _statusText = <CropStatus, String>{
                                  CropStatus.nothing: 'Crop has no image data',
                                  CropStatus.loading:
                                      'Crop is now loading given image',
                                  CropStatus.ready: 'Crop is now ready!',
                                  CropStatus.cropping:
                                      'Crop is now cropping image',
                                }[status] ??
                                '';
                          }),
                          initialSize: null,
                          cornerDotBuilder: (size, edgeAlignment) =>
                              const SizedBox.shrink(),
                          interactive: false,
                          fixArea: false,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_croppedData == null)
                Material(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isCropping = true;
                              });
                              _cropController.crop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('CROP IT!'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _loadAllImages();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('CROP IT!'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(_statusText),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
