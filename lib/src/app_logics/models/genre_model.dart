import 'package:flutter/material.dart';

class GenreModel {
  final String imageSrc;
  final String color;
  final String genreName;

  GenreModel({this.imageSrc, this.color, this.genreName});

  factory GenreModel.fromJson(Map<String, dynamic> data) {
    return GenreModel(
        genreName: data['genre_name'],
        color: data['color'],
        imageSrc: data['genre_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genre_name': genreName,
      'color': color,
      'genre_picture': imageSrc,
    };
  }
}
