import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: Color(0xFF421452),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              height: 150,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  image: DecorationImage(
                    image: AssetImage('images/music3.jpg'),
                    fit: BoxFit.fill,
                  )),
            ),
            Text(
              "Param sundari",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text("palak mucchal, shreya ghoshal"),
          ],
        ),
      ),
    );
  }
}
