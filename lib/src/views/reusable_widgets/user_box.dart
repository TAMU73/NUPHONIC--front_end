import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/user_model.dart';
import 'package:nuphonic_front_end/src/views/screens/music/user_profile.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class UserBox extends StatelessWidget {
  final UserModel user;

  UserBox({this.user});

  Widget _artistImage(UserModel artist) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: textFieldColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: textFieldColor,
              child: Icon(
                Icons.person_outline_outlined,
                color: mainColor,
                size: 30,
              ),
            ),
            artist.profilePicture != null
                ? Image.network(
                    artist.profilePicture,
                    height: 56,
                    fit: BoxFit.cover,
                  )
                : SizedBox(),
            // profilePicture == null ? SizedBox() : Image.network(profilePicture),
          ],
        ),
      ),
    );
  }

  Widget _artistName(UserModel artist) {
    return Text(
      artist.username,
      style: normalFontStyle.copyWith(fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(UserProfile(
          user: user,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60,
            child: Row(
              children: [
                _artistImage(user),
                SizedBox(
                  width: 10,
                ),
                _artistName(user),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
