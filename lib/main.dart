///This project was made by Ahmed Erabti as a challenge for Averto.
///This is the entry point, there will be a description in each file showing its
///usages.
import 'package:flutter/material.dart'; //the main flutter SDK material components

import 'package:movie_challenge_averto/screens/WelcomeScreen.dart';

//main() is called in app entry. runApp attaches given widget as the root widget
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //the root widget, returns a MaterialApp obj


  @override
  Widget build(BuildContext context) {
    //build() is called when building the widget
    return MaterialApp(
      //special Material widget that controls app settings
      title: 'Movie App',
      debugShowCheckedModeBanner: false, //to disable the debug banner
      theme: ThemeData(fontFamily: "Arvo" //sets the default font in app
          ),
      home: WelcomeScreen(), //attaches HomeScreen widget as home
    );
  }
}
