import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/album_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class AlbumProfile extends StatefulWidget {
  // final AlbumModel album;
  final String albumID;

  AlbumProfile({
    this.albumID,
    // this.album,
  });

  @override
  _AlbumProfileState createState() => _AlbumProfileState();
}

class _AlbumProfileState extends State<AlbumProfile> {
  bool isLoading = false;

  AlbumModel album = AlbumModel(
      albumID: "albumID",
      artistID: "artistID",
      artistName: "Bartika Eam Rai",
      albumName: "Bimbaakash",
      albumPicture:
          "https://m.media-amazon.com/images/I/61po9HBLnQL._SS500_.jpg",
      albumSongs: ["song1", "song2", "song3"],
      description: "Album Description");

  // void atStart() async {
  //   if (widget.album != null) {
  //     setState(() {
  //       user = widget.album;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     dynamic result1 = await _songService.getAlbumInfo(widget.albumID);
  //     Map<String, dynamic> albumDetail = result1.data['album'];
  //     setState(() {
  //       isLoading = false;
  //       album = AlbumModel.fromJson(albumDetail);
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // atStart();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return isLoading
        ? loading
        : SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: Column(
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
                        top: 10,
                        left: 20,
                        right: 20,
                        child: CustomAppBar(
                          leadIconPath: 'assets/icons/back_icon.svg',
                          label: "",
                          endChild: SvgPicture.asset(
                            'assets/icons/info_big.svg',
                            height: 24,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        child: Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  album.albumName,
                                  textAlign: TextAlign.center,
                                  style: titleTextStyle.copyWith(fontSize: 30),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Album by ',
                                      textAlign: TextAlign.center,
                                      style: normalFontStyle.copyWith(
                                          color: whitishColor.withOpacity(0.7)),
                                    ),
                                    Text(
                                      album.artistName,
                                      textAlign: TextAlign.center,
                                      style: normalFontStyle.copyWith(
                                        color: whitishColor.withOpacity(0.7),
                                        fontWeight: FontWeight.w600
                                      ),
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
                ],
              ),
            ),
          );
  }
}
