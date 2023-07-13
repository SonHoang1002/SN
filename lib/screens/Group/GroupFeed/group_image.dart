import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class GroupImage extends ConsumerStatefulWidget {
  final dynamic data;
  const GroupImage({super.key, this.data});

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
        body: Container(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.data[index]['preview_url']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
