import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AddtionalInformationEventWidget extends StatelessWidget {
  const AddtionalInformationEventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
Widget _buildAddtionalInformation(BuildContext context, List<String> message) {
  return Container(
      height: 77,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: message[0],
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            )),
        message.length == 2
            ? TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                 
                  },
                text: message[1],
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))
            : TextSpan(),
      ])));
}
