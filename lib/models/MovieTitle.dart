import 'package:flutter/material.dart';

class MovieTitle extends StatelessWidget {
  final Color mainColor;
  final String _title;

  MovieTitle(this._title, this.mainColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        _title,
        style: TextStyle(
            fontSize: 40.0,
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arvo'),
        textAlign: TextAlign.left,
      ),
    );
  }
}
