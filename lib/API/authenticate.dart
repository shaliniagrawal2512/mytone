// import 'package:spotify_sdk/spotify_sdk.dart';
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:http/http.dart';
//
// class Auth {
//   getToken() async {
//     await SpotifySdk.connectToSpotifyRemote(
//         clientId: "57309563b48f43b4955fac060aea6cf4",
//         redirectUrl: "com.example.mytone://callback");
//     var authenticationToken = await SpotifySdk.getAuthenticationToken(
//         clientId: "57309563b48f43b4955fac060aea6cf4",
//         redirectUrl: "com.example.mytone://callback",
//         scope:
//             "app-remote-control,user-modify-playback-state,playlist-read-private");
//     print(authenticationToken);
//   }
// }
//
// class SpotifyApi {
//   final List<String> _scopes = [
//     'user-read-private',
//     'user-read-email',
//     'playlist-read-private',
//     'playlist-read-collaborative',
//   ];
//
//   /// You can signup for spotify developer account and get your own clientID and clientSecret incase you don't want to use these
//   final String clientID = '57309563b48f43b4955fac060aea6cf4';
//   final String clientSecret = 'e93fcad4de714105838d45104c15e061';
//   final String redirectUrl = 'com.example.mytone://callback';
//   final String spotifyApiBaseUrl = 'https://accounts.spotify.com/api';
//   final String spotifyPlaylistBaseUrl =
//       'https://api.spotify.com/v1/me/playlists';
//   final String spotifyTrackBaseUrl = 'https://api.spotify.com/v1/playlists';
//   final String spotifyBaseUrl = 'https://accounts.spotify.com';
//   final String requestToken = 'https://accounts.spotify.com/api/token';
//
//   String requestAuthorization() =>
//       'https://accounts.spotify.com/authorize?client_id=$clientID&response_type=code&redirect_uri=$redirectUrl&scope=${_scopes.join('%20')}';
//
//   Future<List<String>> getAccessToken(String code) async {
//     final Map<String, String> headers = {
//       'Authorization':
//           "Basic ${base64.encode(utf8.encode("$clientID:$clientSecret"))}",
//     };
//
//     final Map<String, String> body = {
//       'grant_type': 'authorization_code',
//       'code': code,
//       'redirect_uri': redirectUrl
//     };
//
//     try {
//       final Uri path = Uri.parse(requestToken);
//       final response = await post(path, headers: headers, body: body);
//       // print(response.statusCode);
//       if (response.statusCode == 200) {
//         final Map result = jsonDecode(response.body) as Map;
//         return <String>[
//           result['access_token'].toString(),
//           result['refresh_token'].toString()
//         ];
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//     return [];
//   }
//
//   Future<List> getUserPlaylists(String accessToken) async {
//     try {
//       final Uri path = Uri.parse('$spotifyPlaylistBaseUrl?limit=50');
//
//       final response = await get(
//         path,
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           'Accept': 'application/json'
//         },
//       );
//       if (response.statusCode == 200) {
//         final result = jsonDecode(response.body);
//         final List playlists = result['items'] as List;
//         return playlists;
//       }
//     } catch (e) {
//       // print('Error: $e');
//     }
//     return [];
//   }
//
//   Future<Map> getTracksOfPlaylist(
//       String accessToken, String playListId, int offset) async {
//     try {
//       final Uri path = Uri.parse(
//           '$spotifyTrackBaseUrl/$playListId/tracks?limit=100&offset=$offset');
//       final response = await get(
//         path,
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           'Accept': 'application/json'
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final result = jsonDecode(response.body);
//         final List tracks = result['items'] as List;
//         final int total = result['total'] as int;
//         return {'tracks': tracks, 'total': total};
//       }
//     } catch (e) {
//       // print('Error: $e');
//     }
//     return {};
//   }
// }

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

/// A [StatefulWidget] which uses:
/// * [spotify_sdk](https://pub.dev/packages/spotify_sdk)
/// to connect to Spotify and use controls.
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = false;
  bool _connected = false;
  final Logger _logger = Logger(
    //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
    printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true,
    ),
  );

  CrossfadeState? crossfadeState;
  late ImageUri? currentTrackImageUri;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('SpotifySdk Example'),
              actions: [
                _connected
                    ? IconButton(
                        onPressed: disconnect,
                        icon: const Icon(Icons.exit_to_app),
                      )
                    : Container()
              ],
            ),
            body: _sampleFlowWidget(context),
            bottomNavigationBar: _connected ? _buildBottomBar(context) : null,
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.queue_music),
                onPressed: queue,
              ),
              IconButton(
                icon: Icon(Icons.playlist_play),
                onPressed: play,
              ),
              IconButton(
                icon: Icon(Icons.repeat),
                onPressed: toggleRepeat,
              ),
              IconButton(
                icon: Icon(Icons.shuffle),
                onPressed: toggleShuffle,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: addToLibrary,
                icon: Icon(Icons.favorite),
              ),
              IconButton(
                onPressed: () => checkIfAppIsActive(context),
                icon: Icon(Icons.info),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sampleFlowWidget(BuildContext context2) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: connectToSpotifyRemote,
                  child: const Icon(Icons.settings_remote),
                ),
                TextButton(
                  onPressed: getAuthenticationToken,
                  child: const Text('get auth token '),
                ),
              ],
            ),
            const Divider(),
            const Text(
              'Player State',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _connected
                ? _buildPlayerStateWidget()
                : const Center(
                    child: Text('Not connected'),
                  ),
            const Divider(),
            const Text(
              'Player Context',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _connected
                ? _buildPlayerContextWidget()
                : const Center(
                    child: Text('Not connected'),
                  ),
            const Divider(),
            const Text(
              'Player Api',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: seekTo,
                  child: const Text('seek to 20000ms'),
                ),
                TextButton(
                  onPressed: seekToRelative,
                  child: const Text('seek to relative 20000ms'),
                ),
              ],
            ),
            const Divider(),
            const Text(
              'Crossfade State',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: getCrossfadeState,
              child: const Text(
                'get crossfade state',
              ),
            ),
            // ignore: prefer_single_quotes
            Text("Is enabled: ${crossfadeState?.isEnabled}"),
            // ignore: prefer_single_quotes
            Text("Duration: ${crossfadeState?.duration}"),
          ],
        ),
        _loading
            ? Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()))
            : const SizedBox(),
      ],
    );
  }

  Widget _buildPlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        var track = snapshot.data?.track;
        currentTrackImageUri = track?.imageUri;
        var playerState = snapshot.data;

        if (playerState == null || track == null) {
          return Center(
            child: Container(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: skipPrevious,
                ),
                playerState.isPaused
                    ? IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: resume,
                      )
                    : IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: pause,
                      ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: skipNext,
                ),
              ],
            ),
            Text(
                '${track.name} by ${track.artist.name} from the album ${track.album.name}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Playback speed: ${playerState.playbackSpeed}'),
                Text(
                    'Progress: ${playerState.playbackPosition}ms/${track.duration}ms'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Paused: ${playerState.isPaused}'),
                Text('Shuffling: ${playerState.playbackOptions.isShuffling}'),
              ],
            ),
            Text('RepeatMode: ${playerState.playbackOptions.repeatMode}'),
            Text('Image URI: ${track.imageUri.raw}'),
            Text('Is episode? ${track.isEpisode}'),
            Text('Is podcast? ${track.isPodcast}'),
            _connected
                ? spotifyImageWidget(track.imageUri)
                : const Text('Connect to see an image...'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const Text(
                  'Set Shuffle and Repeat',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    const Text(
                      'Repeat Mode:',
                    ),
                    DropdownButton<RepeatMode>(
                      value: RepeatMode
                          .values[playerState.playbackOptions.repeatMode.index],
                      items: const [
                        DropdownMenuItem(
                          value: RepeatMode.off,
                          child: Text('off'),
                        ),
                        DropdownMenuItem(
                          value: RepeatMode.track,
                          child: Text('track'),
                        ),
                        DropdownMenuItem(
                          value: RepeatMode.context,
                          child: Text('context'),
                        ),
                      ],
                      onChanged: (repeatMode) => setRepeatMode(repeatMode!),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Set shuffle: '),
                    Switch.adaptive(
                      value: playerState.playbackOptions.isShuffling,
                      onChanged: (bool shuffle) => setShuffle(
                        shuffle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayerContextWidget() {
    return StreamBuilder<PlayerContext>(
      stream: SpotifySdk.subscribePlayerContext(),
      initialData: PlayerContext('', '', '', ''),
      builder: (BuildContext context, AsyncSnapshot<PlayerContext> snapshot) {
        var playerContext = snapshot.data;
        if (playerContext == null) {
          return const Center(
            child: Text('Not connected'),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Title: ${playerContext.title}'),
            Text('Subtitle: ${playerContext.subtitle}'),
            Text('Type: ${playerContext.type}'),
            Text('Uri: ${playerContext.uri}'),
          ],
        );
      },
    );
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Getting image...')),
            );
          }
        });
  }

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: '57309563b48f43b4955fac060aea6cf4',
          redirectUrl: 'com.example.mytone://callback');
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<String> getAuthenticationToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAuthenticationToken(
          clientId: '57309563b48f43b4955fac060aea6cf4',
          redirectUrl: 'com.example.mytone://callback',
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      setStatus('Got a token: $authenticationToken');
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }

  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future getCrossfadeState() async {
    try {
      var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
      setState(() {
        crossfadeState = crossfadeStateValue;
      });
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setShuffle(bool shuffle) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> checkIfAppIsActive(BuildContext context) async {
    try {
      var isActive = await SpotifySdk.isSpotifyAppActive;
      final snackBar = SnackBar(
          content: Text(isActive
              ? 'Spotify app connection is active (currently playing)'
              : 'Spotify app connection is not active (currently not playing)'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
