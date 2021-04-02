import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/app_logics/models/user_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/user_box.dart';

class SearchedArtists extends StatelessWidget {
  final List<UserModel> artistList;
  final FocusNode searchNode;

  SearchedArtists({
    this.artistList,
    this.searchNode,
  });

  @override
  Widget build(BuildContext context) {
    return artistList.isEmpty
        ? CustomError(
            title: 'No Artist Found',
            subTitle: 'Please search again with another artist name.',
            buttonLabel: 'SEARCH',
            onPressed: () {
              searchNode.requestFocus();
            },
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Column(
                children: artistList
                    .map(
                      (user) => UserBox(
                        user: user,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }
}
