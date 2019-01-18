///This is the model for the pages inside the HomeScreen, it gets json data for
///movies and turn them into widgets
import 'package:flutter/material.dart';

import 'MovieTitle.dart';
import 'MovieCell.dart';
import 'package:movie_challenge_averto/screens/MovieReview.dart';

class MovieListPage extends StatefulWidget {
  final String title;
  final movies;
  MovieListPage(this.title, this.movies, {Key key}) : super(key: key);

  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  Future<void> _onRefresh() async {
    //on pulling down to refresh
    await Future.delayed(Duration(milliseconds: 1250)); //fake refreshing
  }

  bool builtMovieTitle = false; //a workaround to put  movie title up the list
  @override
  void initState() {
    builtMovieTitle = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    builtMovieTitle = false; //a workaround to put  movie title up the list

    List<Widget> moviesList = List.generate(widget.movies.length, (i) {
      return FlatButton(
        //making movie cells pressable
        onPressed: () {
          //on movie cell pressed
          Navigator.push(
            //navigates to
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MovieReviewScreen(widget.movies[i])));
        }, //onPressed
        child: MovieCell(widget.movies, i),
        padding: const EdgeInsets.all(0.0),
        color: Colors.white,
      );
    });
    moviesList.insert(0, MovieTitle(widget.title,Colors.purple));

    return RefreshIndicator(
      //this widget keep track of pulling down events
      backgroundColor: Colors.lime,
      displacement: 80.0,
      onRefresh: _onRefresh,
      child: ListView(
        key: UniqueKey(),
        children: moviesList,
      ),
    );
  }
}
