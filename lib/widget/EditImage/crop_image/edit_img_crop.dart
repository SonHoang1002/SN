import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/CustomCropImage/crop_your_image.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

import '../../../widget/appbar_title.dart';
import '../../../widget/back_icon_appbar.dart';

class CreateEvents extends ConsumerStatefulWidget {
  const CreateEvents({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends ConsumerState<CreateEvents> {
  TextEditingController nameController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future<Uint8List> _load(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  File uint8ListToFile(Uint8List data, String fileName) {
    final buffer = data.buffer;
    File file = File(fileName);
    file.writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file;
  }

  // Future<void> _getImage() {
  //   final pickedFileFuture = ImagePicker()
  //       // ignore: deprecated_member_use
  //       .getImage(source: ImageSource.gallery, imageQuality: 100);
  //   pickedFileFuture.then((pickedFile) {
  //     if (pickedFile != null) {
  //       final imageDataFuture = _load(File(pickedFile.path));
  //       imageDataFuture.then((imageData) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => EditImageCrop(
  //               image: imageData,
  //               onChange: (value) {
  //                 if (mounted) {
  //                   setState(() {
  //                     files = uint8ListToFile(value, pickedFile.path);
  //                     isCropping = false;
  //                   });
  //                 }
  //               },
  //             ),
  //           ),
  //         ).then((loading) {
  //           if (mounted) {
  //             setState(() {
  //               isCropping = loading;
  //             });
  //           }
  //         });
  //       });
  //     }
  //   });
  //   return Future.value();
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class EditImageCrop extends StatefulWidget {
  final Function(Uint8List)? onChange;
  final Uint8List? image;
  final Function? completeFunction;

  const EditImageCrop({
    required this.image,
    this.onChange,
    this.completeFunction,
    super.key,
  });

  @override
  State<EditImageCrop> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<EditImageCrop> {
  final _cropController = CropController();
  final _loadingImage = false;
  bool _isCropping = false;
  Uint8List? _croppedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: ""),
            ButtonPrimary(
              label: "Xong",
              handlePress: () async {
                _cropController.crop();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: Container(
        color: blackColor,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Visibility(
            visible: !_loadingImage && !_isCropping,
            replacement: const CircularProgressIndicator(),
            child: widget.image != null
                ? Crop(
                    controller: _cropController,
                    image: widget.image!,
                    onCropped: (croppedData) {
                      widget.completeFunction != null
                          ? widget.completeFunction!(croppedData)
                          : null;
                    },
                    // aspectRatio: 16 / 9,
                    // withCircleUi: false,
                    // initialSize: 1,
                    // cornerDotBuilder: (size, edgeAlignment) =>
                    //     const SizedBox.shrink(),
                    // interactive: false,
                    // fixArea: false,
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
