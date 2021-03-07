import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/app_logics/models/playlist_model.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class PlaylistBox extends StatelessWidget {
  final Function onPressed;
  final PlaylistModel playlist;
  final bool showLabel;
  PlaylistBox({
    this.onPressed,
    this.playlist,
    this.showLabel,
  });

  Widget _imageDummy() {
    return Container(
      color: textFieldColor,
      child: Center(
        child: Icon(
          Icons.image,
          color: mainColor,
          size: 40,
        ),
      ),
    );
  }

  Widget _playlistSongs(PlaylistModel playlist) {
    return playlist.playlistSongs.isEmpty
        ? Container(color: textFieldColor)
        : Row(
            children: playlist.playlistSongModel
                .map(
                  (song) => Flexible(
                    flex: 1,
                    child: Image.network(
                      song.songImage,
                      height: 97,
                      width:
                          Size.infinite.width / playlist.playlistSongs.length,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .toList());
  }

  Widget _gradientEffect() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              backgroundColor.withOpacity(0.8),
            ]),
      ),
    );
  }

  Widget _playlistName(PlaylistModel playlist) {
    return Text(
      playlist.playlistName,
      style: normalFontStyle.copyWith(
        fontWeight: FontWeight.w700,
        color: whitishColor,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _playlistSongsLength(PlaylistModel playlist) {
    String songOrSongs = playlist.playlistSongs.length > 1 ? 'songs' : 'song';
    return Row(
      children: [
        Text(
          '${playlist.playlistSongs.length.toString()} $songOrSongs',
          style: normalFontStyle.copyWith(
            fontSize: 13,
            color: whitishColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20,0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 97,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                _imageDummy(),
                _playlistSongs(playlist),
                playlist.playlistSongs.isNotEmpty
                    ? _gradientEffect()
                    : SizedBox(),
                showLabel == null || showLabel ? Positioned(
                  left: 10,
                  bottom: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _playlistName(playlist),
                      _playlistSongsLength(playlist),
                    ],
                  ),
                ) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
