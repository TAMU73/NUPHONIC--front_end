import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';

class SearchedSongs extends StatelessWidget {
  final List<SongModel> songList;
  final FocusNode searchNode;

  SearchedSongs({
    this.songList,
    this.searchNode,
  });

  @override
  Widget build(BuildContext context) {
    return songList.isEmpty
        ? CustomError(
            title: 'No Song Found',
            subTitle: 'Please search again with another song name.',
            buttonLabel: 'SEARCH',
            onPressed: () {
              searchNode.requestFocus();
            },
          )
        : SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: songList
                    .map(
                      (song) => SongBox(
                        song: song,
                      ),
                    )
                    .toList(),
              ),
            ),
        );
  }
}
