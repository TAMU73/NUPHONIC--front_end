import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/album_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/album_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads/create_album.dart';
import 'package:nuphonic_front_end/src/views/screens/music/album_profile.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UploadedAlbums extends StatefulWidget {
  @override
  _UploadedAlbumsState createState() => _UploadedAlbumsState();
}

class _UploadedAlbumsState extends State<UploadedAlbums>
    with AutomaticKeepAliveClientMixin<UploadedAlbums> {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController = RefreshController();
  SharedPrefService _sharedPrefService = SharedPrefService();
  AlbumServices _albumServices = AlbumServices();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  SongService _song = SongService();

  List<AlbumModel> _allAlbums = [];
  bool isLoading = true;

  Future<List<SongModel>> getSongModel(List albumSongs) async {
    List<SongModel> songList = List<SongModel>();
    for (var song in albumSongs) {
      dynamic result = await _song.getSongDetails(song);
      songList.add(SongModel.fromJson(result.data['song']));
    }
    return songList;
  }

  Future<void> getUserAlbum() async {
    setState(() {
      isLoading = true;
    });
    dynamic userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result = await _albumServices.getUserAlbums(userID);
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      if (result.data['success']) {
        dynamic albumList = result.data['albums'];
        _allAlbums.clear();
        for (var album in albumList) {
          setState(() {
            _allAlbums.add(AlbumModel.fromJson(album));
          });
          for (var album in _allAlbums) {
            var playlistSongModel = await getSongModel(album.albumSongs);
            setState(() {
              album.albumSongModel = playlistSongModel;
            });
          }
        }
        setState(() {
          isLoading = false;
        });
      } else {
        _customSnackBar.buildSnackBar(
            result.data['msg'], result.data['success']);
      }
    }
  }

  Future<void> deleteAlbum(AlbumModel albumModel) async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _albumServices.deleteAlbum(albumModel.albumID);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        getUserAlbum();
      }
    }
  }

  Widget _showErrorMessage() {
    return CustomError(
      title: 'No Albums',
      subTitle:
          'There are no albums of your own. Please create one to view here.',
      buttonLabel: 'CREATE ALBUM',
      onPressed: () {
        Get.to(CreateAlbum());
      },
    );
  }

  Widget _createNewAlbum() {
    return InkWell(
      onTap: () {
        Get.to(CreateAlbum());
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
      album.albumPicture,
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
    return InkWell(
      onTap: () {
        Get.to(AlbumProfile(
          album: album,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            ClipRRect(
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
            Positioned(
              right: 20,
              child: InkWell(
                onTap: () {
                  deleteAlbum(album);
                },
                child: Opacity(
                  opacity: 0.6,
                  child: SvgPicture.asset(
                    'assets/icons/delete.svg',
                  ),
                ),
              ),
            ),
          ],
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAlbum();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return isLoading
        ? loading
        : _allAlbums.length == 0
            ? _showErrorMessage()
            : SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  getUserAlbum()
                      .then((value) => _refreshController.refreshCompleted());
                },
                header: CustomRefreshHeader(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _createNewAlbum(),
                      SizedBox(
                        height: 20,
                      ),
                      _showAlbums(),
                    ],
                  ),
                ),
              );
  }
}
