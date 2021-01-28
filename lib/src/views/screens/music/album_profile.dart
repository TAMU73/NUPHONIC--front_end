import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/album_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/album_services.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
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

  bool isLoading = false;
  AlbumModel album;

  void atStart() async {
    if (widget.album != null) {
      setState(() {
        album = widget.album;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      dynamic result1 = await _albumServices.getAlbumDetails(widget.albumID);
      Map<String, dynamic> albumDetail = result1.data['album'];
      setState(() {
        isLoading = false;
        album = AlbumModel.fromJson(albumDetail);
      });
    }
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
            ? loading
            : Column(
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
                ],
              ),
      ),
    );
  }
}
