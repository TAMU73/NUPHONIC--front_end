import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nuphonic_front_end/src/app_logics/models/supporter_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/screens/music/music_player.dart';
import 'package:nuphonic_front_end/src/views/screens/music/user_profile.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class SupportDetail extends StatelessWidget {
  final SupporterModel support;

  SupportDetail({this.support});

  Widget _showSupporterImage() {
    return CircleAvatar(
      radius: 28,
      backgroundColor: backgroundColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: backgroundColor,
              child: Icon(
                Icons.person_outline_outlined,
                color: mainColor,
                size: 30,
              ),
            ),
            support.supporterProfilePicture != null
                ? Image.network(
                    support.supporterProfilePicture,
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

  Widget _showSupporterDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          support.supporterName,
          style: normalFontStyle.copyWith(
              fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ],
    );
  }

  Widget _supportedAmount() {
    return Text(
      'Rs. ${support.supportedAmount}',
      style: normalFontStyle.copyWith(
        color: greenishColor,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _showSupporterBox() {
    return InkWell(
      onTap: () {
        Get.to(UserProfile(
          userID: support.supporterId,
        ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            color: darkGreyColor,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  _showSupporterImage(),
                  SizedBox(
                    width: 10,
                  ),
                  _showSupporterDetail(),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _supportedAmount(),
                      Image.asset(
                        'assets/images/khalti_logo.png',
                        height: 25,
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(support.supportedSong.songName);
    print(support.supportedSong.songImage);
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
                  label: 'Support Details',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                _showSupporterBox(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(MusicPlayer(
                          song: support.supportedSong,
                        ));
                      },
                      child: Text(
                        support.supportedSong.songName,
                        style: normalFontStyle.copyWith(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color: whitishColor.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '${DateFormat('MMM dd, yyyy').format(DateTime.parse(support.supportedDate))}',
                      style: normalFontStyle.copyWith(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  support.message,
                  style: normalFontStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
