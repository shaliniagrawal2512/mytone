import 'package:flutter/material.dart';
import 'package:mytone/screens/homeScreen.dart';
import 'package:mytone/screens/top_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/login_screen.dart';
import 'screens/phonenum_screen.dart';
import 'screens/music_player_screen.dart';
import 'screens/searchScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tone',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: TopScreen.id,
      routes: {
        TopScreen.id: (context) => TopScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        PhoneScreen.id: (context) => PhoneScreen(),
        MusicPlayer.id: (context) => MusicPlayer(),
        HomeScreen.id: (context) => HomeScreen(),
        SearchScreen.id: (context) => SearchScreen(),
      },
    );
  }
}
