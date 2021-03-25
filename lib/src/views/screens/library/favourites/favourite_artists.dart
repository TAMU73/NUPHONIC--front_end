import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class FavouriteArtists extends StatefulWidget {
  @override
  _FavouriteArtistsState createState() => _FavouriteArtistsState();
}

class _FavouriteArtistsState extends State<FavouriteArtists>
    with AutomaticKeepAliveClientMixin<FavouriteArtists> {

  @override
  bool get wantKeepAlive => true;

  List<String> _favouriteArtists = ['', ''];

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

  Widget _artistImage() {
    return CircleAvatar(
      radius: 28,
      backgroundColor: textFieldColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: textFieldColor,
              child: Icon(
                Icons.person_outline_outlined,
                color: mainColor,
                size: 30,
              ),
            ),
            Image.network(
              'https://miro.medium.com/max/3840/1*LPESvqEeQ9V3DAx-6cD6SQ.jpeg',
              height: 56,
              fit: BoxFit.cover,
            ),
            // profilePicture == null ? SizedBox() : Image.network(profilePicture),
          ],
        ),
      ),
    );
  }

  Widget _artistName() {
    return Text(
      'Vanilla',
      style: normalFontStyle.copyWith(fontSize: 20),
    );
  }

  Widget _favouriteArtistBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 60,
          child: Row(
            children: [
              _artistImage(),
              SizedBox(
                width: 10,
              ),
              _artistName(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showArtists() {
    return Column(
      children: _favouriteArtists
          .map(
            (artist) => _favouriteArtistBox(),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _favouriteArtists.length == 0
          ? _showErrorMessage()
          : Column(children: [
              SizedBox(
                height: 20,
              ),
              _showArtists()
            ]),
    );
  }
}
