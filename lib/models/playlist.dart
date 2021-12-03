import 'dart:collection';
import 'package:flutter/material.dart';

class Playlist {
  String title;
  Playlist({required this.title});
}

class PlayListAdd extends ChangeNotifier {
  List<Playlist> _playList = [
    Playlist(title: "Favourite Songs"),
  ];
  int get playListCount {
    return _playList.length;
  }

  UnmodifiableListView<Playlist> get allPlayLists {
    return UnmodifiableListView(_playList);
  }

  void addNewPlayList(String title) {
    _playList.add(Playlist(title: title));
    notifyListeners();
  }

  void removePlaylist(Playlist play) {
    _playList.remove(play);
    notifyListeners();
  }
}
