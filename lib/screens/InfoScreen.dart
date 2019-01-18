import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class InfoScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.info),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30),
              alignment: Alignment.center,
              width: 300,
              child: ColorizeAnimatedTextKit(text:['   MOVIES','TRAILERS','TV SHOWS']
                ,duration: Duration(seconds: 10),
              colors: [Colors.blue,Colors.red,Colors.green,Colors.purple,Colors.yellowAccent,Colors.lime,Colors.deepOrange],
                textStyle: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
              )
            ),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/averto_logo.png'),
                  fit: BoxFit.fill,
                )
                    ,shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("This app was made by: "),
                  TyperAnimatedTextKit(text: ['Ahmed Erabti. ❤',""],textStyle: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}