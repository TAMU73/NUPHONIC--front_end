import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';
import 'package:nuphonic_front_end/src/views/screens/library/upload_song.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UploadedSongs extends StatefulWidget {
  @override
  _UploadedSongsState createState() => _UploadedSongsState();
}

class _UploadedSongsState extends State<UploadedSongs>
    with AutomaticKeepAliveClientMixin<UploadedSongs> {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController = RefreshController();
  SongService _songService = SongService();
  SharedPrefService _sharedPrefService = SharedPrefService();
  CustomSnackBar _customSnackBar = CustomSnackBar();

  List<SongModel> _uploadedSongs = [];
  bool isLoading = true;

  Future<void> getUserSongs() async {
    _uploadedSongs.clear();
    setState(() {
      isLoading = true;
    });
    var userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result = await _songService.getArtistSongs(userID);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
    } else {
      if (result.data['success']) {
        dynamic songList = result.data['songs'];
        for (var songs in songList) {
          setState(() {
            _uploadedSongs.add(SongModel.fromJson(songs));
          });
        }
      }
    }
  }

  Future<void> deleteSong(SongModel song) async {
    if (song.albumName == 'Single') {
      setState(() {
        isLoading = true;
      });
      var userID = await _sharedPrefService.read(id: 'user_id');
      dynamic result = await _songService.deleteSong(userID, song.songID);
      setState(() {
        isLoading = false;
      });
      if (result == null) {
        _customSnackBar.buildSnackBar('Network Error', false);
      } else {
        _customSnackBar.buildSnackBar(
            result.data['msg'], result.data['success']);
        if (result.data['success']) {
          getUserSongs();
        }
      }
    } else {
      _customSnackBar.buildSnackBar(
          'Remove this song from album first in order to delete', false);
    }
  }

  Widget _showErrorMessage() {
    return CustomError(
      title: 'No Songs Found',
      subTitle: 'You have not uploaded any song yet. Upload song to see here.',
      buttonLabel: 'UPLOAD',
      onPressed: () {
        Get.to(UploadSongs());
      },
    );
  }

  Widget _showSongs() {
    return Column(
      children: _uploadedSongs
          .map(
            (song) => Stack(
              alignment: Alignment.centerRight,
              children: [
                SongBox(song: song),
                Positioned(
                  right: 40,
                  bottom: 61,
                  child: InkWell(
                    onTap: () {
                      deleteSong(song);
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
          )
          .toList(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserSongs();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () {
        getUserSongs().then((value) => _refreshController.refreshCompleted());
      },
      header: CustomRefreshHeader(),
      child: isLoading
          ? loading
          : _uploadedSongs.length == 0
              ? _showErrorMessage()
              : SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    _showSongs()
                  ]),
                ),
    );
    ;
  }
}
