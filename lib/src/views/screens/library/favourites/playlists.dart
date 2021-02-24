import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/playlist_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/playlist_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_bottom_sheet.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Playlists extends StatefulWidget {
  @override
  _PlaylistsState createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
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
    _panelController.close();
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        getUserPlaylist();
      }
    }
  }

  Future<void> deletePlaylist(PlaylistModel playlist) async {
    setState(() {
      _allPlaylists.remove(playlist);
    });
    dynamic result =
        await _playlistServices.deletePlaylists(playlist.playlistId);
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
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
    );
  }

  Widget _showErrorMessage() {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        CustomError(
          title: 'No Playlists',
          subTitle:
              'There are no playlist of your own. Please create one to view here.',
          buttonLabel: 'Create Playlist',
          onPressed: () {},
        ),
      ],
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

  Widget _playlistSongs(PlaylistModel playlist) {
    return playlist.playlistSongs.isEmpty
        ? Container(color: textFieldColor)
        : Row(
            children: playlist.playlistSongModel
                .map(
                  (song) => Flexible(
                    flex: 1,
                    child: Image.network(
                      song.songImage,
                      height: 97,
                      width:
                          Size.infinite.width / playlist.playlistSongs.length,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .toList());
  }

  Widget _gradientEffect() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              backgroundColor.withOpacity(0.8),
            ]),
      ),
    );
  }

  Widget _playlistName(PlaylistModel playlist) {
    return Text(
      playlist.playlistName,
      style: normalFontStyle.copyWith(
        fontWeight: FontWeight.w700,
        color: whitishColor,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _playlistSongsLength(PlaylistModel playlist) {
    return Text(
      '${playlist.playlistSongs.length.toString()} songs',
      style: normalFontStyle.copyWith(
        fontSize: 13,
        color: whitishColor.withOpacity(0.7),
      ),
    );
  }

  Widget _showPlaylists() {
    return Column(
      children: _allPlaylists
          .map(
            (playlist) => _playlistBox(playlist),
          )
          .toList(),
    );
  }

  Widget _playlistBox(PlaylistModel playlist) {
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
              _playlistSongs(playlist),
              playlist.playlistSongs.isNotEmpty
                  ? _gradientEffect()
                  : SizedBox(),
              Positioned(
                left: 10,
                bottom: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _playlistName(playlist),
                    _playlistSongsLength(playlist),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                child: InkWell(
                  onTap: () {
                    deletePlaylist(playlist);
                  },
                  child: SvgPicture.asset('assets/icons/delete.svg'),
                ),
              )
            ],
          ),
        ),
      ),
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
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _createNewPlaylist(),
                    SizedBox(
                      height: 20,
                    ),
                    _allPlaylists.length == 0
                        ? _showErrorMessage()
                        : _showPlaylists(),
                  ],
                ),
              ),
        _customButtonSheet()
      ],
    );
  }
}
