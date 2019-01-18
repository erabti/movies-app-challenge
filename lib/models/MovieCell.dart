import 'package:flutter/material.dart';

class MovieCell extends StatelessWidget {
  final movies;
  final i;
  final Color mainColor = const Color(0xff3C3261);
  final imageUrl = 'https://image.tmdb.org/t/p/w500/';
  MovieCell(this.movies, this.i);

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration() {
      var posterPath = movies[i]['poster_path'];
      var poster = posterPath != null
          ? imageUrl+posterPath
          : "https://cdn3.iconfinder.com/data/icons/abstract-1/512/no_image-512.png";

      return BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey,
        image: DecorationImage(image: NetworkImage(poster), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(color: mainColor, blurRadius: 5.0, offset: Offset(2.0, 5.0))
        ],
      );
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                margin: const EdgeInsets.all(16.0),
                child: Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: boxDecoration(),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  children: [
                    Text(
                      movies[i]['title'],
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Arvo',
                          fontWeight: FontWeight.w700,
                          color: mainColor),
                    ),
                    Padding(padding: const EdgeInsets.all(2.0)),
                    Text(
                      movies[i]['overview'],
                      maxLines: 3,
                      style: TextStyle(
                          color: const Color(0xff8785A4), fontFamily: 'Arvo'),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
          ],
        ),
        Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
    );
  }
}
