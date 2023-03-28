import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class CreateEvent extends ConsumerStatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends ConsumerState<CreateEvent> {
  final cropKey = GlobalKey<_CreateEventState>();
  File? _image;
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            BackIconAppbar(),
          ],
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _getImage,
            child: Text('Chọn ảnh'),
          ),
          _image == null
              ? Text('Không có ảnh được chọn')
              : Container(
            width: 300,
            height: 300,
            child: Crop(
              key: cropKey,
              image: FileImage(_image!),
              aspectRatio: 16 / 9,
              alwaysShowGrid: false,
            ),
          ),
        ],
      ),
    );
  }
}
