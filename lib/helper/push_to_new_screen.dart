import 'package:flutter/material.dart';

pushToNextScreen(BuildContext context, Widget newScreen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => newScreen));
}

pushAndReplaceToNextScreen(BuildContext context, Widget newScreen) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => newScreen));
}
pushAndReplaceNamedToNextScreen(BuildContext context, String newRouteLink) {
  Navigator.of(context)
      .pushReplacementNamed(newRouteLink);
}
popToPreviousScreen(BuildContext context) {
  Navigator.of(context).pop();
}
