import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

class UnavailableDialog extends StatelessWidget {
  const UnavailableDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thông báo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tính năng đang phát triển. Vui lòng thử lại sau!!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonPrimary(
            handlePress: () async {
              Navigator.of(context).pop();
            },
            label: "OK",
          ),
        ],
      ),
    );
  }
}
