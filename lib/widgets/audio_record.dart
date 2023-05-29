import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:market_place/theme/colors.dart';

class AudioRecord extends StatefulWidget {
  final Function handleDelete;
  const AudioRecord({Key? key, required this.handleDelete}) : super(key: key);

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  late final RecorderController recorderController;
  @override
  void initState() {
    if (!mounted) return;

    super.initState();
    recorderController = RecorderController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              widget.handleDelete();
            },
            child: const Icon(
              FontAwesomeIcons.trash,
              color: primaryColor,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            height: 35,
            width: size.width - 100,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    // handleSendMessage(_controller.text);
                  },
                  child: const Icon(
                    FontAwesomeIcons.circlePlay,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                AudioWaveforms(
                    size: Size(MediaQuery.of(context).size.width - 200, 20.0),
                    recorderController: recorderController,
                    backgroundColor: Colors.black,
                    waveStyle: const WaveStyle(
                      waveColor: Color.fromARGB(255, 219, 11, 11),
                      showDurationLabel: true,
                      spacing: 8.0,
                      showBottom: false,
                      extendWaveform: true,
                      showMiddleLine: false,
                    )),
                const Text(
                  "0:10",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: () {
              // handleSendMessage(_controller.text);
            },
            child: const Icon(
              Icons.send,
              color: primaryColor,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }
}
