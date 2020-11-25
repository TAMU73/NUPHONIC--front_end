import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/main.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/featured_box.dart';
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
  SharedPreferenceService _sharedPrefService = SharedPreferenceService();

  String name;
  String greeting;

  bool isLoading = false;
  bool homeLoading = true;
  bool networkError = false;

  int currentIndex = 0;

  List<SongModel> _sliders = [
    SongModel(
      songName: 'Batash',
      imageURL: 'https://i.ytimg.com/vi/AtoZw7o2kRo/mqdefault.jpg',
      artistName: 'Shashwat Khadka',
      songPlace: 'Single',
    ),
    SongModel(
      songName: 'Eklai Eklai',
      imageURL: 'https://i.ytimg.com/vi/9GGajYVcAfg/hqdefault.jpg',
      artistName: 'Shubham Gurung',
      songPlace: 'Single',
    ),
    SongModel(
      songName: 'Syndicate',
      imageURL:
          'https://1.bp.blogspot.com/-pR_JlfS_-74/XxmNHw0zg7I/AAAAAAAAC3o/s7TBfYjyMigIn8XETZP8-54AG2zkXDtjwCLcBGAsYHQ/w1200-h630-p-k-no-nu/Syndicate%2BLyrics%2B-%2BBipul%2BChettri%250A%250A.jpg',
      artistName: 'Bipul Chettri',
      songPlace: 'Maya',
    ),
    SongModel(
      songName: 'Ganja ko sahara',
      imageURL: 'https://i.ytimg.com/vi/0LqExX5WFQ8/maxresdefault.jpg',
      artistName: 'Bikki Karki',
      songPlace: 'Single',
    ),
    SongModel(
      songName: 'Mellow',
      imageURL: 'https://i.ytimg.com/vi/lfCy78dbcYA/maxresdefault.jpg',
      artistName: 'Sajjan Raj Vaidhya',
      songPlace: 'Single',
    ),
  ];

  Future<void> _signOut() async {
    setState(() {
      isLoading = true;
    });
    await _sharedPrefService.save(id: 'user_id', data: null);
    await _sharedPrefService.save(id: 'first_name', data: null);
    Get.offAll(Main());
  }

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
        homeLoading = false;
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

  Future<void> refresh() async {
    setState(() {
      currentIndex = 0;
      homeLoading = true;
      networkError = false;
    });
    await atStart().then((value) => _refreshController.refreshCompleted());
  }

  Future<void> atStart() async {
    _getGreeting(); //checking greetings
    _getFirstName(); //checking saved user's first name
    await _getUserInfo(); //updating users info
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
                      fontSize: 24,
                    ),
                    secondLabel: '$name,',
                    secondLabelTextStyle: normalFontStyle.copyWith(
                      fontSize: 20,
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
                                    itemCount: _sliders.length,
                                    itemBuilder: (context, index) {
                                      return FeaturedBox(
                                        songName: _sliders[index].songName,
                                        imageURL: _sliders[index].imageURL,
                                        artistName: _sliders[index].artistName,
                                        songPlace: _sliders[index].songPlace,
                                      );
                                    },
                                  )),
                              Container(
                                height: 25,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0; i < _sliders.length; i++)
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
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: CustomButton(
                                  labelName: 'SIGN OUT',
                                  isLoading: isLoading,
                                  onPressed: _signOut,
                                ),
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
