import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class EventCard extends StatefulWidget {
  final dynamic event;
  const EventCard({Key? key, this.event}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventCartdState createState() => _EventCartdState();
}

class _EventCartdState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: eventData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.red[50],
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          ImageCacheRender(
                            path: eventData[index]['banner']['preview_url'],
                            height: MediaQuery.of(context).size.height - 737,
                            width: MediaQuery.of(context).size.width,
                          ),
                          Text(
                            eventData[index]['title'],
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                    // return Container(
                    //   margin: const EdgeInsets.only(left: 10.0),
                    //   child: Card(
                    //     elevation: 0,
                    //     shape: const RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(12)),
                    //     ),
                    //     child: Column(children: [
                    //       ClipRRect(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //         child: ImageCacheRender(
                    //           path: eventData[index]['banner']['preview_url'],
                    //           width: 70.0,
                    //           height: 70.0,
                    //         ),
                    //       ),
                    //       Positioned(
                    //           bottom: 2,
                    //           left: 2,
                    //           child: SizedBox(
                    //               width: 64,
                    //               child: Text(
                    //                 eventData[index]['title'],
                    //                 maxLines: 2,
                    //                 style: const TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: 11,
                    //                     fontWeight: FontWeight.w700,
                    //                     overflow: TextOverflow.ellipsis),
                    //               )))
                    //     ]),
                    //   ),
                    // );
                  })),
        ],
      ),
    ));
  }
}
