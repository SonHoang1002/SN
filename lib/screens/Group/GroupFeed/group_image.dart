import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class GroupImage extends ConsumerStatefulWidget {
  const GroupImage({super.key});

  @override
  ConsumerState<GroupImage> createState() => _GroupImageState();
}

class _GroupImageState extends ConsumerState<GroupImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Ảnh'),
      ),
      body: const Center(
        child: Text('Group Image'),
      ),
    );
  }
}
