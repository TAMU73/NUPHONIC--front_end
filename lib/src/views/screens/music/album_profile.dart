import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/album_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/album_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/back_blank.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';
import 'package:nuphonic_front_end/src/views/screens/music/album_description.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class AlbumProfile extends StatefulWidget {
  final AlbumModel album;
  final String albumID;

  AlbumProfile({
    this.albumID,
    this.album,
  });

  @override
  _AlbumProfileState createState() => _AlbumProfileState();
}

class _AlbumProfileState extends State<AlbumProfile> {
  AlbumServices _albumServices = AlbumServices();
  SongService _song = SongService();
  CustomSnackBar _customSnackBar = CustomSnackBar();

  bool isLoading = false;
  bool networkError = false;
  bool isSongLoading = false;
  AlbumModel album;
  List<SongModel> albumSongs = [];

  Future<void> removeSongFromAlbum(AlbumModel album, SongModel song) async {
    setState(() {
      isSongLoading = true;
    });
    dynamic result =
        await _albumServices.deleteAlbumSongs(song.songID, album.albumID);
    setState(() {
      isSongLoading = false;
    });
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        setState(() {
          album.albumSongModel.remove(song);
        });
        getAlbumSongs();
      }
    }
  }

  Future<void> getAlbumDetails() async {
    if (widget.album != null) {
      setState(() {
        album = widget.album;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      dynamic result = await _albumServices.getAlbumDetails(widget.albumID);
      if (result == null) {
        setState(() {
          networkError = true;
        });
      } else {
        Map<String, dynamic> albumDetail = result.data['album'];
        setState(() {
          isLoading = false;
          album = AlbumModel.fromJson(albumDetail);
        });
      }
    }
  }

  Future<void> getAlbumSongs() async {
    if (album.albumSongs.isNotEmpty) {
      albumSongs.clear();
      setState(() {
        isSongLoading = true;
      });
      dynamic albumSongsList = album.albumSongs;
      for (var song in albumSongsList) {
        dynamic result = await _song.getSongDetails(song);
        setState(() {
          isSongLoading = false;
        });
        Map<String, dynamic> songDetail = result.data['song'];
        setState(() {
          albumSongs.add(SongModel.fromJson(songDetail));
        });
      }
    }
  }

  void atStart() async {
    await getAlbumDetails();
    getAlbumSongs();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: isLoading
            ? Container(
                child: BackBlank(
                  child: Expanded(child: Center(child: loading)),
                ),
              )
            : networkError
                ? Container(
                    child: CustomError(
                      onPressed: () async {
                        setState(() {
                          networkError = false;
                        });
                        atStart();
                      },
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: width,
                              height: width,
                              child: Image.network(
                                album.albumPicture,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: width,
                              height: width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.3),
                                      Colors.black
                                    ]),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 20,
                              right: 20,
                              child: CustomAppBar(
                                leadIconPath: 'assets/icons/back_icon.svg',
                                onIconTap: () {
                                  Get.back();
                                },
                                label: "",
                                endChild: InkWell(
                                  onTap: () {
                                    Get.to(AlbumDescription(
                                      album: album,
                                    ));
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/info_big.svg',
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Container(
                                width: width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        album.albumName,
                                        textAlign: TextAlign.center,
                                        style: titleTextStyle.copyWith(
                                            fontSize: 30),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Album by ',
                                            textAlign: TextAlign.center,
                                            style: normalFontStyle.copyWith(
                                                color: whitishColor
                                                    .withOpacity(0.7)),
                                          ),
                                          Text(
                                            album.artistName,
                                            textAlign: TextAlign.center,
                                            style: normalFontStyle.copyWith(
                                                color: whitishColor
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SvgPicture.asset('assets/icons/album_play.svg')
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '${album.albumSongs.length.toString()} songs',
                            textAlign: TextAlign.center,
                            style: normalFontStyle.copyWith(
                                color: whitishColor.withOpacity(0.7)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        isSongLoading
                            ? linearLoading
                            : albumSongs.length > 0
                                ? Column(
                                    children: albumSongs
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
                                                    removeSongFromAlbum(album, song);
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
                                        .toList())
                                : SizedBox(
                                    height: height - width - 60,
                                    child: CustomError(
                                      title: 'No Songs Found.',
                                      subTitle:
                                          'This artist has not uploaded any song. Please check another artist.',
                                      buttonLabel: 'GO BACK',
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
