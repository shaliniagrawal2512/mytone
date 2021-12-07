import 'package:flutter/material.dart';
import 'package:mytone/components/customSlider.dart';
import 'package:mytone/screens/music_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MusicPlayer.id);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        height: 76,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            image: AssetImage('images/music5.jpeg'),
                            fit: BoxFit.fill))),
                SizedBox(width: 10),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("jodha akbar"),
                      Text("arijit singh, palak mucchal"),
                    ]),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.skip_previous, size: 30)),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.play_arrow, size: 30)),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.skip_next, size: 30)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomSlider(
                inactiveTrackHeight: 2,
                thumbIconSize: 5,
                trackHeight: 2.5,
                handlerHeight: 8,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Color(0xFF421452),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      ),
    );
  }
}
