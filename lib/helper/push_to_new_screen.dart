import 'package:flutter/material.dart';

pushToNextScreen(BuildContext context, Widget newScreen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => newScreen));
}

pushAndReplaceToNextScreen(BuildContext context, Widget newScreen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => newScreen));
}

popToPreviousScreen(BuildContext context) {
  Navigator.of(context).pop();
}
