import 'package:flutter/cupertino.dart';

import '../../../apis/config.dart';
import 'package:social_network_app_mobile/apis/emoji_sticky_api.dart';
import '../../../widgets/image_cache.dart';
import '../../../widgets/search_input.dart';

class Gif extends StatefulWidget {
  final Function handleUpdateData;

  const Gif({Key? key, required this.handleUpdateData}) : super(key: key);

  @override
  State<Gif> createState() => _GifState();
}

class _GifState extends State<Gif> {
  List gifs = [];
  bool isLoadingGif = true;

  @override
  void initState() {
    if (!mounted) return;

    super.initState();
    fetchDataGif({"offset": 0, "api_key": gifKey, "limit": 20});
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchDataGif(params) async {
    setState(() {
      isLoadingGif = true;
    });
    var response = await EmojiStickyApi().fetchDataGifApi(params);
    if (response != null) {
      if (mounted) {
        setState(() {
          isLoadingGif = false;
          gifs = response["data"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(margin: const EdgeInsets.all(8.0), child: SearchInput()),
        isLoadingGif
            ? Container(
                margin: const EdgeInsets.only(top: 20),
                child: const CupertinoActivityIndicator(),
              )
            : Expanded(
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      crossAxisCount: 2,
                    ),
                    itemCount: gifs.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            widget.handleUpdateData('update_gif',
                                gifs[index]['images']['original']['url']);
                            Navigator.of(context).pop();
                          },
                          child: ImageCacheRender(
                              path: gifs[index]['images']['original']['url']),
                        )))
      ],
    );
  }
}
