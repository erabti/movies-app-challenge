import 'package:flushbar/flushbar.dart';

///Here we're going to take care of the main home screen UI only (try to)
///This widget (screen) takes care of pages navigation, and it loads movies data

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flip_box_bar/flip_box_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

import 'package:movie_challenge_averto/models/MovieList.dart';
import 'package:movie_challenge_averto/screens/InfoScreen.dart';
import 'package:movie_challenge_averto/utils/api_handler.dart';
import 'package:movie_challenge_averto/screens/SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; //keeps record of current page index
  MovieListPage topMoviePage, newMoviePage, retroMoviePage;
  List<Widget> pages;
  Widget _currentPage;
  bool _loadingInProgress;
  bool _isConnected; //tracks if there's a network

  void _onTabTapped(int index) {
    //handles the bottom bar, index is for page index
    if (this.mounted) {
      //make sure this object (page) is mounted
      setState(() {
        //redraw the state widget
        _currentIndex = index; //sets the _currentIndex to thetapped tab index
        _currentPage = pages[_currentIndex];
      });
    }
  }

  Future<Null> _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _isConnected = connectivityResult != ConnectivityResult.none;
  }

  Future<bool> checkConnectivity([shownDialog = false]) async {
    await _checkConnection();

    if (!_isConnected) {
      if (!shownDialog)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            shownDialog = true;
            // return object of type Dialog
            return AlertDialog(
              title: Row(
                children: <Widget>[
                  Icon(Icons.error),
                  Text(
                    "   Ooops! 😅",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              content: Text(
                  "Something went wrong with your connection.\nMake sure that WiFi or data mobile is turned on, and try again."),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                FlatButton(
                  child: Text("RETRY"),
                  onPressed: () async {
                    await _checkConnection();
                    if (_isConnected) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      await Future.delayed(Duration(seconds: 3));
      return await checkConnectivity(shownDialog);
    } else {
      return true;
    }
  }
  Flushbar flushbar = Flushbar(isDismissible:false,aroundPadding: EdgeInsets.only(bottom:60),);
  Future<List<Map>> getMovies([shownDialog = true]) async {
    try {
      var topMoviesData =
          await requestMovies("https://api.themoviedb.org/3/discover/movie?"
              "api_key="
              "68fad02598f326ac555e3abc98deb428");
      var newMoviesData =
          await requestMovies("https://api.themoviedb.org/3/discover/movie?"
              "sort_by=release_date.desc&api_key="
              "68fad02598f326ac555e3abc98deb428");
      var retroMoviesData =
          await requestMovies("https://api.themoviedb.org/3/discover/movie?"
              "sort_by=release_date.asc&api_key="
              "68fad02598f326ac555e3abc98deb428");
      await flushbar.dismiss();
      return [topMoviesData, newMoviesData, retroMoviesData];
    } catch (e) {
      if (shownDialog) {
        flushbar
          ..message = "There's no internet connection."
          ..icon = Icon(
            Icons.error,
            size: 28.0,
            color: Colors.red[300],
          )
          ..leftBarIndicatorColor = Colors.red[300]
          ..show(context);
        shownDialog = false;
      }

      await Future.delayed(Duration(seconds: 3));
      return await getMovies(shownDialog);
    }
  }

  Future<void> getAPIData() async {
    //asynchronous api requests:
    bool connected = await checkConnectivity();
    if (!connected) return;
    //Assigning respective json data to their MovieListPage objs
    var movies = await getMovies();
    var topMoviesData = movies[0];
    var newMoviesData = movies[1];
    var retroMoviesData = movies[2];

    topMoviePage = MovieListPage(
      "Top Rated",
      topMoviesData['results'],
      key: PageStorageKey("topKey"),
    );
    newMoviePage = MovieListPage(
      "The Latest",
      newMoviesData['results'],
      key: PageStorageKey("latestKey"),
    );
    retroMoviePage = MovieListPage(
      "Old is Gold!",
      retroMoviesData['results'],
      key: PageStorageKey("retroKey"),
    );
    pages = [topMoviePage, newMoviePage, retroMoviePage];
    if (this.mounted)
      setState(() {
        _loadingInProgress = false;
        _currentPage = topMoviePage;
      });
  }

  Widget _buildBody() {
    if (_loadingInProgress) {
      return Center(
        child: SpinKitChasingDots(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.red : Colors.green,
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      );
    } else {
      return _currentPage;
    }
  }

  @override
  void initState() {
    //called only once, before build called
    super.initState();
    _loadingInProgress = true;
    getAPIData(); //gets data only once
  }

  @override
  Widget build(BuildContext context) {
    //here where UI happens
    List<Widget> getTitleList() {
      List<Widget> result = [];
      for (String l in "MOVIES".split('')) {
        Color color;
        switch (l) {
          case "M":
            {
              color = Colors.blue;
            }
            break;
          case "O":
            {
              color = Colors.yellow;
            }
            break;
          case "V":
            {
              color = Colors.green;
            }
            break;
          case "I":
            {
              color = Colors.red;
            }
            break;
          case "E":
            {
              color = Colors.purple;
            }
            break;
          case "S":
            {
              color = Colors.pinkAccent;
            }
            break;
        }
        result.add(Text(
          l,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w700, fontFamily: "Arvo"),
        ));
      }
      return result;
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => InfoScreen())),
            icon: Icon(
              FontAwesomeIcons.info,
              color: Colors.orange,
            ),
            padding: EdgeInsets.all(3),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: Icon(
                FontAwesomeIcons.search,
                color: Colors.orange,
              ),
              padding: EdgeInsets.all(3),
            ),
          ],
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getTitleList(),
          ),
          elevation: 0.3,
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: FlipBoxBar(
          animationDuration: Duration(milliseconds: 700),
          initialIndex: _currentIndex,
          onIndexChanged: _onTabTapped,
          navBarHeight: 60.0,
          items: [
            FlipBarItem(
              text: Text("Top"),
              icon: Icon(Icons.movie),
              frontColor: Colors.cyan,
              backColor: Colors.cyanAccent,
            ),
            FlipBarItem(
              text: Text("Latest"),
              icon: Icon(Icons.fiber_new),
              frontColor: Colors.pink,
              backColor: Colors.pinkAccent,
            ),
            FlipBarItem(
              text: Text("Retro"),
              icon: Icon(FontAwesomeIcons.anchor),
              frontColor: Colors.purple,
              backColor: Colors.purpleAccent,
            ),
          ],
        ),
        body: _buildBody());
  }
}
