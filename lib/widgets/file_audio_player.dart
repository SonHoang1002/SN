import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:market_place/helpers/common.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FileAudioPlayer extends StatefulWidget {
  final String path;
  const FileAudioPlayer({Key? key, required this.path}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FileAudioPlayerState createState() => _FileAudioPlayerState();
}

class _FileAudioPlayerState extends State<FileAudioPlayer> {
  late final audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    if (!mounted) return;

    super.initState();

    try {
      audioPlayer = AudioPlayer();
      setAudio();

      audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      });

      audioPlayer.onDurationChanged.listen((newDuration) {
        setState(() {
          duration = newDuration;
        });
      });

      audioPlayer.onPositionChanged.listen((newPosition) {
        setState(() {
          position = newPosition;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              if (isPlaying) {
                await audioPlayer.pause();
              } else {
                await audioPlayer.play(UrlSource(widget.path));
              }
            },
            icon: Icon(
              isPlaying
                  ? FontAwesomeIcons.circlePause
                  : FontAwesomeIcons.circlePlay,
            ),
            iconSize: 26,
          ),
          Text(formatTimeMediaPlayer(position)),
          SizedBox(
            width: size.width * 0.33,
            child: SliderTheme(
              data: SliderThemeData(
                  thumbColor: Colors.black,
                  activeTrackColor: Colors.black,
                  inactiveTrackColor: Colors.black.withOpacity(0.4),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6)),
              child: Slider(
                  min: 0,
                  // activeColor: Colors.grey.shade500,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioPlayer.seek(position);

                    await audioPlayer.resume();
                  }),
            ),
          ),
          Text(formatTimeMediaPlayer(duration - position)),
        ],
      ),
    );
  }

  Future setAudio() async {
    try {
      audioPlayer.setReleaseMode(ReleaseMode.loop);

      audioPlayer.setSourceUrl(widget.path);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
