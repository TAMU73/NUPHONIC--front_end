import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/playlist_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/playlist_services.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/playlist_box.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class PlaylistDetail extends StatefulWidget {
  final PlaylistModel playlist;

  PlaylistDetail({this.playlist});

  @override
  _PlaylistDetailState createState() => _PlaylistDetailState();
}

class _PlaylistDetailState extends State<PlaylistDetail> {
  CustomSnackBar _customSnackBar = CustomSnackBar();
  PlaylistServices _playlistServices = PlaylistServices();

  PlaylistModel _playlist;
  int playlistLength;
  bool isLoading = false;

  Future<void> removeSongFromPlaylist(PlaylistModel playlist, SongModel song) async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _playlistServices.deletePlaylistSongs(
        song.songID, playlist.playlistId);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        setState(() {
          _playlist.playlistSongModel.remove(song);
          playlistLength = playlistLength - 1;
        });
      }
    }
  }

  Widget _playlistSongsLength() {
    String songOrSongs = playlistLength > 1 ? 'songs' : 'song';
    return Row(
      children: [
        Text(
          '${playlistLength.toString()} $songOrSongs',
          style: normalFontStyle.copyWith(
            fontSize: 13,
            color: whitishColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _playlist = widget.playlist;
    playlistLength = _playlist.playlistSongModel.length;
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
                  label: 'Playlist',
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
                  : Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                PlaylistBox(
                                  playlist: widget.playlist,
                                  showLabel: false,
                                ),
                                SvgPicture.asset('assets/icons/play_song.svg', height: 50, width: 50,),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Text(
                                widget.playlist.playlistName,
                                style: titleTextStyle.copyWith(fontSize: 30),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                              child: _playlistSongsLength(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: widget.playlist.playlistSongModel
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
                                              removeSongFromPlaylist(_playlist,song);
                                            },
                                            child: Opacity(
                                              opacity: 0.6,
                                              child: SvgPicture.asset(
                                                  'assets/icons/remove.svg'),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            )
                          ],
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
