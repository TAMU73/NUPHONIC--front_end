import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/artist_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/feature_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/content_title.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/featured_artist_box.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/featured_song_box.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/network_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/page_indicator.dart';
import 'package:nuphonic_front_end/src/views/shimmers/home_shimmer.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  RefreshController _refreshController = RefreshController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthService _auth = AuthService();
  FeatureService _feature = FeatureService();
  SongService _song = SongService();
  SharedPrefService _sharedPrefService = SharedPrefService();

  String name;
  String greeting;

  bool homeLoading = true;
  bool networkError = false;
  bool isLoadMoreLoading = false;

  int currentIndex = 0;

  List<SongModel> featuredSongs = [];
  List<UserModel> featuredArtists = [];
  List<SongModel> browseSongs = [];

  Future<void> _getUserInfo() async {
    dynamic result =
        await _auth.getUserInfo(await _sharedPrefService.read(id: 'user_id'));
    if (result == null) {
      setState(() {
        networkError = true;
        homeLoading = false;
      });
    } else {
      await _sharedPrefService.save(
          id: 'first_name',
          data: result.data['user']['full_name'].split(" ")[0]);
      setState(() {
        name = result.data['user']['full_name'].split(" ")[0];
      });
    }
  }

  Future<void> _getGreeting() async {
    int hour = DateTime.now().hour;
    String _greeting = hour < 12
        ? "Morning"
        : hour < 17
            ? "Afternoon"
            : "Evening";
    setState(() {
      greeting = _greeting;
    });
  }

  Future<void> _getFirstName() async {
    String firstName = await _sharedPrefService.read(id: 'first_name');
    setState(() {
      name = firstName;
    });
  }

  Future<void> _getFeaturedSongs() async {
    dynamic result = await _feature.getFeaturedSongs();
    if (result == null) {
      setState(() {
        networkError = true;
        homeLoading = false;
      });
    } else {
      dynamic songList = result.data['songs'];
      List<SongModel> list = List<SongModel>();
      for (var songs in songList) {
        String songID = songs['song_id'];
        dynamic result1 = await _song.getSongDetails(songID);
        Map<String, dynamic> songDetail = result1.data['song'];
        list.add(SongModel.fromJson(songDetail));
      }
      featuredSongs.clear();
      setState(() {
        featuredSongs = list;
      });
    }
  }

  Future<void> _getFeaturedArtists() async {
    dynamic result = await _feature.getFeaturedArtists();
    if (result == null) {
      setState(() {
        networkError = true;
        homeLoading = false;
      });
    } else {
      dynamic artistList = result.data['artists'];
      List<UserModel> list = List<UserModel>();
      for (var artists in artistList) {
        String artistID = artists['artist_id'];
        dynamic result1 = await _auth.getUserInfo(artistID);
        Map<String, dynamic> artistDetail = result1.data['user'];
        list.add(UserModel.fromJson(artistDetail));
      }
      featuredArtists.clear();
      setState(() {
        featuredArtists = list;
      });
    }
  }

  Future<void> _getBrowseSongs(bool isRefresh) async {
    dynamic result = await _song.getBrowseSongs();
    if (result == null) {
      setState(() {
        networkError = true;
        homeLoading = false;
      });
    } else {
      dynamic songList = result.data['songs'];
      if(isRefresh) browseSongs.clear();
      for (var songs in songList) {
        setState(() {
          browseSongs.add(SongModel.fromJson(songs));
          if (browseSongs.length > 4) {
            homeLoading = false;
          }
        });
      }
    }
  }

  Future<void> atStart() async {
    _getGreeting(); //checking greetings
    _getFirstName(); //checking saved user's first name
    _getUserInfo(); //updating users info
    await _getFeaturedSongs();
    await _getFeaturedArtists();
    await _getBrowseSongs(false);
  }

  Future<void> atRefresh() async {
    _getGreeting(); //checking greetings
    _getFirstName(); //checking saved user's first name
    _getUserInfo(); //updating users info
    _getFeaturedSongs();
    _getFeaturedArtists();
    _getBrowseSongs(true);
  }

  Future<void> refresh() async {
    setState(() {
      networkError = false;
    });
    await atRefresh().then((value) => _refreshController.refreshCompleted());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: refresh,
          header: CustomRefreshHeader(),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomAppBar(
                    label: 'Good $greeting',
                    labelTextStyle: titleTextStyle.copyWith(
                      fontSize: 21,
                    ),
                    secondLabel: '$name,',
                    secondLabelTextStyle: normalFontStyle.copyWith(
                      fontSize: 18,
                    ),
                    endChild: SvgPicture.asset(
                      'assets/logos/app_logo_mini.svg',
                      height: 33,
                    ),
                  ),
                ),
                networkError
                    ? Container(
                        height: height - 200,
                        child: NetworkError(
                          onPressed: () {
                            refresh();
                          },
                        ),
                      )
                    : homeLoading
                        ? HomeShimmer()
                        //After loading completes
                        //home body starts from here
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 180,
                                child: PageView.builder(
                                  onPageChanged: (val) {
                                    setState(() {
                                      currentIndex = val;
                                    });
                                  },
                                  itemCount: featuredSongs.length,
                                  itemBuilder: (context, index) {
                                    return FeaturedSongBox(
                                      songName: featuredSongs[index].songName,
                                      imageURL: featuredSongs[index].songImage,
                                      artistName:
                                          featuredSongs[index].artistName,
                                      songPlace: featuredSongs[index].albumName,
                                    );
                                  },
                                ),
                              ),
                              Container(
                                height: 25,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0;
                                        i < featuredSongs.length;
                                        i++)
                                      currentIndex == i
                                          ? PageIndicator(
                                              isCurrentPage: true,
                                            )
                                          : PageIndicator(
                                              isCurrentPage: false,
                                            ),
                                  ],
                                ),
                              ),
                              ContentTitle(
                                label: 'Featured Artists',
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: featuredArtists
                                          .map(
                                            (artist) => FeaturedArtistBox(
                                              artistName: artist.fullName,
                                              artistImage:
                                                  artist.profilePicture,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ContentTitle(
                                label: 'Browse Songs',
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                  children: browseSongs
                                      .map(
                                        (song) => SongBox(
                                          songName: song.songName,
                                          imageURL: song.songImage,
                                          artistName: song.artistName,
                                          songPlace: song.albumName,
                                        ),
                                      )
                                      .toList()),
                              // ),
                              SizedBox(
                                height: 90,
                              ),
                            ],
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
