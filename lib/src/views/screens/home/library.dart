import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/main.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/screens/library/favourites.dart';
import 'package:nuphonic_front_end/src/views/screens/library/own_profile.dart';
import 'package:nuphonic_front_end/src/views/screens/library/upload_song.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> with SingleTickerProviderStateMixin {
  RefreshController _refreshController = RefreshController();
  SharedPrefService _sharedPrefService = SharedPrefService();
  AuthService _auth = AuthService();

  String username;
  String fullName;
  TabController _tabController;
  String profilePicture;

  int selectedIndex = 0;
  bool isLoading = false;
  List<Widget> tabs = [
    Favourites(),
    Uploads(),
  ];

  Future<void> _getUserInfo() async {
    String name = await _sharedPrefService.read(id: 'first_name');
    setState(() {
      fullName = name;
    });
    dynamic result =
        await _auth.getUserInfo(await _sharedPrefService.read(id: 'user_id'));
    if (result == null) {
      // setState(() {
      //   networkError = true;
      // });
    } else {
      setState(() {
        username = result.data['user']['username'];
        profilePicture = result.data['user']['profile_picture'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: () {
            _getUserInfo().then((value) => _refreshController.refreshCompleted());
          },
          header: CustomRefreshHeader(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomAppBar(
                    label: 'Library',
                    endChild: InkWell(
                      onTap: () {
                        Get.to(UploadSongs());
                      },
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Upload',
                            style: normalFontStyle.copyWith(
                                fontSize: 18, color: mainColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset('assets/icons/upload.svg')
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Get.to(OwnProfile(userID: await _sharedPrefService.read(id: 'user_id'),));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 100,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: textFieldColor,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: textFieldColor,
                                    child: Icon(
                                      Icons.person_outline_outlined,
                                      color: mainColor,
                                      size: 30,
                                    ),
                                  ),
                                  profilePicture == null ? SizedBox() : Image.network(profilePicture, height: 52, width: 52, fit: BoxFit.cover,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username ?? '',
                                style: titleTextStyle.copyWith(fontSize: 20),
                              ),
                              Text(
                                fullName ?? '',
                                style: normalFontStyle.copyWith(
                                    fontSize: 15,
                                    color: whitishColor.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height - 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelStyle: normalFontStyle.copyWith(
                            fontSize: 20,
                          ),
                          unselectedLabelStyle: normalFontStyle.copyWith(
                            fontSize: 20,
                          ),
                          labelColor: mainColor,
                          unselectedLabelColor: whitishColor.withOpacity(0.6),
                          indicatorColor: Colors.transparent,
                          tabs: [
                            Text(
                              'Favourites',
                            ),
                            Text(
                              'Uploads',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: tabs,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
