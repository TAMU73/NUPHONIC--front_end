import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'file:///C:/Users/DELL/Desktop/FYP/NUPHONIC%20-%20front_end/lib/src/views/screens/music/music_player.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class FeaturedSongBox extends StatelessWidget {
  final SongModel song;

  FeaturedSongBox({this.song});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Get.to(MusicPlayer(
          song: song,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 180,
            child: Stack(
              children: [
                Container(
                  color: textFieldColor,
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: mainColor,
                      size: 50,
                    ),
                  ),
                ),
                Image.network(
                  song.songImage,
                  height: 180,
                  width: width,
                  fit: BoxFit.cover,
                ),
                Container(
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
                Positioned(
                  left: 10,
                  bottom: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.songName,
                        style: normalFontStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: whitishColor,
                            fontSize: 20,
                            letterSpacing: 0.5),
                      ),
                      Row(
                        children: [
                          Text(
                            song.artistName,
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
                            song.albumName,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
