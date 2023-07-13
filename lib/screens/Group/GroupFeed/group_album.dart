import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class GroupAlbum extends ConsumerStatefulWidget {
  final dynamic data;
  const GroupAlbum({Key? key, this.data}) : super(key: key);

  @override
  ConsumerState<GroupAlbum> createState() => _GroupAlbumState();
}

class _GroupAlbumState extends ConsumerState<GroupAlbum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Album'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: widget.data.length + 1, // Add +1 for the "Add Photo" icon
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return InkWell(
              onTap: () {},
              child: Image.asset('assets/groups/addAlbum.png'),
            );
          } else {
            final dataIndex = index - 1;
            return InkWell(
              onTap: () {
                // Handle the image tap
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.data[dataIndex]['media_attachment']['preview_url'],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
