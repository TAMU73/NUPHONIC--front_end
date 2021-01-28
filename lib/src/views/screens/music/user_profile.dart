import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/user_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/back_blank.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class UserProfile extends StatefulWidget {
  final UserModel user;
  final String userID;

  UserProfile({this.user, this.userID});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  AuthService _auth = AuthService();
  SongService _song = SongService();

  bool isLoading = false;
  bool networkError = false;
  bool isSongLoading = false;
  UserModel user;
  List<SongModel> artistSongs = [];

  Future<void> getArtistDetail() async {
    if (widget.user != null) {
      setState(() {
        user = widget.user;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      dynamic result = await _auth.getUserInfo(widget.userID);
      if (result == null) {
        setState(() {
          networkError = true;
        });
      } else {
        Map<String, dynamic> artistDetail = result.data['user'];
        setState(() {
          isLoading = false;
          user = UserModel.fromJson(artistDetail);
        });
      }
    }
  }

  Future<void> getArtistSongs() async {
    artistSongs.clear();
    setState(() {
      isSongLoading = true;
    });
    dynamic result = await _song.getArtistSongs(user.userID);
    print(result);
    setState(() {
      isSongLoading = false;
    });
    if (result == null) {
      setState(() {
        networkError = true;
      });
    } else {
      if (result.data['success']) {
        dynamic songList = result.data['songs'];
        for (var songs in songList) {
          setState(() {
            artistSongs.add(SongModel.fromJson(songs));
          });
        }
      }
    }
  }

  void atStart() async {
    await getArtistDetail();
    getArtistSongs();
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
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: width,
                              height: width,
                              child: Image.network(
                                user.profilePicture,
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
                                endChild: SvgPicture.asset(
                                  'assets/icons/love_big.svg',
                                  height: 24,
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
                                        user.username,
                                        textAlign: TextAlign.center,
                                        style: titleTextStyle.copyWith(
                                            fontSize: 35),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      user.username == user.fullName
                                          ? SizedBox()
                                          : Text(
                                              user.fullName,
                                              textAlign: TextAlign.center,
                                              style: normalFontStyle.copyWith(
                                                color: whitishColor
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        isSongLoading
                            ? linearLoading
                            : artistSongs.length > 0
                                ? Column(
                                    children: artistSongs
                                        .map(
                                          (song) => SongBox(
                                            song: song,
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
