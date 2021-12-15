// import 'package:blackhole/APIs/savan.dart';
// import 'package:blackhole/Helpers/format.dart';
// //import 'package:blackhole/Screens/Common/song_list.dart';
// //import 'package:blackhole/Screens/Player/audioplayer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// bool fetched = false;
// List likedRadio = [];
// Map data = {};
// List lists = ['recent', ...?data['collections']];
//
// class JioHomePage extends StatefulWidget {
//   @override
//   _JioHomePageState createState() => _JioHomePageState();
// }
//
// class _JioHomePageState extends State<JioHomePage>
//     with AutomaticKeepAliveClientMixin<JioHomePage> {
//   List recentList = [];
//
//   Future<void> getHomePageData() async {
//     Map receivedData = await SaavnAPI().fetchHomePageData();
//     if (receivedData.isNotEmpty) {
//       Hive.box('cache').put('homepage', receivedData);
//       data = receivedData;
//       lists = ['recent', ...?data['collections']];
//     }
//     setState(() {});
//     receivedData = await FormatResponse().formatPromoLists(data);
//     if (receivedData.isNotEmpty) {
//       Hive.box('cache').put('homepage', receivedData);
//       data = receivedData;
//       lists = ['recent', ...?data['collections']];
//     }
//     setState(() {});
//   }
//
//   String getSubTitle(Map item) {
//     final type = item['type'];
//     if (type == 'charts') {
//       return '';
//     } else if (type == 'playlist' || type == 'radio_station') {
//       return formatString(item['subtitle']?.toString());
//     } else if (type == 'song') {
//       return formatString(item['artist']?.toString());
//     } else {
//       final artists = item['more_info']?['artistMap']?['artists']
//           .map((artist) => artist['name'])
//           .toList();
//       return formatString(artists?.join(', ')?.toString());
//     }
//   }
//
//   String formatString(String? text) {
//     return text == null
//         ? ''
//         : text
//             .toString()
//             .replaceAll('&amp;', '&')
//             .replaceAll('&#039;', "'")
//             .replaceAll('&quot;', '"')
//             .trim();
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     if (!fetched) {
//       getHomePageData();
//       fetched = true;
//     }
//     final double boxSize =
//         MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
//             ? MediaQuery.of(context).size.width
//             : MediaQuery.of(context).size.height;
//     return ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         shrinkWrap: true,
//         padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//         itemCount: data.isEmpty ? 1 : lists.length,
//         itemBuilder: (context, idx) {
//           if (idx == 0) {
//             return (recentList.isEmpty ||
//                     !(Hive.box('settings').get('showRecent', defaultValue: true)
//                         as bool))
//                 ? const SizedBox()
//                 : Column(
//                     children: [
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
//                             child: Text(
//                               AppLocalizations.of(context)!.lastSession,
//                               style: TextStyle(
//                                 color: Theme.of(context).colorScheme.secondary,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: boxSize / 2 + 10,
//                         child: ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                           itemCount: recentList.length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onLongPress: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       backgroundColor: Colors.transparent,
//                                       contentPadding: EdgeInsets.zero,
//                                       content: Card(
//                                         elevation: 5,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(15.0),
//                                         ),
//                                         clipBehavior: Clip.antiAlias,
//                                         child: CachedNetworkImage(
//                                           fit: BoxFit.cover,
//                                           errorWidget: (context, _, __) =>
//                                               const Image(
//                                             image:
//                                                 AssetImage('assets/cover.jpg'),
//                                           ),
//                                           imageUrl: recentList[index]['image']
//                                               .toString()
//                                               .replaceAll('http:', 'https:')
//                                               .replaceAll('50x50', '500x500')
//                                               .replaceAll('150x150', '500x500'),
//                                           placeholder: (context, url) =>
//                                               const Image(
//                                             image:
//                                                 AssetImage('assets/cover.jpg'),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   PageRouteBuilder(
//                                     opaque: false,
//                                     pageBuilder: (_, __, ___) => PlayScreen(
//                                       data: {
//                                         'response': recentList,
//                                         'index': index,
//                                         'offline': false,
//                                       },
//                                       fromMiniplayer: false,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: SizedBox(
//                                 width: boxSize / 2 - 30,
//                                 child: Column(
//                                   children: [
//                                     Card(
//                                       elevation: 5,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                       ),
//                                       clipBehavior: Clip.antiAlias,
//                                       child: CachedNetworkImage(
//                                         errorWidget: (context, _, __) =>
//                                             const Image(
//                                           image: AssetImage('assets/cover.jpg'),
//                                         ),
//                                         imageUrl: recentList[index]['image']
//                                             .toString()
//                                             .replaceAll('http:', 'https:')
//                                             .replaceAll('50x50', '500x500')
//                                             .replaceAll('150x150', '500x500'),
//                                         placeholder: (context, url) =>
//                                             const Image(
//                                           image: AssetImage('assets/cover.jpg'),
//                                         ),
//                                       ),
//                                     ),
//                                     Text(
//                                       '${recentList[index]["title"]}',
//                                       textAlign: TextAlign.center,
//                                       softWrap: false,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     Text(
//                                       '${recentList[index]["artist"]}',
//                                       textAlign: TextAlign.center,
//                                       softWrap: false,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                           fontSize: 11,
//                                           color: Theme.of(context)
//                                               .textTheme
//                                               .caption!
//                                               .color),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//           }
//           return Column(
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
//                     child: Text(
//                       formatString(
//                           data['modules'][lists[idx]]?['title']?.toString()),
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.secondary,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               if (data[lists[idx]] == null)
//                 const SizedBox()
//               else
//                 SizedBox(
//                   height: boxSize / 2 + 10,
//                   child: ListView.builder(
//                     physics: const BouncingScrollPhysics(),
//                     scrollDirection: Axis.horizontal,
//                     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                     itemCount: data['modules'][lists[idx]]?['title']
//                                 ?.toString() ==
//                             'Radio Stations'
//                         ? (data[lists[idx]] as List).length + likedRadio.length
//                         : (data[lists[idx]] as List).length,
//                     itemBuilder: (context, index) {
//                       Map item = data[lists[idx]][index] as Map;
//                       if (data['modules'][lists[idx]]?['title']?.toString() ==
//                           'Radio Stations') {
//                         index < likedRadio.length
//                             ? item = likedRadio[index] as Map
//                             : item = data[lists[idx]][index - likedRadio.length]
//                                 as Map;
//                       }
//                       final currentSongList = data[lists[idx]]
//                           .where((e) => e['type'] == 'song')
//                           .toList();
//                       final subTitle = getSubTitle(item);
//                       if (item.isEmpty) return const SizedBox();
//                       return GestureDetector(
//                         onLongPress: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 backgroundColor: Colors.transparent,
//                                 contentPadding: EdgeInsets.zero,
//                                 content: Card(
//                                   elevation: 5,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                         item['type'] == 'radio_station'
//                                             ? 1000.0
//                                             : 15.0),
//                                   ),
//                                   clipBehavior: Clip.antiAlias,
//                                   child: CachedNetworkImage(
//                                     fit: BoxFit.cover,
//                                     errorWidget: (context, _, __) =>
//                                         const Image(
//                                       image: AssetImage('assets/cover.jpg'),
//                                     ),
//                                     imageUrl: item['image']
//                                         .toString()
//                                         .replaceAll('http:', 'https:')
//                                         .replaceAll('50x50', '500x500')
//                                         .replaceAll('150x150', '500x500'),
//                                     placeholder: (context, url) => Image(
//                                       image: (item['type'] == 'playlist' ||
//                                               item['type'] == 'album')
//                                           ? const AssetImage('assets/album.png')
//                                           : item['type'] == 'artist'
//                                               ? const AssetImage(
//                                                   'assets/artist.png')
//                                               : const AssetImage(
//                                                   'assets/cover.jpg'),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                         onTap: () {
//                           if (item['type'] == 'radio_station') {
//                             ShowSnackBar().showSnackBar(
//                               context,
//                               AppLocalizations.of(context)!.connectingRadio,
//                               duration: const Duration(seconds: 2),
//                             );
//                             SaavnAPI()
//                                 .createRadio(
//                               item['more_info']['featured_station_type']
//                                           .toString() ==
//                                       'artist'
//                                   ? item['more_info']['query'].toString()
//                                   : item['id'].toString(),
//                               item['more_info']['language']?.toString() ??
//                                   'hindi',
//                               item['more_info']['featured_station_type']
//                                   .toString(),
//                             )
//                                 .then((value) {
//                               if (value != null) {
//                                 SaavnAPI()
//                                     .getRadioSongs(value)
//                                     .then((value) => Navigator.push(
//                                           context,
//                                           PageRouteBuilder(
//                                               opaque: false,
//                                               pageBuilder: (_, __, ___) =>
//                                                   PlayScreen(
//                                                     data: {
//                                                       'response': value,
//                                                       'index': 0,
//                                                       'offline': false,
//                                                     },
//                                                     fromMiniplayer: false,
//                                                   )),
//                                         ));
//                               }
//                             });
//                           } else {
//                             Navigator.push(
//                               context,
//                               PageRouteBuilder(
//                                 opaque: false,
//                                 pageBuilder: (_, __, ___) => item['type'] ==
//                                         'song'
//                                     ? PlayScreen(
//                                         data: {
//                                           'response': currentSongList,
//                                           'index': currentSongList.indexWhere(
//                                               (e) => e['id'] == item['id']),
//                                           'offline': false,
//                                         },
//                                         fromMiniplayer: false,
//                                       )
//                                     : SongsListPage(
//                                         listItem: item,
//                                       ),
//                               ),
//                             );
//                           }
//                         },
//                         child: SizedBox(
//                           width: boxSize / 2 - 30,
//                           child: Stack(
//                             children: [
//                               Column(
//                                 children: [
//                                   Card(
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           item['type'] == 'radio_station'
//                                               ? 1000.0
//                                               : 10.0),
//                                     ),
//                                     clipBehavior: Clip.antiAlias,
//                                     child: CachedNetworkImage(
//                                       errorWidget: (context, _, __) =>
//                                           const Image(
//                                         image: AssetImage('assets/cover.jpg'),
//                                       ),
//                                       imageUrl: item['image']
//                                           .toString()
//                                           .replaceAll('http:', 'https:')
//                                           .replaceAll('50x50', '500x500')
//                                           .replaceAll('150x150', '500x500'),
//                                       placeholder: (context, url) => Image(
//                                         image: (item['type'] == 'playlist' ||
//                                                 item['type'] == 'album')
//                                             ? const AssetImage(
//                                                 'assets/album.png')
//                                             : item['type'] == 'artist'
//                                                 ? const AssetImage(
//                                                     'assets/artist.png')
//                                                 : const AssetImage(
//                                                     'assets/cover.jpg'),
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     formatString(item['title']?.toString()),
//                                     textAlign: TextAlign.center,
//                                     softWrap: false,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   if (subTitle != '')
//                                     Text(
//                                       subTitle,
//                                       textAlign: TextAlign.center,
//                                       softWrap: false,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                           fontSize: 11,
//                                           color: Theme.of(context)
//                                               .textTheme
//                                               .caption!
//                                               .color),
//                                     )
//                                   else
//                                     const SizedBox(),
//                                 ],
//                               ),
//                               if (item['type'] == 'radio_station')
//                                 Align(
//                                   alignment: Alignment.topRight,
//                                   child: IconButton(
//                                     icon: likedRadio.contains(item)
//                                         ? const Icon(
//                                             Icons.favorite_rounded,
//                                             color: Colors.red,
//                                           )
//                                         : const Icon(
//                                             Icons.favorite_border_rounded),
//                                     tooltip: likedRadio.contains(item)
//                                         ? AppLocalizations.of(context)!.unlike
//                                         : AppLocalizations.of(context)!.like,
//                                     onPressed: () {
//                                       likedRadio.contains(item)
//                                           ? likedRadio.remove(item)
//                                           : likedRadio.add(item);
//                                       Hive.box('settings')
//                                           .put('likedRadio', likedRadio);
//                                       setState(() {});
//                                     },
//                                   ),
//                                 )
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//             ],
//           );
//         });
//   }
// }
