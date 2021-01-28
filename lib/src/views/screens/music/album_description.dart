import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/album_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class AlbumDescription extends StatelessWidget {
  final AlbumModel  album;

  AlbumDescription({this.album});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomAppBar(
                  label: 'Description',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: width - 40,
                  width: width - 40,
                  child: Image.network(album.albumPicture, fit: BoxFit.cover,),
                ),
                SizedBox(height: 10,),
                Container(
                  width: width,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          album.albumName,
                          textAlign: TextAlign.center,
                          style:
                          titleTextStyle.copyWith(fontSize: 30),
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
                                  color:
                                  whitishColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  '  ${album.description}',
                  style: normalFontStyle,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
