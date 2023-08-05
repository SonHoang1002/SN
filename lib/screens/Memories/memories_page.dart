import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/Memories/items/memories_header_banner.dart';
import 'package:social_network_app_mobile/screens/Memories/items/memories_layout.dart';
import 'package:social_network_app_mobile/screens/Memories/items/memories_new_post.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class MemoriesPage extends StatefulWidget {
  const MemoriesPage({super.key});
  @override
  State<MemoriesPage> createState() => _MemoriesPageState();
}

class _MemoriesPageState extends State<MemoriesPage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          PageHeader(),
          CrossBar(
            height: 10,
          ),
          LayoutsArea(),
          CrossBar(
            height: 10,
          ),
          NewPostArea(),
        ],
      ),
    );
  }
}
