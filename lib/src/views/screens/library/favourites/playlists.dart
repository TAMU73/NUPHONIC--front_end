import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/playlist_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class Playlists extends StatelessWidget {
  List<PlaylistModel> _allPlaylists = [
    PlaylistModel(
      playlistName: 'Chill',
      playlistSongs: ['asdsadlasd', 'djfkahjkhas'],
    ),
    PlaylistModel(
      playlistName: 'Chill',
      playlistSongs: ['asdsadlasd', 'djfkahjkhas'],
    ),
    PlaylistModel(
      playlistName: 'Chill',
      playlistSongs: ['asdsadlasd', 'djfkahjkhas', ''],
    ),
  ];

  Widget _createNewPlaylist() {
    return Row(
      children: [
        Spacer(),
        SvgPicture.asset('assets/icons/plus_circle.svg'),
        SizedBox(
          width: 10,
        ),
        Text(
          'Create New Playlist',
          style: normalFontStyle,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Widget _showErrorMessage() {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        CustomError(
          title: 'No Playlist',
          subTitle:
              'There are no playlist of your own. Please create one to view here.',
          buttonLabel: 'Create Playlist',
          onPressed: () {},
        ),
      ],
    );
  }

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

  Widget _playlistSongs() {
    return Row(
      children: [
        Flexible(
            flex: 1,
            child: Image.network(
              'https://miro.medium.com/max/3840/1*LPESvqEeQ9V3DAx-6cD6SQ.jpeg',
              height: 97,
              fit: BoxFit.cover,
            )),
        Flexible(
            flex: 1,
            child: Image.network(
              'https://ca-times.brightspotcdn.com/dims4/default/0b6a1bb/2147483647/strip/true/crop/1920x804+0+0/resize/1486x622!/quality/90/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2Fdd%2Ffd%2F6078aad94b96a2b9f7919ac74826%2Ffrozen-2-online-use-213-62-56.jpg',
              height: 97,
              fit: BoxFit.cover,
            )),
        Flexible(
          flex: 1,
          child: Image.network(
            'https://miro.medium.com/max/3840/1*LPESvqEeQ9V3DAx-6cD6SQ.jpeg',
            height: 97,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _gradientEffect() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              backgroundColor.withOpacity(0.7),
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
    return Text(
      '${playlist.playlistSongs.length.toString()} songs',
      style: normalFontStyle.copyWith(
        fontSize: 13,
        color: whitishColor.withOpacity(0.7),
      ),
    );
  }

  Widget _showPlaylists() {
    return Container(
      child: Column(
        children: _allPlaylists
            .map(
              (playlist) => _playlistBox(playlist),
            )
            .toList(),
      ),
    );
  }

  Widget _playlistBox(PlaylistModel playlist) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 97,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              _imageDummy(),
              _playlistSongs(),
              _gradientEffect(),
              Positioned(
                  left: 10,
                  bottom: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _playlistName(playlist),
                      _playlistSongsLength(playlist)
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        _createNewPlaylist(),
        SizedBox(
          height: 20,
        ),
        _allPlaylists.length == 0 ? _showErrorMessage() : _showPlaylists(),
      ]),
    );
  }
}
