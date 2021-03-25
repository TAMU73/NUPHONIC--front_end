import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';

class FavouriteSongs extends StatefulWidget {
  @override
  _FavouriteSongsState createState() => _FavouriteSongsState();
}

class _FavouriteSongsState extends State<FavouriteSongs>
    with AutomaticKeepAliveClientMixin<FavouriteSongs> {

  @override
  bool get wantKeepAlive => true;

  List<SongModel> _favouriteSongs = [
    SongModel(
      songImage: '',
      songName: 'Sample',
      artistName: 'Sample',
      albumName: 'Sample',
      songURL: '',
    ),
    SongModel(
      songImage: '',
      songName: 'Sample',
      artistName: 'Sample',
      albumName: 'Sample',
      songURL: '',
    ),
  ];

  Widget _showErrorMessage() {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        CustomError(
          title: 'No Favourite Artist',
          subTitle:
              'Check out some artist and mark them as favourite to see here.',
        ),
      ],
    );
  }

  Widget _showSongs() {
    return Column(
      children: _favouriteSongs
          .map(
            (song) => SongBox(song: song),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _favouriteSongs.length == 0
          ? _showErrorMessage()
          : Column(children: [
              SizedBox(
                height: 20,
              ),
              _showSongs()
            ]),
    );
    ;
  }
}
