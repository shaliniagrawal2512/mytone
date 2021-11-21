import 'package:flutter/material.dart';

class RadioStation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('images/music4.jpg'),
            ),
            Text(
              'Bollywood Remix',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Hindi Radio'),
          ],
        ),
      ),
    );
  }
}
