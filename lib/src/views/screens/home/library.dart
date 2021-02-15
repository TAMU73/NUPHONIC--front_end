import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/main.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/screens/library/favourites.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> with SingleTickerProviderStateMixin {
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

  Future<void> _signOut() async {
    setState(() {
      isLoading = true;
    });
    await _sharedPrefService.save(id: 'user_id', data: null);
    await _sharedPrefService.save(id: 'first_name', data: null);
    Get.offAll(Main());
  }

  Future<void> _getFirstName() async {
    String name = await _sharedPrefService.read(id: 'first_name');
    setState(() {
      fullName = name;
    });
  }

  Future<void> _getUserInfo() async {
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
    _getFirstName();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomAppBar(
                  label: 'Library',
                  endChild: Row(
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
              Padding(
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
                              profilePicture==null ? SizedBox() : Image.network(profilePicture),
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
                            username ?? 'Username',
                            style: titleTextStyle.copyWith(fontSize: 20),
                          ),
                          Text(
                            fullName,
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
    );
  }
}
