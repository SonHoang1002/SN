import 'package:flutter/material.dart';

class ReactionMessageContent with ChangeNotifier {
  String reactionContent = "";
  setMessageContent(String newStatus) {
    reactionContent = newStatus;
    notifyListeners();
  }

  get getMessageContent => reactionContent;
}
