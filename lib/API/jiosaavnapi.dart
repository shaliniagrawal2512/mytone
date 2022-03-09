import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dart_des/dart_des.dart';
import 'package:http/http.dart';

class SaavnAPI {
  List preferredLanguages = ['Hindi'];
  Map<String, String> headers = {};
  String baseUrl = 'www.jiosaavn.com';
  String apiStr = '/api.php?_format=json&_marker=0&api_version=4&ctx=web6dot0';

  Map<String, String> endpoints = {
    'homeData': '__call=webapi.getLaunchData',
    'topSearches': '__call=content.getTopSearches',
    'getResult': '__call=search.getResults',
    'fromToken': '__call=webapi.get',
    'featuredRadio': '__call=webradio.createFeaturedStation',
    'artistRadio': '__call=webradio.createArtistStation',
    'entityRadio': '__call=webradio.createEntityStation',
    'radioSongs': '__call=webradio.getSong',
    'songDetails': '__call=song.getDetails',
    'playlistDetails': '__call=playlist.getDetails',
    'albumDetails': '__call=content.getAlbumDetails',
    'getResults': '__call=search.getResults',
    'albumResults': '__call=search.getAlbumResults',
    'artistResults': '__call=search.getArtistResults',
    'playlistResults': '__call=search.getPlaylistResults',
    'getReco': '__call=reco.getreco',
    'getAlbumReco': '__call=reco.getAlbumReco', // still not used
    'artistOtherTopSongs':
        '__call=search.artistOtherTopSongs', // still not used
  };

  getResponse(String params, {bool usev4 = true, bool useProxy = false}) async {
    String s = "$apiStr&${params.replaceAll('&api_version=4', '')}";
    print('$baseUrl$s');
    var res = await get(Uri.parse('$baseUrl$s'));
    if (res.statusCode == 200) {
      String data = res.body;
      print(data);
      return jsonDecode(data);
    } else {
      print(res.statusCode);
      return res.statusCode.toString();
    }
  }
  // if (!usev4) {
  //   url = Uri.https(
  //       baseUrl, '$apiStr&$params'.replaceAll('&api_version=4', ''));
  // } else {
  //   url = Uri.https(baseUrl, '$apiStr&$params');
  // }
  // preferredLanguages =
  //     preferredLanguages.map((lang) => lang.toLowerCase()).toList();
  // final String languageHeader = 'L=${preferredLanguages.join('%2C')}';
  // headers = {'cookie': languageHeader, 'Accept': '*/*'};
  //
  // final HttpClient httpClient = HttpClient();
  // httpClient.findProxy = (uri) {
  //   return "hello";
  // };
  // httpClient.badCertificateCallback =
  //     (X509Certificate cert, String host, int port) => Platform.isAndroid;
  // final IOClient myClient = IOClient(httpClient);
  // return myClient.get(url, headers: headers);

  fetchHomePageData() async {
    // Map result = {};
    // try {
    final res = await get(Uri.parse(
        "https://www.jiosaavn.com/api.php?_format=json&_marker=0&api_version=4&ctx=web6dot0&__call=webapi.getLaunchData"));
    if (res.statusCode == 200) {
      String data = res.body;
      return jsonDecode(data);
    } else {
      return res.statusCode.toString();
    }
  }

  Future<Map> getSongFromToken(String token, String type) async {
    final String params = "token=$token&type=$type&__call=webapi.get";
    try {
      final res = await get(Uri.parse(params));
      if (res.statusCode == 200) {
        final Map getMain = json.decode(res.body) as Map;
        if (type == 'album' || type == 'playlist') return getMain;
        final List responseList = getMain['songs'] as List;
        return {
          'songs':
              await FormatResponse().formatSongsResponse(responseList, type)
        };
      }
    } catch (e) {
      log('Error in getSongFromToken: $e');
    }
    return {'songs': List.empty()};
  }

  Future<List> getReco(String pid) async {
    final String params = "${endpoints['getReco']}&pid=$pid";
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final List getMain = json.decode(res.body) as List;
      return FormatResponse().formatSongsResponse(getMain, 'song');
    }
    return List.empty();
  }

  Future<String?> createRadio(
      String name, String language, String stationType) async {
    String? params;
    if (stationType == 'featured') {
      params = "name=$name&language=$language&${endpoints['featuredRadio']}";
    }
    if (stationType == 'artist') {
      params =
          "name=$name&query=$name&language=$language&${endpoints['artistRadio']}";
    }

    final res = await getResponse(params!);
    if (res.statusCode == 200) {
      final Map getMain = json.decode(res.body) as Map;
      return getMain['stationid']?.toString();
    }
    return null;
  }

  Future<List> getRadioSongs(String stationId, {int count = 20}) async {
    final String params =
        "stationid=$stationId&k=$count&${endpoints['radioSongs']}";
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final Map getMain = json.decode(res.body) as Map;
      final List responseList = [];
      for (int i = 0; i < count; i++) {
        responseList.add(getMain[i.toString()]['song']);
      }
      return FormatResponse().formatSongsResponse(responseList, 'song');
    }
    return [];
  }

  Future<List<String>> getTopSearches() async {
    try {
      final res = await getResponse(endpoints['topSearches']!, useProxy: true);
      if (res.statusCode == 200) {
        final List getMain = json.decode(res.body) as List;
        return getMain.map((element) {
          return element['title'].toString();
        }).toList();
      }
    } catch (e) {
      log('Error in getTopSearches: $e');
    }
    return List.empty();
  }

  Future<List> fetchSongSearchResults(String searchQuery, String count) async {
    final String params =
        "p=1&q=$searchQuery&n=$count&${endpoints['getResult']}";

    try {
      final res = await getResponse(params, useProxy: true);
      if (res.statusCode == 200) {
        final Map getMain = json.decode(res.body) as Map;
        final List responseList = getMain['results'] as List;
        return await FormatResponse().formatSongsResponse(responseList, 'song');
      }
    } catch (e) {
      log('Error in fetchSongSearchResults: $e');
    }
    return List.empty();
  }

  Future<List<Map>> fetchSearchResults(String searchQuery) async {
    final Map<String, List> result = {};
    final Map<int, String> position = {};
    List searchedAlbumList = [];
    List searchedPlaylistList = [];
    List searchedArtistList = [];
    List searchedTopQueryList = [];
    List searchedShowList = [];
    // List searchedEpisodeList = [];

    final String params =
        '__call=autocomplete.get&cc=in&includeMetaTags=1&query=$searchQuery';

    final res = await getResponse(params, usev4: false, useProxy: true);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List albumResponseList = getMain['albums']['data'] as List;
      position[getMain['albums']['position'] as int] = 'Albums';

      final List playlistResponseList = getMain['playlists']['data'] as List;
      position[getMain['playlists']['position'] as int] = 'Playlists';

      final List artistResponseList = getMain['artists']['data'] as List;
      position[getMain['artists']['position'] as int] = 'Artists';

      final List showResponseList = getMain['shows']['data'] as List;
      position[getMain['shows']['position'] as int] = 'Shows';

      // final List episodeResponseList = getMain['episodes']['data'] as List;
      // position[getMain['episodes']['position'] as int] = 'Episodes';

      final List topQuery = getMain['topquery']['data'] as List;

      searchedAlbumList = await FormatResponse()
          .formatAlbumResponse(albumResponseList, 'album');
      if (searchedAlbumList.isNotEmpty) {
        result['Albums'] = searchedAlbumList;
      }

      searchedPlaylistList = await FormatResponse()
          .formatAlbumResponse(playlistResponseList, 'playlist');
      if (searchedPlaylistList.isNotEmpty) {
        result['Playlists'] = searchedPlaylistList;
      }

      searchedShowList =
          await FormatResponse().formatAlbumResponse(showResponseList, 'show');
      if (searchedShowList.isNotEmpty) {
        result['Shows'] = searchedShowList;
      }

      searchedArtistList = await FormatResponse()
          .formatAlbumResponse(artistResponseList, 'artist');
      if (searchedArtistList.isNotEmpty) {
        result['Artists'] = searchedArtistList;
      }

      if (topQuery.isNotEmpty &&
          (topQuery[0]['type'] != 'playlist' ||
              topQuery[0]['type'] == 'artist' ||
              topQuery[0]['type'] == 'album')) {
        position[getMain['topquery']['position'] as int] = 'Top Result';
        position[getMain['songs']['position'] as int] = 'Songs';

        switch (topQuery[0]['type'] as String) {
          case 'artist':
            searchedTopQueryList =
                await FormatResponse().formatAlbumResponse(topQuery, 'artist');
            break;
          case 'album':
            searchedTopQueryList =
                await FormatResponse().formatAlbumResponse(topQuery, 'album');
            break;
          case 'playlist':
            searchedTopQueryList = await FormatResponse()
                .formatAlbumResponse(topQuery, 'playlist');
            break;
          default:
            break;
        }
        if (searchedTopQueryList.isNotEmpty) {
          result['Top Result'] = searchedTopQueryList;
        }
      } else {
        if (topQuery.isNotEmpty && topQuery[0]['type'] == 'song') {
          position[getMain['topquery']['position'] as int] = 'Songs';
        } else {
          position[getMain['songs']['position'] as int] = 'Songs';
        }
      }
    }
    return [result, position];
  }

  Future<List<Map>> fetchAlbums(String searchQuery, String type) async {
    String? params;
    if (type == 'playlist') {
      params = 'p=1&q=$searchQuery&n=20&${endpoints["playlistResults"]}';
    }
    if (type == 'album') {
      params = 'p=1&q=$searchQuery&n=20&${endpoints["albumResults"]}';
    }
    if (type == 'artist') {
      params = 'p=1&q=$searchQuery&n=20&${endpoints["artistResults"]}';
    }

    final res = await getResponse(params!);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List responseList = getMain['results'] as List;
      return FormatResponse().formatAlbumResponse(responseList, type);
    }
    return List.empty();
  }

  Future<List> fetchAlbumSongs(String albumId) async {
    final String params = '${endpoints['albumDetails']}&cc=in&albumid=$albumId';
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List responseList = getMain['list'] as List;
      return FormatResponse().formatSongsResponse(responseList, 'album');
    }
    return List.empty();
  }

  Future<Map<String, List>> fetchArtistSongs(String artistToken) async {
    final Map<String, List> data = {};
    final String params =
        '${endpoints["fromToken"]}&type=artist&p=&n_song=50&n_album=50&sub_type=&category=&sort_order=&includeMetaTags=0&token=$artistToken';
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List topSongsResponseList = getMain['topSongs'] as List;
      final List topAlbumsResponseList = getMain['topAlbums'] as List;
      final List topSongsSearchedList = await FormatResponse()
          .formatSongsResponse(topSongsResponseList, 'song');
      if (topSongsSearchedList.isNotEmpty) {
        data['Top Songs'] = topSongsSearchedList;
      }

      final List topAlbumsSearchedList = await FormatResponse()
          .formatArtistTopAlbumsResponse(topAlbumsResponseList);
      if (topAlbumsSearchedList.isNotEmpty) {
        data['Top Albums'] = topAlbumsSearchedList;
      }
    }
    return data;
  }

  Future<List> fetchPlaylistSongs(String playlistId) async {
    final String params =
        '${endpoints["playlistDetails"]}&cc=in&listid=$playlistId';
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List responseList = getMain['list'] as List;
      return FormatResponse().formatSongsResponse(responseList, 'playlist');
    }
    return List.empty();
  }

  Future<List> fetchTopSearchResult(String searchQuery) async {
    final String params = 'p=1&q=$searchQuery&n=10&${endpoints["getResults"]}';
    final res = await getResponse(params, useProxy: true);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List responseList = getMain['results'] as List;
      return [
        await FormatResponse().formatSingleSongResponse(responseList[0] as Map)
      ];
    }
    return List.empty();
  }

  Future<Map> fetchSongDetails(String songId) async {
    final String params = 'pids=$songId&${endpoints["songDetails"]}';
    try {
      final res = await getResponse(params);
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        return await FormatResponse()
            .formatSingleSongResponse(data['songs'][0] as Map);
      }
    } catch (e) {
      log('Error in fetchSongDetails: $e');
    }
    return {};
  }
}

class FormatResponse {
  String decode(String input) {
    const String key = '38346591';
    final DES desECB = DES(key: key.codeUnits);

    final Uint8List encrypted = base64.decode(input);
    final List<int> decrypted = desECB.decrypt(encrypted);
    final String decoded =
        utf8.decode(decrypted).replaceAll(RegExp(r'\.mp4.*'), '.mp4');
    return decoded.replaceAll('http:', 'https:');
  }

  String capitalize(String msg) {
    return '${msg[0].toUpperCase()}${msg.substring(1)}';
  }

  String formatString(String text) {
    return text
        .toString()
        .replaceAll('&amp;', '&')
        .replaceAll('&#039;', "'")
        .replaceAll('&quot;', '"')
        .trim();
  }

  Future<List> formatSongsResponse(List responseList, String type) async {
    final List searchedList = [];
    for (int i = 0; i < responseList.length; i++) {
      Map? response;
      switch (type) {
        case 'song':
        case 'album':
        case 'playlist':
          response = await formatSingleSongResponse(responseList[i] as Map);
          break;
        default:
          break;
      }

      if (response!.containsKey('Error')) {
        log('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        searchedList.add(response);
      }
    }
    return searchedList;
  }

  Future<Map> formatSingleSongResponse(Map response) async {
    try {
      final List artistNames = [];
      if (response['more_info']?['artistMap']?['primary_artists'] == null ||
          response['more_info']?['artistMap']?['primary_artists'].length == 0) {
        if (response['more_info']?['artistMap']?['featured_artists'] == null ||
            response['more_info']?['artistMap']?['featured_artists'].length ==
                0) {
          if (response['more_info']?['artistMap']?['artists'] == null ||
              response['more_info']?['artistMap']?['artists'].length == 0) {
            artistNames.add('Unknown');
          } else {
            response['more_info']['artistMap']['artists'][0]['id']
                .forEach((element) {
              artistNames.add(element['name']);
            });
          }
        } else {
          response['more_info']['artistMap']['featured_artists']
              .forEach((element) {
            artistNames.add(element['name']);
          });
        }
      } else {
        response['more_info']['artistMap']['primary_artists']
            .forEach((element) {
          artistNames.add(element['name']);
        });
      }

      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['more_info']['album'].toString()),
        'year': response['year'],
        'duration': response['more_info']['duration'],
        'language': capitalize(response['language'].toString()),
        'genre': capitalize(response['language'].toString()),
        '320kbps': response['more_info']['320kbps'],
        'has_lyrics': response['more_info']['has_lyrics'],
        'lyrics_snippet':
            formatString(response['more_info']['lyrics_snippet'].toString()),
        'release_date': response['more_info']['release_date'],
        'album_id': response['more_info']['album_id'],
        'subtitle': formatString(response['subtitle'].toString()),
        'title': formatString(response['title'].toString()),
        'artist': formatString(artistNames.join(', ')),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'perma_url': response['perma_url'],
        'url': decode(response['more_info']['encrypted_media_url'].toString()),
      };
      // Hive.box('cache').put(response['id'], info);
    } catch (e) {
      return {'Error': e};
    }
  }

  Future<Map> formatSingleAlbumSongResponse(Map response) async {
    try {
      final List artistNames = [];
      if (response['primary_artists'] == null ||
          response['primary_artists'].toString().trim() == '') {
        if (response['featured_artists'] == null ||
            response['featured_artists'].toString().trim() == '') {
          if (response['singers'] == null ||
              response['singer'].toString().trim() == '') {
            response['singers'].toString().split(', ').forEach((element) {
              artistNames.add(element);
            });
          } else {
            artistNames.add('Unknown');
          }
        } else {
          response['featured_artists']
              .toString()
              .split(', ')
              .forEach((element) {
            artistNames.add(element);
          });
        }
      } else {
        response['primary_artists'].toString().split(', ').forEach((element) {
          artistNames.add(element);
        });
      }

      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['album'].toString()),
        // .split('(')
        // .first
        'year': response['year'],
        'duration': response['duration'],
        'language': capitalize(response['language'].toString()),
        'genre': capitalize(response['language'].toString()),
        '320kbps': response['320kbps'],
        'has_lyrics': response['has_lyrics'],
        'lyrics_snippet': formatString(response['lyrics_snippet'].toString()),
        'release_date': response['release_date'],
        'album_id': response['album_id'],
        'subtitle': formatString(
            '${response["primary_artists"].toString().trim()} - ${response["album"].toString().trim()}'),
        'title': formatString(response['song'].toString()),
        // .split('(')
        // .first
        'artist': formatString(artistNames.join(', ')),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'perma_url': response['perma_url'],
        'url': decode(response['encrypted_media_url'].toString())
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  Future<List<Map>> formatAlbumResponse(List responseList, String type) async {
    final List<Map> searchedAlbumList = [];
    for (int i = 0; i < responseList.length; i++) {
      Map? response;
      switch (type) {
        case 'album':
          response = await formatSingleAlbumResponse(responseList[i] as Map);
          break;
        case 'artist':
          response = await formatSingleArtistResponse(responseList[i] as Map);
          break;
        case 'playlist':
          response = await formatSinglePlaylistResponse(responseList[i] as Map);
          break;
        case 'show':
          response = await formatSingleAlbumResponse(responseList[i] as Map);
          break;
      }
      if (response!.containsKey('Error')) {
        log('Error at index $i inside FormatAlbumResponse: ${response["Error"]}');
      } else {
        searchedAlbumList.add(response);
      }
    }
    return searchedAlbumList;
  }

  Future<Map> formatSingleAlbumResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        'year': response['more_info']?['year'] ?? response['year'],
        'language': capitalize(response['more_info']?['language'] == null
            ? response['language'].toString()
            : response['more_info']['language'].toString()),
        'genre': capitalize(response['more_info']?['language'] == null
            ? response['language'].toString()
            : response['more_info']['language'].toString()),
        'album_id': response['id'],
        'subtitle': response['description'] == null
            ? formatString(response['subtitle'].toString())
            : formatString(response['description'].toString()),
        'title': formatString(response['title'].toString()),
        'artist': response['music'] == null
            ? response['more_info']['music'] == null
                ? response['more_info']['artistMap']['primary_artists'] == null
                    ? ''
                    : formatString(response['more_info']['artistMap']
                            ['primary_artists'][0]['name']
                        .toString())
                : formatString(response['more_info']['music'].toString())
            : formatString(response['music'].toString()),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'count': response['more_info']?['song_pids'] == null
            ? 0
            : response['more_info']['song_pids'].toString().split(', ').length,
        'songs_pids': response['more_info']['song_pids'].toString().split(', '),
      };
    } catch (e) {
      log('Error inside formatSingleAlbumResponse: $e');
      return {'Error': e};
    }
  }

  Future<Map> formatSinglePlaylistResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        'language': capitalize(response['language'] == null
            ? response['more_info']['language'].toString()
            : response['language'].toString()),
        'genre': capitalize(response['language'] == null
            ? response['more_info']['language'].toString()
            : response['language'].toString()),
        'playlistId': response['id'],
        'subtitle': response['description'] == null
            ? formatString(response['subtitle'].toString())
            : formatString(response['description'].toString()),
        'title': formatString(response['title'].toString()),
        'artist': formatString(response['extra'].toString()),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      log('Error inside formatSinglePlaylistResponse: $e');
      return {'Error': e};
    }
  }

  Future<Map> formatSingleArtistResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': response['title'] == null
            ? formatString(response['name'].toString())
            : formatString(response['title'].toString()),
        'language': capitalize(response['language'].toString()),
        'genre': capitalize(response['language'].toString()),
        'artistId': response['id'],
        'artistToken': response['url'] == null
            ? response['perma_url'].toString().split('/').last
            : response['url'].toString().split('/').last,
        'subtitle': response['description'] == null
            ? capitalize(response['role'].toString())
            : formatString(response['description'].toString()),
        'title': response['title'] == null
            ? formatString(response['name'].toString())
            : formatString(response['title'].toString()),
        // .split('(')
        // .first

        'artist': formatString(response['title'].toString()),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      log('Error inside formatSingleArtistResponse: $e');
      return {'Error': e};
    }
  }

  Future<List> formatArtistTopAlbumsResponse(List responseList) async {
    final List result = [];
    for (int i = 0; i < responseList.length; i++) {
      final Map response =
          await formatSingleArtistTopAlbumSongResponse(responseList[i] as Map);
      if (response.containsKey('Error')) {
        log('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        result.add(response);
      }
    }
    return result;
  }

  Future<Map> formatSingleArtistTopAlbumSongResponse(Map response) async {
    try {
      final List artistNames = [];
      if (response['more_info']?['artistMap']?['primary_artists'] == null ||
          response['more_info']['artistMap']['primary_artists'].length == 0) {
        if (response['more_info']?['artistMap']?['featured_artists'] == null ||
            response['more_info']['artistMap']['featured_artists'].length ==
                0) {
          if (response['more_info']?['artistMap']?['artists'] == null ||
              response['more_info']['artistMap']['artists'].length == 0) {
            artistNames.add('Unknown');
          } else {
            response['more_info']['artistMap']['artists'].forEach((element) {
              artistNames.add(element['name']);
            });
          }
        } else {
          response['more_info']['artistMap']['featured_artists']
              .forEach((element) {
            artistNames.add(element['name']);
          });
        }
      } else {
        response['more_info']['artistMap']['primary_artists']
            .forEach((element) {
          artistNames.add(element['name']);
        });
      }

      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        'year': response['year'],
        'language': capitalize(response['language'].toString()),
        'genre': capitalize(response['language'].toString()),
        'album_id': response['id'],
        'subtitle': formatString(response['subtitle'].toString()),
        'title': formatString(response['title'].toString()),
        'artist': formatString(artistNames.join(', ')),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  Future<Map> formatSingleShowResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        'subtitle': response['description'] == null
            ? formatString(response['subtitle'].toString())
            : formatString(response['description'].toString()),
        'title': formatString(response['title'].toString()),
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  Future<Map> formatHomePageData(Map data) async {
    try {
      data['new_trending'] = await formatSongsInList(
          data['new_trending'] as List,
          fetchDetails: false);
      data['new_albums'] = await formatSongsInList(data['new_albums'] as List,
          fetchDetails: false);
      if (data['city_mod'] != null) {
        data['city_mod'] = await formatSongsInList(data['city_mod'] as List,
            fetchDetails: true);
      }
      final List promoList = [];
      final List promoListTemp = [];
      data['modules'].forEach((k, v) {
        if (k.startsWith('promo') as bool) {
          if (data[k][0]['type'] == 'song' &&
              (data[k][0]['mini_obj'] as bool? ?? false)) {
            promoListTemp.add(k.toString());
          } else {
            promoList.add(k.toString());
          }
        }
      });
      for (int i = 0; i < promoList.length; i++) {
        data[promoList[i]] = await formatSongsInList(data[promoList[i]] as List,
            fetchDetails: false);
      }
      data['collections'] = [
        'new_trending',
        'charts',
        'new_albums',
        'top_playlists',
        'radio',
        'city_mod',
        'artist_recos',
        ...promoList
      ];
      data['collections_temp'] = promoListTemp;
    } catch (e) {
      log('Error in formatHomePageData: $e');
    }
    return data;
  }

  Future<Map> formatPromoLists(Map data) async {
    try {
      final List promoList = data['collections_temp'] as List;
      for (int i = 0; i < promoList.length; i++) {
        data[promoList[i]] = await formatSongsInList(data[promoList[i]] as List,
            fetchDetails: true);
      }
      data['collections'].addAll(promoList);
      data['collections_temp'] = [];
    } catch (e) {
      log('Error in formatPromoLists: $e');
    }
    return data;
  }

  Future<List> formatSongsInList(List list,
      {required bool fetchDetails}) async {
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        final Map item = list[i] as Map;
        if (item['type'] == 'song') {
          if (item['mini_obj'] as bool? ?? false) {
            if (fetchDetails) {
              Map cachedDetails = {};
              if (cachedDetails.isEmpty) {
                cachedDetails =
                    await SaavnAPI().fetchSongDetails(item['id'].toString());
              }
              list[i] = cachedDetails;
            }
            continue;
          }
          list[i] = await formatSingleSongResponse(item);
        }
      }
    }
    list.removeWhere((value) => value == null);
    return list;
  }
}
