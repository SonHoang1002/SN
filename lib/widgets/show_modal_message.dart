import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title),
      duration: const Duration(milliseconds: 1500),
      width: 300.0, // Width of the SnackBar.
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0, vertical: 16.0 // Inner padding for SnackBar content.
          ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}
