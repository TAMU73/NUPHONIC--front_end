import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/playlist_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/playlist_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_bottom_sheet.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/playlist_box.dart';
import 'package:nuphonic_front_end/src/views/screens/library/favourites/playlist_detail.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Playlists extends StatefulWidget {
  @override
  _PlaylistsState createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists>
    with AutomaticKeepAliveClientMixin<Playlists> {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController = RefreshController();
  PanelController _panelController = PanelController();
  TextEditingController _textEditingController = TextEditingController();
  PlaylistServices _playlistServices = PlaylistServices();
  SharedPrefService _sharedPrefService = SharedPrefService();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  SongService _song = SongService();

  List<PlaylistModel> _allPlaylists = [];

  String newPlaylistName = "";
  bool isLoading = false;
  bool isButtonLoading = false;

  Future<List<SongModel>> getSongModel(List playlistSongs) async {
    List<SongModel> songList = List<SongModel>();
    for (var song in playlistSongs) {
      dynamic result = await _song.getSongDetails(song);
      songList.add(SongModel.fromJson(result.data['song']));
    }
    return songList;
  }

  Future<void> getUserPlaylist() async {
    setState(() {
      isLoading = true;
    });
    dynamic userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result = await _playlistServices.getUserPlaylists(userID);
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      if (result.data['success']) {
        dynamic playlistList = result.data['playlists'];
        _allPlaylists.clear();
        for (var playlist in playlistList) {
          setState(() {
            _allPlaylists.add(PlaylistModel.fromJson(playlist));
          });
          for (var playlist in _allPlaylists) {
            var playlistSongModel = await getSongModel(playlist.playlistSongs);
            setState(() {
              playlist.playlistSongModel = playlistSongModel;
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

  Future<void> createNewPlaylist() async {
    setState(() {
      isButtonLoading = true;
    });
    dynamic userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result =
        await _playlistServices.createPlaylist(newPlaylistName, userID);
    setState(() {
      isButtonLoading = false;
    });
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        _panelController.close();
        _textEditingController.clear();
        getUserPlaylist();
        setState(() {
          newPlaylistName = "";
        });
      }
    }
  }

  Future<void> deletePlaylist(PlaylistModel playlistModel) async {
    setState(() {
      isLoading = true;
    });
    dynamic result =
        await _playlistServices.deletePlaylists(playlistModel.playlistId);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        getUserPlaylist();
      }
    }
  }

  Widget _customButtonSheet() {
    return CustomBottomSheet(
      onChanged: (val) {
        setState(() {
          newPlaylistName = val;
        });
      },
      titleName: 'New Playlist',
      labelName: 'Playlist Name',
      hintName: 'Playlist Name',
      onPressed: newPlaylistName == "" ? null : createNewPlaylist,
      isLoading: isButtonLoading,
      controller: _panelController,
      buttonName: 'CREATE',
      textController: _textEditingController,
    );
  }

  Widget _createNewPlaylist() {
    return InkWell(
      onTap: () {
        _panelController.open();
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Spacer(),
            SvgPicture.asset('assets/icons/plus_circle.svg'),
            SizedBox(width: 10),
            Text(
              'Create New Playlist',
              style: normalFontStyle,
            ),
            SizedBox(width: 20)
          ],
        ),
      ),
    );
  }

  Widget _showErrorMessage() {
    return CustomError(
      title: 'No Playlists',
      subTitle:
          'There are no playlist of your own. Please create one to view here.',
      buttonLabel: 'CREATE PLAYLIST',
      onPressed: () {
        _panelController.open();
      },
    );
  }

  Widget _showPlaylists() {
    return Column(
      children: _allPlaylists
          .map(
            (playlist) => Column(
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    PlaylistBox(
                      playlist: playlist,
                      onPressed: () {
                        Get.to(
                          PlaylistDetail(
                            playlist: playlist,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 40,
                      child: InkWell(
                        onTap: () {
                          deletePlaylist(playlist);
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
                SizedBox(
                  height: 20,
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
    getUserPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isLoading
            ? loading
            : _allPlaylists.length == 0
                ? _showErrorMessage()
                : SmartRefresher(
                    controller: _refreshController,
                    onRefresh: () {
                      getUserPlaylist().then(
                          (value) => _refreshController.refreshCompleted());
                    },
                    header: CustomRefreshHeader(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _createNewPlaylist(),
                          SizedBox(
                            height: 20,
                          ),
                          _showPlaylists(),
                        ],
                      ),
                    ),
                  ),
        _customButtonSheet()
      ],
    );
  }
}
