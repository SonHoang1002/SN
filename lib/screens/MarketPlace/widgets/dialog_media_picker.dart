import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart'; 

void dialogMediaSource(BuildContext context, Function function) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text("Ảnh từ Camera"),
                  onTap: () {
                    popToPreviousScreen(context);
                    function(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text("Ảnh từ thư viện"),
                  onTap: () {
                    popToPreviousScreen(context);
                    function(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      });
}
