import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/album_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class UploadedAlbums extends StatelessWidget {
  PanelController _panelController = PanelController();

  List<AlbumModel> _allAlbums = [
    AlbumModel(albumName: 'adasda', albumSongs: ['', '']),
    AlbumModel(albumName: 'adasda', albumSongs: ['', '']),
    AlbumModel(albumName: 'adasda', albumSongs: ['', '']),
  ];

  Widget _showErrorMessage() {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        CustomError(
          title: 'No Albums',
          subTitle:
              'There are no albums of your own. Please create one to view here.',
          buttonLabel: 'CREATE ALBUM',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _createNewPlaylist() {
    return InkWell(
      onTap: () {
        _panelController.open();
      },
      child: Row(
        children: [
          Spacer(),
          SvgPicture.asset('assets/icons/plus_circle.svg'),
          SizedBox(width: 10),
          Text(
            'Create New Album',
            style: normalFontStyle,
          ),
          SizedBox(width: 20)
        ],
      ),
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

  Widget _albumImage(AlbumModel album) {
    return Image.network(
      'https://miro.medium.com/max/3840/1*LPESvqEeQ9V3DAx-6cD6SQ.jpeg',
      height: 97,
      width: Size.infinite.width,
      fit: BoxFit.cover,
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

  Widget _albumName(AlbumModel album) {
    return Text(
      album.albumName,
      style: normalFontStyle.copyWith(
        fontWeight: FontWeight.w700,
        color: whitishColor,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _albumSongsLength(AlbumModel album) {
    return Text(
      '${album.albumSongs.length.toString()} songs',
      style: normalFontStyle.copyWith(
        fontSize: 13,
        color: whitishColor.withOpacity(0.7),
      ),
    );
  }

  Widget _albumBox(AlbumModel album) {
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
              _albumImage(album),
              _gradientEffect(),
              Positioned(
                left: 10,
                bottom: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _albumName(album),
                    _albumSongsLength(album),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showAlbums() {
    return Column(
      children: _allAlbums
          .map(
            (album) => _albumBox(album),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _createNewPlaylist(),
          SizedBox(
            height: 20,
          ),
          _allAlbums.length == 0 ? _showErrorMessage() : _showAlbums(),
        ],
      ),
    );
  }
}
