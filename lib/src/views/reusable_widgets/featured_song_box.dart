import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class FeaturedSongBox extends StatelessWidget {
  final String imageURL;
  final String songName;
  final String artistName;
  final String songPlace;

  FeaturedSongBox(
      {this.imageURL, this.songName, this.artistName, this.songPlace});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 180,
              color: textFieldColor,
              child: Center(
                child: Icon(
                  Icons.image,
                  color: mainColor,
                  size: 50,
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageURL,
              height: 180,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      backgroundColor.withOpacity(0.5),
                    ]),
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 8,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songName,
                    style: normalFontStyle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: whitishColor,
                        fontSize: 20,
                        letterSpacing: 0.5),
                  ),
                  Row(
                    children: [
                      Text(
                        artistName,
                        style: normalFontStyle.copyWith(
                          fontSize: 15,
                          color: whitishColor.withOpacity(0.7),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          Icons.circle,
                          size: 5,
                          color: whitishColor.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        songPlace,
                        style: normalFontStyle.copyWith(
                          fontSize: 15,
                          color: whitishColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
