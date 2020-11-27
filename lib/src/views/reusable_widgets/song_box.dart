import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class SongBox extends StatelessWidget {
  final String imageURL;
  final String songName;
  final String artistName;
  final String songPlace;

  SongBox({this.imageURL, this.songName, this.artistName, this.songPlace});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: Container(
        height: 97,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: textFieldColor,
                child: Center(
                  child: Icon(
                    Icons.image,
                    color: mainColor,
                    size: 40,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageURL,
                width: width,
                fit: BoxFit.cover,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        backgroundColor.withOpacity(0.7),
                      ]),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 5,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songName,
                      style: normalFontStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          color: whitishColor,
                          fontSize: 16,
                          letterSpacing: 0.5),
                    ),
                    Row(
                      children: [
                        Text(
                          artistName,
                          style: normalFontStyle.copyWith(
                            fontSize: 13,
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
                            fontSize: 13,
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
      ),
    );
  }
}
