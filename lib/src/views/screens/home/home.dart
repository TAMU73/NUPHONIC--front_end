import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/main.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/network_error.dart';
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

  bool isLoading = false;
  bool homeLoading = true;
  bool networkError = false;

  String name;
  String greeting;

  Future<void> _signOut() async {
    setState(() {
      isLoading = true;
    });
    await SharedPrefService().save(id: 'user_id', data: null);
    await SharedPrefService().save(id: 'first_name', data: null);
    Get.offAll(Main());
  }

  Future<void> _getUserInfo() async {
    dynamic result =
        await _auth.getUserInfo(await SharedPrefService().read(id: 'user_id'));
    if (result == null) {
      setState(() {
        networkError = true;
        homeLoading = false;
      });
    } else {
      await SharedPrefService().save(
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
    String firstName = await SharedPrefService().read(id: 'first_name');
    setState(() {
      name = firstName;
    });
  }

  Future<void> refresh() async {
    setState(() {
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
                        : homeBody(height)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget homeBody(double height) {
    return Container(
      height: height - 200,
      child: CustomButton(
        labelName: 'SIGN OUT',
        isLoading: isLoading,
        onPressed: _signOut,
      ),
    );
  }
}
