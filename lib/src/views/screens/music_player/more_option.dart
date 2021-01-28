import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/views/screens/music/album_profile.dart';
import 'package:nuphonic_front_end/src/views/screens/music/user_profile.dart';
import 'package:nuphonic_front_end/src/views/screens/music_player/song_description.dart';
import 'package:nuphonic_front_end/src/views/screens/music_player/song_lyrics.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MoreOption extends StatelessWidget {
  final PanelController controller;
  final SongModel song;

  MoreOption({this.controller, this.song});

  Widget moreTile({String title, Function onTap, String iconPath, bool isActive = true}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Opacity(
          opacity: isActive ? 1 : 0.5,
          child: Row(
            children: [
              SvgPicture.asset(iconPath),
              SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: normalFontStyle.copyWith(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SlidingUpPanel(
        color: Colors.transparent,
        backdropEnabled: true,
        controller: controller,
        minHeight: 0,
        maxHeight: 250,
        panel: Column(
          children: [
            Container(
              height: 40,
              width: width,
              decoration: BoxDecoration(
                color: darkGreyColor,
                borderRadius: bottomPanelBorderRadius,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 14,
                  ),
                  SvgPicture.asset('assets/icons/slide_icon.svg'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: darkGreyColor,
                child: Column(
                  children: [
                    moreTile(
                      title: 'Description',
                      iconPath: 'assets/icons/info.svg',
                      onTap: () {
                        Get.to(SongDescription(song: song,));
                      },
                    ),
                    moreTile(
                      title: 'View Artist',
                      iconPath: 'assets/icons/artist.svg',
                      onTap: () {
                        Get.off(UserProfile(userID: song.artistID,));
                      },
                    ),
                    moreTile(
                      title: 'View Album',
                      iconPath: 'assets/icons/album.svg',
                      isActive: song.albumID ==null ? false : true,
                      onTap: () {
                        song.albumID != null ? Get.off(AlbumProfile(albumID: song.albumID,)) : null;
                      },
                    ),
                    moreTile(
                      title: 'Lyrics',
                      iconPath: 'assets/icons/lyrics.svg',
                      isActive: song.songLyrics ==null ? false : true,
                      onTap: () {
                        song.songLyrics !=null ? Get.to(SongLyrics(song: song,)) : null;
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
