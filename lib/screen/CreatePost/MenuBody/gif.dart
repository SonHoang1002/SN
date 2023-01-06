import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/gif.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class Gif extends StatelessWidget {
  const Gif({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(8.0), child: const SearchInput()),
        Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 2,
                ),
                itemCount: gifs.length,
                itemBuilder: (context, index) => ImageCacheRender(
                    path: gifs[index]['images']['original']['url'])))
      ],
    );
  }
}
