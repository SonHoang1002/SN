import 'package:flutter/material.dart';

buildSnackBar(BuildContext context, String title) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(title),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
        margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9)))),
  );
}
