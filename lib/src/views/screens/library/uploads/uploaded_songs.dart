import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';

class UploadedSongs extends StatelessWidget {
  List<SongModel> _uploadedSongs = [
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
          title: 'No Songs Found',
          subTitle:
          'You have not uploaded any song yet. Upload song to see here.',
          buttonLabel: 'UPLOAD',
        ),
      ],
    );
  }

  Widget _showSongs() {
    return Column(
      children: _uploadedSongs
          .map(
            (song) => SongBox(song: song),
      )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _uploadedSongs.length == 0
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
