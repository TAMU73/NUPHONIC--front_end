import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/user_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
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

  bool isLoading = false;
  UserModel user;

  void atStart() async {
    if (widget.user != null) {
      setState(() {
        user = widget.user;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      dynamic result1 = await _auth.getUserInfo(widget.userID);
      print(result1);
      Map<String, dynamic> artistDetail = result1.data['user'];
      print(artistDetail);
      setState(() {
        isLoading = false;
        user = UserModel.fromJson(artistDetail);
      });
    }
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
    return isLoading
        ? loading
        : SafeArea(
          child: Scaffold(
              backgroundColor: backgroundColor,
              body: Column(
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
                              colors: [Colors.black.withOpacity(0.3), Colors.black]),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 20,
                        right: 20,
                        child: CustomAppBar(
                          leadIconPath: 'assets/icons/back_icon.svg',
                          label: "",
                          endChild: SvgPicture.asset('assets/icons/love_big.svg', height: 24,),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              user.username,
                              textAlign: TextAlign.center,
                              style: titleTextStyle.copyWith(
                                fontSize: 30
                              ),
                            ),
                            Text(
                              user.fullName,
                              textAlign: TextAlign.center,
                              style: normalFontStyle.copyWith(color: whitishColor.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    user.userID,
                    style: normalFontStyle,
                  )
                ],
              ),
            ),
        );
  }
}
