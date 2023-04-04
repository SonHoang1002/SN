import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class WatchDetail extends StatefulWidget {
  final dynamic media;
  const WatchDetail({Key? key, this.media}) : super(key: key);

  @override
  State<WatchDetail> createState() => _WatchDetailState();
}

class _WatchDetailState extends State<WatchDetail> {
  late BetterPlayerController betterPlayerController;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      BetterPlayerConfiguration betterPlayerConfiguration =
          BetterPlayerConfiguration(
              aspectRatio: betterPlayerController.getAspectRatio(),
              autoPlay: true,
              autoDispose: true);
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.media['remote_url'] ?? widget.media['url'],
        useAsmsSubtitles: true,
      );
      betterPlayerController =
          BetterPlayerController(betterPlayerConfiguration);
      betterPlayerController.setupDataSource(dataSource);
    }
  }

  @override
  void dispose() {
    betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String averageColor = widget.media['meta']['original']['average_color'];

    return Scaffold(
      body: Container(
        color: Color(int.parse('0xFF${averageColor.substring(1)}')),
        child: Center(
          child: BetterPlayer(controller: betterPlayerController),
        ),
      ),
    );
  }
}
