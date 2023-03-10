import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';

import 'flick_multiple_manager.dart';

class FeedPlayerPortraitControls extends StatelessWidget {
  const FeedPlayerPortraitControls(
      {Key? key, this.flickMultiManager, this.flickManager, this.type})
      : super(key: key);

  final FlickMultiManager? flickMultiManager;
  final FlickManager? flickManager;
  final String? type;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          type == postMoment
              ? const SizedBox()
              : FlickAutoHideChild(
                  autoHide: false,
                  showIfVideoNotInitialized: false,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const FlickLeftDuration(),
                    ),
                  ),
                ),
          Expanded(
            child: FlickToggleSoundAction(
              toggleMute: () {
                flickMultiManager?.toggleMute();
                displayManager.handleShowPlayerControls();
              },
              child: const FlickSeekVideoAction(
                child: Center(child: FlickVideoBuffer()),
              ),
            ),
          ),
          type == postMoment
              ? const SizedBox()
              : type == 'showFullScreen'
                  ? FlickAutoHideChild(
                      autoHide: false,
                      showIfVideoNotInitialized: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FlickSoundToggle(
                              toggleMute: () => flickMultiManager?.toggleMute(),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const FlickFullScreenToggle(),
                          ),
                        ],
                      ),
                    )
                  : FlickAutoHideChild(
                      autoHide: false,
                      showIfVideoNotInitialized: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FlickSoundToggle(
                              toggleMute: () => flickMultiManager?.toggleMute(),
                              color: Colors.white,
                            ),
                          ),
                          // const FlickFullScreenToggle(),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}
