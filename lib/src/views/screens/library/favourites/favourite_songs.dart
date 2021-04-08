import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/favourite_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavouriteSongs extends StatefulWidget {
  @override
  _FavouriteSongsState createState() => _FavouriteSongsState();
}

class _FavouriteSongsState extends State<FavouriteSongs>
    with AutomaticKeepAliveClientMixin<FavouriteSongs> {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController = RefreshController();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  SharedPrefService _sharedPrefService = SharedPrefService();
  FavouriteServices _favouriteServices = FavouriteServices();
  SongService _song = SongService();

  bool isLoading = true;
  List<SongModel> _favouriteSongs = [];

  Widget _showErrorMessage() {
    return CustomError(
      title: 'No Favourite Artist',
      subTitle: 'Check out some artist and mark them as favourite to see here.',
      onPressed: () {
        getFavouriteSongs();
      },
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

  Future<void> getFavouriteSongs() async {
    setState(() {
      isLoading = true;
    });
    var userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result = await _favouriteServices.getFavouriteSongs(userID);
    if (result == null) {
      setState(() {
        isLoading = false;
      });
      _customSnackBar.buildSnackBar('Network Error, please try again!!', false);
    } else {
      List songListData = result.data["song_list"]["song_list"];
      if (songListData != null && songListData.isNotEmpty) {
        List<SongModel> list = List<SongModel>();
        for (var songID in songListData) {
          dynamic result1 = await _song.getSongDetails(songID);
          Map<String, dynamic> songDetail = result1.data['song'];
          list.add(SongModel.fromJson(songDetail));
        }
        _favouriteSongs.clear();
        setState(() {
          _favouriteSongs = list;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavouriteSongs();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () {
        getFavouriteSongs()
            .then((value) => _refreshController.refreshCompleted());
      },
      header: CustomRefreshHeader(),
      child: isLoading
          ? loading
          : _favouriteSongs.length == 0
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
  }
}
