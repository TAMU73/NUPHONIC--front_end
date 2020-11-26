import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class TopArtistBox extends StatelessWidget {
  final String artistImage;
  final String artistName;

  TopArtistBox({this.artistImage, this.artistName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Stack(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  color: textFieldColor,
                  child: Center(
                    child: Icon(
                      Icons.person_outline_outlined,
                      color: mainColor,
                      size: 30,
                    ),
                  ),
                ),
                Image.network(
                  artistImage,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 80,
            child: Text(
              artistName,
              textAlign: TextAlign.center,
              style:
                  normalFontStyle.copyWith(color: whitishColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
