import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  WelcomeScreenState createState() {
    return new WelcomeScreenState();
  }
}

class WelcomeScreenState extends State<WelcomeScreen> {
  Future<bool> _showWelcome;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Null> setFlag() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('showWelcome', false);
  }

  @override
  void initState() {
    super.initState();
    _showWelcome = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('showWelcome') ?? true;
    });
  }

  var pages = [
    PageViewModel(
      mainImage: Image.asset('assets/movie_seats.png'),
      pageColor: Colors.yellow.shade700,
      title: Text("Welcome!"),
      body: Text("Easily search thousands of movies at your fingerprint."),
      textStyle: TextStyle(fontFamily: 'Arvo', color: Colors.white),
      bubble: Image.asset("assets/small_chairs.png"),
    ),
    PageViewModel(
      pageColor: const Color(0xFF03A9F4),
      mainImage: Image.asset('assets/showcase.jpg'),
      title: Text("Stay Tuned!"),
      body: Text("Check the Latest and Greatest."),
      textStyle: TextStyle(fontFamily: 'Arvo', color: Colors.white),
      bubble: Image.asset("assets/small_clapper.png"),
    ),
    PageViewModel(
      pageColor: const Color(0xFF600620),
      mainImage: Image.asset('assets/movie_retro.png'),
      title: Text("Re-watch!"),
      body: Text("Check retro movies that never collect dust!"),
      textStyle: TextStyle(fontFamily: 'Arvo', color: Colors.white),
      bubble: Image.asset("assets/small_glasses.png"),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _showWelcome,
        builder: (context, snapshot) {
          if (snapshot.data==true){
            return IntroViewsFlutter(
              pages,
              onTapDoneButton: () {
                setFlag();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              showSkipButton: true,
              pageButtonTextStyles: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            );
          } else {
            return HomeScreen();
          }
        });
  }
}
