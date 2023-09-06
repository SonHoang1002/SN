import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

class WatchProgram extends StatefulWidget {
  const WatchProgram({super.key});

  @override
  State<WatchProgram> createState() => _WatchProgramState();
}

class _WatchProgramState extends State<WatchProgram> {
  @override
    Widget build(BuildContext context) {
    return Center(
      child: buildTextContent("Chưa có chương trình nào !!", false,
          fontSize: 30, isCenterLeft: false),
    );
  }
}