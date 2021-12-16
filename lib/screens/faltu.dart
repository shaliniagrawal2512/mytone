// import 'dart:ui';
// import 'package:mytone/Services/youtubeServices.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mytone/components/EmptyScreen.dart';
// import 'package:mytone/screens/music_player_screen.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
//
// class YouTubeSearchPage extends StatefulWidget {
//   final String query;
//   const YouTubeSearchPage({Key? key, required this.query}) : super(key: key);
//   @override
//   _YouTubeSearchPageState createState() => _YouTubeSearchPageState();
// }
//
// class _YouTubeSearchPageState extends State<YouTubeSearchPage> {
//   String query = '';
//   bool status = false;
//   List<Video> searchedList = [];
//   bool fetched = false;
//   bool done = true;
//   List ytSearch = [];
//   bool showHistory = true;
//   final TextEditingController _controller = TextEditingController();
//
//   @override
//   void initState() {
//     _controller.text = widget.query;
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!status) {
//       status = true;
//       YoutubeService()
//           .fetchSearchResults(query == '' ? widget.query : query)
//           .then((value) {
//         setState(() {
//           searchedList = value;
//           fetched = true;
//         });
//       });
//     }
//     return Container(
//         child: SafeArea(
//             child: Column(children: [
//       Expanded(
//           child: Scaffold(
//               resizeToAvoidBottomInset: false,
//               backgroundColor: Colors.transparent,
//               body: Column(children: [
//                 TextField(
//                   controller: _controller,
//                   scrollPadding: const EdgeInsets.only(bottom: 50),
//                   onSubmitted: (_query) async {
//                     _controller.clear();
//                     setState(() {
//                       fetched = false;
//                       query = _query;
//                       _controller.text = _query;
//                       status = false;
//                       searchedList = [];
//                       if (ytSearch.contains(_query)) ytSearch.remove(_query);
//                       ytSearch.insert(0, _query);
//                       if (ytSearch.length > 10) {
//                         ytSearch = ytSearch.sublist(0, 10);
//                       }
//                     });
//                   },
//                 ),
//               ])))
//     ])));
//   }
// }
