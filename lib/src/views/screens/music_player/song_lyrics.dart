import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class SongLyrics extends StatelessWidget {
  final SongModel song;

  SongLyrics({this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomAppBar(
                  label: 'Lyrics',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: darkGreyColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              song.songName,
                              style: normalFontStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: whitishColor,
                                  fontSize: 22,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
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
                ),
                SizedBox(height: 20,),
                Text(
                  song.songLyrics,
                  style: normalFontStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
