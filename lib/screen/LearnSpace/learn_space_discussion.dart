import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';

class LearnSpaceDiscusstion extends ConsumerStatefulWidget {
  const LearnSpaceDiscusstion({super.key});

  @override
  ConsumerState<LearnSpaceDiscusstion> createState() =>
      _LearnSpaceDiscusstionState();
}

class _LearnSpaceDiscusstionState extends ConsumerState<LearnSpaceDiscusstion> {
  @override
  Widget build(BuildContext context) {
    return const CreatePostButton();
  }
}
