import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:social_network_app_mobile/apis/common_api.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';

class PagePickFrames extends StatefulWidget {
  final Function handleAction;
  const PagePickFrames({Key? key, required this.handleAction})
      : super(key: key);

  @override
  State<PagePickFrames> createState() => _PagePickFramesState();
}

class _PagePickFramesState extends State<PagePickFrames> {
  List frames = [];
  bool isLoading = false;

  @override
  initState() {
    super.initState();

    if (mounted && frames.isEmpty) {
      fetchDataFrames(null);
    }
  }

  fetchDataFrames(params) async {
    setState(() {
      isLoading = true;
    });
    var response = await CommonApi().fetchDataFrames(params);
    if (response != null) {
      setState(() {
        isLoading = false;
        frames = response;
      });
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SearchInput(),
            const SizedBox(
              height: 8.0,
            ),
            Column(
              children: List.generate(
                  frames.length,
                  (index) => InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () {
                          Navigator.pop(context);
                          widget.handleAction('frame', frames[index]);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ImageCacheRender(
                                  width: 30.0,
                                  height: 30.0,
                                  path: frames[index]['url'],
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width - 70,
                                  child: Text(frames[index]['name']))
                            ],
                          ),
                        ),
                      )),
            ),
            isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
