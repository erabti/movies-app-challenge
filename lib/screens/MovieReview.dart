import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieReviewScreen extends StatefulWidget {
  Map movie;
  MovieReviewScreen(this.movie);
  @override
  _MovieReviewScreenState createState() => _MovieReviewScreenState();
}

class _MovieReviewScreenState extends State<MovieReviewScreen> {
  @override
  Widget build(BuildContext context) {
    Image poster() {
      var imageUrl = 'https://image.tmdb.org/t/p/w500/';
      var posterPath = widget.movie['poster_path'];
      var poster = posterPath != null
          ? imageUrl + posterPath
          : "https://cdn3.iconfinder.com/data/icons/abstract-1/512/no_image-512.png";

      return Image.network(
        poster,
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.fill,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(widget.movie['title']),
      ),
      body: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: poster(),
                clipBehavior: Clip.hardEdge,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Card(
                    elevation: 12.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 12.0, top: 6.0),
                          child: Container(
                            child: Padding(
                                padding: EdgeInsets.all(3.5),
                                child: Text(
                                  widget.movie['release_date'],
                                  style: TextStyle(color: Colors.white),
                                )),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 2, right: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            child: Text(
                              widget.movie['overview'],
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  "Rating:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(4.5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border: Border.all(),
                                  ),
                                  child: Text(
                                    widget.movie['vote_average'].toString(),
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white),
                                  ))
                            ],
                          ),
                        )),
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  "Votes Count:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Text(
                                widget.movie['vote_count'].toString(),
                                style: TextStyle(fontSize: 18.0),
                              )
                            ],
                          ),
                        )),
                        Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Text(
                                      "Popularity:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  Text(
                                    widget.movie['popularity'].toString(),
                                    style: TextStyle(fontSize: 18.0),
                                  )
                                ],
                              ),
                            ))
                      ],
                    )),
              ),
            ],
          )),
    );
  }
}
