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

  List<Playlist> get allPlayLists {
    return _playList;
  }

  void addNewPlayList(String title) {
    _playList.add(Playlist(title: title));
    notifyListeners();
  }

  void removePlaylist(Playlist play) {
    _playList.remove(play);
    notifyListeners();
  }

  void renamePlaylist(Playlist play, String value) {
    play.title = value;
    notifyListeners();
  }
}
