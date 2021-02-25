import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/playlist_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/playlist_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/playlist_box.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class AddToPlaylist extends StatefulWidget {
  final SongModel song;

  AddToPlaylist({this.song});

  @override
  _AddToPlaylistState createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  SongService _song = SongService();
  SharedPrefService _sharedPrefService = SharedPrefService();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  PlaylistServices _playlistServices = PlaylistServices();

  List<PlaylistModel> _allPlaylists = [];
  bool isLoading = false;

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
      _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
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
      }
    }
  }

  Future<void> addSongToPlaylist(PlaylistModel playlist, SongModel song) async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _playlistServices.addPlaylistSongs(
        song.songID, playlist.playlistId);
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

  Widget _showErrorMessage(double height) {
    return Container(
      height: height - 80,
      child: Center(
        child: CustomError(
          title: 'No Playlists',
          subTitle:
              'There are no playlist of your own. Please create one to view here.',
          buttonLabel: 'GO BACK',
          onPressed: () {
            Get.back();
          },
        ),
      ),
    );
  }

  Widget _showPlaylists() {
    return Column(
      children: _allPlaylists
          .map(
            (playlist) => Column(
              children: [
                PlaylistBox(
                  playlist: playlist,
                  onPressed: () {
                    addSongToPlaylist(playlist, widget.song);
                  },
                ),
                SizedBox(height: 20,)
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
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomAppBar(
                  label: 'Choose your Playlist',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              isLoading
                  ? Container(height: height - 80, child: loading)
                  : _allPlaylists.length == 0
                      ? _showErrorMessage(height)
                      : _showPlaylists(),
            ],
          ),
        ),
      ),
    );
  }
}
