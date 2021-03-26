import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/main.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/supporter_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/user_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/support_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/back_blank.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';
import 'package:nuphonic_front_end/src/views/screens/library/edit_profile.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads/support_detail.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class OwnProfile extends StatefulWidget {
  final UserModel user;
  final String userID;

  OwnProfile({this.user, this.userID});

  @override
  _OwnProfileState createState() => _OwnProfileState();
}

class _OwnProfileState extends State<OwnProfile> {
  AuthService _auth = AuthService();
  SupportServices _supportServices = SupportServices();
  SharedPrefService _sharedPrefService = SharedPrefService();

  bool isLoading = false;
  bool isButtonLoading = false;
  bool networkError = false;
  bool isSongLoading = false;
  UserModel user;
  List<SupporterModel> supported = [];

  Future<void> _signOut() async {
    setState(() {
      isButtonLoading = true;
    });
    await _sharedPrefService.save(id: 'user_id', data: null);
    await _sharedPrefService.save(id: 'first_name', data: null);
    Get.offAll(Main());
  }

  Future<void> getUserDetail() async {
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

  Future<void> getUserSupported() async {
    supported.clear();
    setState(() {
      isSongLoading = true;
    });
    var userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result = await _supportServices.getSuperSupported(userID);
    setState(() {
      isSongLoading = false;
    });
    if (result == null) {
    } else {
      if (result.data['success']) {
        dynamic supportedList = result.data['supported'];
        for (var support in supportedList) {
          setState(() {
            supported.add(SupporterModel.fromJson(support));
          });
        }
      }
    }
  }

  void atStart() async {
    await getUserDetail();
    getUserSupported();
  }

  // Widget _showSupporterImage(SupporterModel supporter) {
  //   return CircleAvatar(
  //     radius: 28,
  //     backgroundColor: backgroundColor,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(50),
  //       child: Stack(
  //         children: [
  //           CircleAvatar(
  //             radius: 28,
  //             backgroundColor: backgroundColor,
  //             child: Icon(
  //               Icons.person_outline_outlined,
  //               color: mainColor,
  //               size: 30,
  //             ),
  //           ),
  //           supporter.supportedSong.songImage != null
  //               ? Image.network(
  //                   supporter.supportedSong.songImage,
  //                   height: 56,
  //                   fit: BoxFit.cover,
  //                 )
  //               : SizedBox(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _showSupporterDetail(SupporterModel supporter) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          supporter.supportedSong.songName,
          style: normalFontStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: Text(
            supporter.supportedSong.artistName,
            style: normalFontStyle.copyWith(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _supportedAmount(SupporterModel supporter) {
    return Text(
      'Rs. ${supporter.supportedAmount}',
      style: normalFontStyle.copyWith(
        color: greenishColor,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _supporterBox(SupporterModel supporter) {
    return InkWell(
      onTap: () {
        Get.to(SupportDetail(
          support: supporter,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: darkGreyColor,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // _showSupporterImage(supporter),
                  SizedBox(
                    width: 10,
                  ),
                  _showSupporterDetail(supporter),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _supportedAmount(supporter),
                      Image.asset(
                        'assets/images/khalti_logo.png',
                        height: 25,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
      body: Stack(
        children: [
          Container(
            height: height,
            child: SafeArea(
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
                                    child: user.profilePicture != null
                                        ? Image.network(
                                            user.profilePicture,
                                            fit: BoxFit.cover,
                                          )
                                        : SizedBox(
                                            child: Icon(
                                              Icons.person_outline,
                                              color: mainColor,
                                              size: 100,
                                            ),
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
                                      leadIconPath:
                                          'assets/icons/back_icon.svg',
                                      onIconTap: () {
                                        Get.back();
                                      },
                                      label: "",
                                      endChild: InkWell(
                                        onTap: () {
                                          Get.to(EditProfile());
                                        },
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Edit Profile',
                                              style: normalFontStyle.copyWith(
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SvgPicture.asset(
                                              'assets/icons/edit_profile.svg',
                                              color: whitishColor,
                                            )
                                          ],
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
                                                    style: normalFontStyle
                                                        .copyWith(
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
                                  : supported.length > 0
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 0, 10),
                                              child: Text(
                                                '${supported.length.toString()} supports',
                                                textAlign: TextAlign.center,
                                                style: normalFontStyle.copyWith(
                                                    color: whitishColor
                                                        .withOpacity(0.7)),
                                              ),
                                            ),
                                            Column(
                                                children: supported
                                                    .map(
                                                      (song) =>
                                                          _supporterBox(song),
                                                    )
                                                    .toList()),
                                          ],
                                        )
                                      : SizedBox(),
                              SizedBox(
                                height: 120,
                              )
                            ],
                          ),
                        ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.red,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black]),
              ),
              width: width,
              child: CustomButton(
                labelName: 'SIGN OUT',
                onPressed: () {},
                isLoading: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
