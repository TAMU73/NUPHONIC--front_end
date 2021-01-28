import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/user_model.dart';
import 'package:nuphonic_front_end/src/views/screens/music/user_profile.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class FeaturedArtistBox extends StatelessWidget {
  final UserModel user;

  FeaturedArtistBox({this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(UserProfile(user: user,));
      },
      child: Padding(
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
                    user.profilePicture,
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
                user.username,
                textAlign: TextAlign.center,
                style: normalFontStyle.copyWith(
                  color: whitishColor.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
