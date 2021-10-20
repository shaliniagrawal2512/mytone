import 'package:flutter/material.dart';
import 'package:mytone/constants.dart';
import 'package:mytone/components/required_icon.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';

class MusicPlayer extends StatefulWidget {
  static const String id = 'musicPlayer_screen';

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  double radius = 50;
  IconData icon = Icons.play_arrow;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF36274A),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Music Player'),
          Text('Music Player'),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Image(
                image: AssetImage('images/mytone.png'),
              ),
            ),
          ),
          FlutterSlider(
            tooltip: FlutterSliderTooltip(
                textStyle: TextStyle(color: Colors.white),
                boxStyle: FlutterSliderTooltipBox()),
            handler: FlutterSliderHandler(
                child: Icon(
                  Icons.circle,
                  color: Color(0xFFF9287B),
                  size: 15.0,
                ),
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                        colors: [Color(0xFFFFFDFF), Color(0x29F9287B)],
                        stops: [0.7, 1]),
                    shape: BoxShape.circle)),
            handlerAnimation:
                FlutterSliderHandlerAnimation(curve: Curves.linear),
            values: [0],
            max: 100,
            min: 0,
            trackBar: FlutterSliderTrackBar(
              activeTrackBarHeight: 6,
              inactiveTrackBarHeight: 5,
              inactiveTrackBar: BoxDecoration(
                color: Color(0xFF36274A),
              ),
              activeTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(colors: [
                  Color(0xFF7E1CEA),
                  Color(0xFFF9287B),
                ]),
              ),
            ),
            onDragging: (handlerIndex, lowerValue, upperValue) {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OtherButton(
                iconData: Icons.replay_outlined,
                onPressed: () {},
                iconSize: 25,
                radius: 20,
              ),
              OtherButton(
                iconData: Icons.skip_previous,
                onPressed: () {},
                iconSize: 30,
                radius: 35,
              ),
              RequiredIcon(
                iconData: icon,
                onPressed: () {
                  isPlaying = !isPlaying;
                  setState(() {
                    if (isPlaying) {
                      AudioCache player = AudioCache();
                      player.play('note2.wav');
                      radius = 30;
                      icon = Icons.pause;
                    } else {
                      radius = 50;
                      icon = Icons.play_arrow;
                    }
                  });
                },
                iconSize: 40,
                radius: radius,
              ),
              OtherButton(
                iconData: Icons.skip_next,
                onPressed: () {},
                iconSize: 30,
                radius: 35,
              ),
              OtherButton(
                iconData: Icons.shuffle,
                onPressed: () {},
                iconSize: 25,
                radius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
