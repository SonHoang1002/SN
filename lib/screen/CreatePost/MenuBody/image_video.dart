import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/model/file_model.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

class ImageVideo extends StatefulWidget {
  const ImageVideo({Key? key}) : super(key: key);

  @override
  State<ImageVideo> createState() => _ImageVideoState();
}

class _ImageVideoState extends State<ImageVideo> {
  List<FileModel> _files = <FileModel>[];
  FileModel? selectedModel;

  @override
  void initState() {
    super.initState();
    getImagesPath();
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath!) as List;
    _files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();

    if (_files.isNotEmpty) {
      setState(() {
        selectedModel = _files[3];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonPrimary(
                handlePress: () {},
                icon: const Icon(
                  FontAwesomeIcons.tableList,
                  size: 18,
                ),
                label: "Chọn bố cục hiển thị hình ảnh",
              ),
              const SizedBox(
                width: 12.0,
              ),
              InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.camera),
                  ))
            ],
          ),
          Expanded(
            child: selectedModel == null ||
                    (selectedModel != null && selectedModel!.files!.isEmpty)
                ? Container()
                : GridView.builder(
                    itemCount: selectedModel!.files!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (_, i) {
                      var file = selectedModel!.files![i];

                      return Image.file(
                        File(file),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
