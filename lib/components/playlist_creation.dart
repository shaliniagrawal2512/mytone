import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:mytone/screens/jio_playlist.dart';

class PlayList extends StatelessWidget {
  PlayList({required this.title, this.data});
  final String title;
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            title,
            gradient: LinearGradient(
              colors: [
                Color(0xFFF9287B),
                Color(0xFF7E1CEA),
              ],
            ),
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 270,
            child: ListView.builder(
              itemCount: data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => JioPlaylist(
                                  listItem: data[index],)));
                    },
                    child: SizedBox(
                      width: 200,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: data[index]['image'].toString(),
                                errorWidget: (context, _, __) => const Image(
                                  image: AssetImage('images/cover.jpg'),
                                ),
                                placeholder: (context, url) => const Image(
                                  image: AssetImage('images/cover.jpg'),
                                ),
                              ),
                            ),
                          ),
                          data[index]['title'] != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 2),
                                  child: Text(
                                    data[index]['title'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                )
                              : SizedBox(height: 1),
                          data[index]['subtitle'] != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Text(data[index]['subtitle'],
                                      overflow: TextOverflow.ellipsis),
                                )
                              : SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
