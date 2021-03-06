import 'package:flutter/material.dart';
import 'package:mytone/screens/BottomNavigation.dart';
import 'package:mytone/screens/Forget_Password.dart';
import 'package:mytone/screens/about.dart';
import 'package:mytone/screens/changePassword.dart';
import 'package:mytone/screens/downloads.dart';
import 'package:mytone/screens/header.dart';
import 'package:mytone/screens/homeScreen.dart';
import 'package:mytone/screens/music_library.dart';
import 'package:mytone/screens/profile.dart';
import 'package:mytone/screens/top_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/playlist.dart';
import 'screens/playlist.dart';
import 'screens/registration_screen.dart';
import 'screens/login_screen.dart';
import 'screens/phonenum_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var phoneNumber = prefs.getString('phoneNumber');
  var email = prefs.getString('email');
  runApp(MyApp(phoneNumber: phoneNumber, email: email));
}

class MyApp extends StatelessWidget {
  MyApp({this.phoneNumber, this.email});
  final email;
  final phoneNumber;
  @override
  Widget build(BuildContext context) {
    String getInitialRoute() {
      if (email == null && phoneNumber == null) {
        return TopScreen.id;
      } else
        return BottomNavigation.id;
    }

    return ChangeNotifierProvider(
        create: (context) => PlayListAdd(),
        child: MaterialApp(
          title: 'My Tone',
          theme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark().copyWith(primary: Colors.white)),
          debugShowCheckedModeBanner: false,
          initialRoute: getInitialRoute(),
          routes: {
            TopScreen.id: (context) => TopScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
            PhoneScreen.id: (context) => PhoneScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            BottomNavigation.id: (context) => BottomNavigation(),
            ForgotPassword.id: (context) => ForgotPassword(),
            MusicLibrary.id: (context) => MusicLibrary(),
            About.id: (context) => About(),
            Downloads.id: (context) => Downloads(),
            Header.id: (context) => Header(),
            PlayList.id: (context) => PlayList(),
            ChangePassword.id: (context) => ChangePassword(),
            Profile.id: (context) => Profile(),
          },
        ));
  }
}
