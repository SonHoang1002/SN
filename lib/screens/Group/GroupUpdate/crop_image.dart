import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/CustomCropImage/crop_your_image.dart';

import '../../../widgets/appbar_title.dart';

class CropUpdateBanner extends StatefulWidget {
  final dynamic image;
  final Function(dynamic) handleGetImage;

  const CropUpdateBanner({Key? key, this.image, required this.handleGetImage})
      : super(key: key);

  @override
  State<CropUpdateBanner> createState() => _CropUpdateBannerState();
}

class _CropUpdateBannerState extends State<CropUpdateBanner> {
  late final CropController _cropController;

  @override
  void initState() {
    super.initState();
    _cropController = CropController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Đặt lại vị trí'),
        actions: [
          TextButton(
            onPressed: () {
              _cropController.crop();
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
      body: Container(
        color: blackColor,
        width: double.infinity,
        height: double.infinity,
        child: Crop(
          aspectRatio: 16 / 9,
          withCircleUi: false,
          initialSize: 1,
          cornerDotBuilder: (size, edgeAlignment) => const SizedBox.shrink(),
          interactive: false,
          fixArea: false,
          image: widget.image!,
          onCropped: (value) {
            widget.handleGetImage(value);
          },
          controller: _cropController,
        ),
      ),
    );
  }
}
